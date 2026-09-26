// // Original file: lib/features/checkout/controllers/checkout_controller.dart
// // Converted: GetxController -> Cubit. Logic untouched.
// //
// // ONE DELIBERATE STRUCTURAL CHANGE: `TPaymentTile` (built inside the showModalBottomSheet
// // below) used to reach the controller via `CheckoutController.instance` (a global GetX
// // singleton lookup). Cubits don't have that - and a BlocProvider placed on the page that
// // calls showModalBottomSheet is NOT visible inside the bottom sheet's content (the sheet is
// // inserted as a sibling route on the Navigator's Overlay, not as a descendant of the page's
// // widget tree). So instead of reaching for a wider-scoped/global provider, we just pass this
// // Cubit instance directly into TPaymentTile as a constructor parameter - no context lookup
// // needed, no need to make this "general" beyond where it's actually used.
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../common/widgets/texts/section_heading.dart';
// import '../../../utils/constants/image_strings.dart';
// import '../../../utils/constants/sizes.dart';
// import '../models/payment_method_model.dart';
// import '../screens/widgets/payment_tile.dart';
//
// part 'checkout_state.dart';
//
// class CheckoutCubit extends Cubit<CheckoutState> {
//   CheckoutCubit()
//       : super(CheckoutState(selectedPaymentMethod: PaymentMethodModel(name: 'Paypal', image: TImages.paypal)));
//
//   /// Equivalent of `controller.selectedPaymentMethod.value = paymentMethod`
//   void selectMethod(PaymentMethodModel paymentMethod) {
//     emit(state.copyWith(selectedPaymentMethod: paymentMethod));
//   }
//
//   Future<dynamic> selectPaymentMethod(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (_) => SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(TSizes.lg),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const TSectionHeading(title: 'Select Payment Method', showActionButton: false),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Paypal', image: TImages.paypal)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Google Pay', image: TImages.googlePay)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Apple Pay', image: TImages.applePay)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'VISA', image: TImages.visa)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Master Card', image: TImages.masterCard)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Paytm', image: TImages.paytm)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Paystack', image: TImages.paystack)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               TPaymentTile(cubit: this, paymentMethod: PaymentMethodModel(name: 'Credit Card', image: TImages.creditCard)),
//               const SizedBox(height: TSizes.spaceBtwItems / 2),
//               const SizedBox(height: TSizes.spaceBtwSections),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
