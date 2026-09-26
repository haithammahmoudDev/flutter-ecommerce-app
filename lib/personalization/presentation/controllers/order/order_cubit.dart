import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_store/personalization/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../features/dashboard/ecommerce/screens/order/order_repo.dart';
import '../../../../features/home/presentation/controller/checkout/checkout_cubit.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../data/models/order_model.dart';
import '../address_cubit.dart';
import '../cart/cart_cubit.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderCubit({ required this._orderRepository}) : super(const OrderState());

  /// Fetch user's order history
  Future<void> fetchUserOrders(BuildContext context) async {
      emit(state.copyWith(status: OrderStatusEnum.loading));
      final result = await _orderRepository.fetchUserOrders();
      result.fold((error){
        emit(state.copyWith(
          status: OrderStatusEnum.error,
          errorMessage: error.message,
        ));
        TLoaders.warningSnackBar(title: 'Oh Snap!', message: error.message, context: context);
      }, (userOrders){
        emit(state.copyWith(
          status: OrderStatusEnum.success,
          orders: userOrders,
        ));
      });
  }

  /// Process order and save to Firestore
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

     final result = await _orderRepository.saveOrder(order, userId);
     result.fold((error){
       TFullScreenLoader.stopLoading(context);
       emit(state.copyWith(
         status: OrderStatusEnum.error,
         errorMessage: error.message,
       ));
       TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.message, context: context);
     }, (_){
       cartCubit.clearCart();
       TFullScreenLoader.stopLoading(context);

       emit(state.copyWith(status: OrderStatusEnum.processingSuccess));

       if (context.mounted) {
         Navigator.pushReplacementNamed(
           context,
           SuccessScreen.routeName,
           arguments: {
             'image': TImages.successfullyRegisterAnimation,
             'title': 'Payment Success!',
             'subTitle': 'Your item will be shipped soon!',
             'onPressed': (successContext) { // استقبال الـ context النشط من شاشة النجاح
               Navigator.pushNamedAndRemoveUntil(
                 successContext,
                 NavigationMenu.routeName,
                     (route) => false,
               );
             },
           },
         );
       }});
  }
}