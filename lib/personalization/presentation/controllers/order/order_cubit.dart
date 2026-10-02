import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_store/personalization/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../features/dashboard/ecommerce/screens/order/order_repo.dart';
import '../../../../features/home/presentation/controller/checkout/checkout_cubit.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/paypal_webview_screen.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../data/models/order_model.dart';
import '../address_cubit.dart';
import '../cart/cart_cubit.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderCubit({required this._orderRepository}) : super(const OrderState());

  /// Fetch user's order history
  Future<void> fetchUserOrders(BuildContext context) async {
    emit(state.copyWith(status: OrderStatusEnum.loading));
    final result = await _orderRepository.fetchUserOrders();
    result.fold((error) {
      emit(state.copyWith(
        status: OrderStatusEnum.error,
        errorMessage: error.message,
      ));
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: error.message, context: context);
    }, (userOrders) {
      emit(state.copyWith(
        status: OrderStatusEnum.success,
        orders: userOrders,
      ));
    });
  }

  void _goToSuccess(BuildContext context) {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(
      context,
      SuccessScreen.routeName,
      arguments: {
        'image': TImages.successfullyRegisterAnimation,
        'title': 'Payment Success!',
        'subTitle': 'Your item will be shipped soon!',
        'onPressed': (successContext) {
          Navigator.pushNamedAndRemoveUntil(
            successContext,
            NavigationMenu.routeName,
                (route) => false,
          );
        },
      },
    );
  }

  /// Process order and save to Firestore, or pay with PayPal (Supabase + WebView)
  Future<void> processOrder({
    required BuildContext context,
    required double totalAmount,
  }) async {
    TFullScreenLoader.popUpCircular(context);

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    final checkoutCubit = context.read<CheckoutCubit>();
    final paymentMethod = checkoutCubit.state.selectedPaymentMethod;
    final addressCubit = context.read<AddressCubit>();
    final selectedAddress = addressCubit.state.selectedAddress;
    final cartCubit = context.read<CartCubit>();
    final cartItems = cartCubit.state.cartItems;

    // Add Details
    final order = OrderModel(
      id: UniqueKey().toString(),
      userId: userId,
      status: OrderStatus.pending,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      paymentMethod: paymentMethod.name,
      address: AddressModel.fromEntity(selectedAddress),
      deliveryDate: DateTime.now(),
      items: cartItems.toList(),
    );

    // ================= PayPal flow =================
    if (paymentMethod.name.toLowerCase() == 'paypal') {
      bool loaderVisible = true;
      void hideLoader() {
        if (loaderVisible && context.mounted) {
          TFullScreenLoader.stopLoading(context);
        }
        loaderVisible = false;
      }

      try {
        final supabaseAnonKey = dotenv.env['SUPABASE_PUBLISHER_KEY']!;
        const functionBaseUrl = 'https://uvymvisxemcodavxgoks.supabase.co/functions/v1';

        // 1) Create the PayPal order
        final createRes = await http.post(
          Uri.parse('$functionBaseUrl/create-paypal-order'),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseAnonKey,
            'Authorization': 'Bearer $supabaseAnonKey',
          },
          body: jsonEncode({'amount': totalAmount.toStringAsFixed(2)}),
        );

        if (createRes.statusCode != 200) {
          throw 'Failed to create order: ${createRes.body}';
        }

        final data = jsonDecode(createRes.body);
        if (data['success'] != true) {
          throw data['error'] ?? 'PayPal order creation failed';
        }
        final String approvalUrl = data['approvalUrl'];
        final String paypalOrderId = data['orderId'];

        hideLoader();
        if (!context.mounted) return;

        // 2) Open PayPal inside the app and wait for approve / cancel
        final approved = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PayPalWebViewScreen(approvalUrl: approvalUrl),
          ),
        );

        if (approved != true) {
          if (context.mounted) {
            TLoaders.warningSnackBar(
              title: 'Payment cancelled',
              message: 'You cancelled the PayPal payment.',
              context: context,
            );
          }
          return;
        }

        // 3) Capture the approved payment (Using rapid-processor as requested)
        if (!context.mounted) return;
        TFullScreenLoader.popUpCircular(context);
        loaderVisible = true;

        final captureRes = await http.post(
          Uri.parse('$functionBaseUrl/rapid-processor'),
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseAnonKey,
            'Authorization': 'Bearer $supabaseAnonKey',
          },
          body: jsonEncode({'orderId': paypalOrderId}),
        );

        if (captureRes.statusCode != 200) {
          throw 'Failed to capture order: ${captureRes.body}';
        }

        final capData = jsonDecode(captureRes.body);
        if (capData['success'] != true) {
          throw 'Payment was not completed (${capData['error'] ?? 'unknown'})';
        }

        // 4) Payment done: save the order and clear the cart
        final saved = await _orderRepository.saveOrder(order, userId);
        saved.fold<void>(
              (error) => throw error.message,
              (_) {},
        );
        cartCubit.clearCart();

        hideLoader();
        emit(state.copyWith(status: OrderStatusEnum.processingSuccess));
        _goToSuccess(context);
      } catch (e) {
        hideLoader();
        emit(state.copyWith(
          status: OrderStatusEnum.error,
          errorMessage: e.toString(),
        ));
        if (context.mounted) {
          TLoaders.errorSnackBar(title: 'PayPal Error', message: e.toString(), context: context);
        }
      }
      return;
    }

    // --- Normal flow for the other payment methods ---
    final result = await _orderRepository.saveOrder(order, userId);
    result.fold((error) {
      TFullScreenLoader.stopLoading(context);
      emit(state.copyWith(
        status: OrderStatusEnum.error,
        errorMessage: error.message,
      ));
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.message, context: context);
    }, (_) {
      cartCubit.clearCart();
      TFullScreenLoader.stopLoading(context);

      emit(state.copyWith(status: OrderStatusEnum.processingSuccess));
      _goToSuccess(context);
    });
  }
}