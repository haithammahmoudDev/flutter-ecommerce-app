part of 'products_cubit.dart';

enum FeaturedProductsStatus {loading, success, error }
enum ProductsStatus {loading, success, error }

class ProductsState {
  final ProductsStatus status;
  final FeaturedProductsStatus featuredStatus; // 1. إضافة حالة المنتجات المميزة هنا
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> allProducts;
  final String? errorMessage;

  ProductsState({
    this.status = ProductsStatus.loading,
    this.featuredStatus = FeaturedProductsStatus.loading, // 2. وضع قيمة افتراضية لها
    this.featuredProducts = const [],
    this.allProducts = const [],
    this.errorMessage,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    FeaturedProductsStatus? featuredStatus, // 3. إضافتها في دالة النسخ
    List<ProductEntity>? featuredProducts,
    List<ProductEntity>? allProducts,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      featuredStatus: featuredStatus ?? this.featuredStatus, // 4. تمرير القيمة الجديدة أو الحالية
      featuredProducts: featuredProducts ?? this.featuredProducts,
      allProducts: allProducts ?? this.allProducts,
      errorMessage: errorMessage ?? this.errorMessage, // تم تعديلها لتسمح بمسح الخطأ أو استبداله
    );
  }
}
