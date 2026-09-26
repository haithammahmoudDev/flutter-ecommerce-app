// // Original file: lib/features/cart/controllers/cart_controller.dart
// // Converted: GetxController -> Cubit. Business logic/arithmetic is 100% identical.
// // The ONLY structural change: because Cubit state must be immutable, places that used
// // to mutate a CartItemModel in place (`cartItem.quantity += 1` + `cartItems.refresh()`)
// // now build a new CartItemModel via `copyWith()` and emit a new list. The math and
// // the order of operations are untouched.
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart'; // kept for Get.defaultDialog/Get.back (a dialog + navigation,
// // not state management) and the `.isEqual` num extension - out of scope for this conversion.
//
// import '../../dashboard/ecommerce/controllers/dummy_data.dart';
// import '../../products/models/product_model.dart';
// import '../../products/models/product_variation_model.dart';
// import '../models/cart_item_model.dart';
//
// part 'cart_state.dart';
//
// class CartCubit extبends Cubit<CartState> {
//   /// -- Used in constructor to initialize dummy data only (same as onInit() did)
//   CartCubit()
//       : super(CartState(
//           cartItems: TDummyData.cart.items,
//           totalCartPrice: TDummyData.cart.items
//               .map((e) => e.price! * e.quantity)
//               .fold(0, (previous, current) => previous + current),
//         ));
//
//   void addSingleItemToCart(ProductModel product, ProductVariationModel variation) {
//     final existingIndex = state.cartItems.indexWhere(
//       (item) => item.productId == product.id && item.variationId == variation.id,
//     );
//
//     final updatedItems = List<CartItemModel>.from(state.cartItems);
//     double newTotalCartPrice = state.totalCartPrice;
//
//     // If its a new product then add it to the cart.
//     if (existingIndex == -1) {
//       updatedItems.add(
//         CartItemModel(
//           productId: product.id,
//           variationId: variation.id,
//           quantity: 1,
//           title: product.title,
//           image: product.thumbnail,
//           price: product.salePrice ?? product.price,
//           brandName: product.brand!.name,
//         ),
//       );
//     } else {
//       // Increment Cart
//       updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
//         quantity: updatedItems[existingIndex].quantity + 1,
//       );
//     }
//
//     // Increment Total Cart Price
//     newTotalCartPrice += calculateSingleProductTotal(product.price, 1);
//
//     emit(state.copyWith(cartItems: updatedItems, totalCartPrice: newTotalCartPrice));
//   }
//
//   void addMultipleItemsToCart(ProductModel product, ProductVariationModel variation, int quantity) {
//     final existingIndex = state.cartItems.indexWhere(
//       (item) => item.productId == product.id && item.variationId == variation.id,
//     );
//
//     final updatedItems = List<CartItemModel>.from(state.cartItems);
//     double newTotalCartPrice = state.totalCartPrice;
//
//     // If its a new product Simply add quantity
//     if (existingIndex == -1) {
//       updatedItems.add(
//         CartItemModel(
//           productId: product.id,
//           variationId: variation.id,
//           quantity: quantity,
//           title: product.title,
//           image: variation.id.isEmpty ? product.thumbnail : variation.image,
//           price: variation.id.isEmpty ? product.salePrice ?? product.price : variation.salePrice ?? variation.price,
//           brandName: product.brand!.name,
//           selectedVariation: variation.id.isNotEmpty ? variation.attributeValues : null,
//         ),
//       );
//       // Increment Total Cart Price
//       newTotalCartPrice += calculateSingleProductTotal(product.price, quantity);
//     } else {
//       final existingItem = updatedItems[existingIndex];
//       // Check if you need to remove or add items to the cart
//       if (existingItem.quantity > quantity) {
//         // Subtract
//         newTotalCartPrice -= calculateSingleProductTotal(existingItem.price!, quantity);
//       } else {
//         // Increment
//         newTotalCartPrice += calculateSingleProductTotal(product.price, quantity);
//       }
//
//       updatedItems[existingIndex] = existingItem.copyWith(quantity: quantity);
//     }
//
//     emit(state.copyWith(cartItems: updatedItems, totalCartPrice: newTotalCartPrice));
//   }
//
//   void removeItemFromCart(CartItemModel cartItem) {
//     Get.defaultDialog(
//       title: 'Remove Product',
//       middleText: 'Are you sure you want to remove this product?',
//       onConfirm: () {
//         // Remove the item from the cart
//         final updatedItems = List<CartItemModel>.from(state.cartItems)..remove(cartItem);
//         // Remove the price from the total
//         final newTotalCartPrice = state.totalCartPrice - calculateSingleProductTotal(cartItem.price!, cartItem.quantity);
//
//         emit(state.copyWith(cartItems: updatedItems, totalCartPrice: newTotalCartPrice));
//         Get.back();
//       },
//       barrierDismissible: true,
//     );
//   }
//
//   void updateCartItemQuantity(CartItemModel cartItem, int newQuantity) {
//     if (newQuantity.isEqual(0)) {
//       removeItemFromCart(cartItem);
//     } else {
//       final existingIndex = state.cartItems.indexWhere(
//         (item) => item.productId == cartItem.productId && item.variationId == cartItem.variationId,
//       );
//       if (existingIndex == -1) return;
//
//       double newTotalCartPrice = state.totalCartPrice;
//
//       // If new Quantity is greater means add & if less then [cartItem.quantity] means subtract
//       if (cartItem.quantity < newQuantity) {
//         // Add
//         newTotalCartPrice += calculateSingleProductTotal(cartItem.price!, 1);
//       } else if (cartItem.quantity > newQuantity) {
//         // Subtract
//         newTotalCartPrice -= calculateSingleProductTotal(cartItem.price!, 1);
//       }
//
//       final updatedItems = List<CartItemModel>.from(state.cartItems);
//       updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(quantity: newQuantity);
//
//       emit(state.copyWith(cartItems: updatedItems, totalCartPrice: newTotalCartPrice));
//     }
//   }
//
//   double calculateSingleProductTotal(double productPrice, int quantity) {
//     return productPrice * quantity;
//   }
//
//   String calculateTotalCartItems() {
//     return state.cartItems
//         .map((element) => element.quantity)
//         .fold(0, (previousValue, element) => previousValue + element)
//         .toString();
//   }
//
//   int calculateSingleProductCartEntries(String productId, String variationId) {
//     int cartEntries = 0;
//
//     // If variation is not null get variation total
//     if (variationId.isEmpty) {
//       cartEntries = state.cartItems
//           .where((item) => item.productId == productId)
//           .map((e) => e.quantity)
//           .fold(0, (previousQuantity, nextQuantity) => previousQuantity + nextQuantity);
//     } else {
//       cartEntries = state.cartItems
//           .where((item) => item.productId == productId && item.variationId == variationId)
//           .map((e) => e.quantity)
//           .fold(0, (previousQuantity, nextQuantity) => previousQuantity + nextQuantity);
//     }
//
//     return cartEntries;
//   }
// }
