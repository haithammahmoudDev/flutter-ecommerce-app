part of 'all_products_cubit.dart';

enum AllProductsStatus { initial, loading, success, error }

class AllProductsState {
  final AllProductsStatus status;
  final List<ProductEntity> products;
  final String errorMessage;
  final String selectedSortOption; // حقل حفظ خيار الترتيب النشط في القائمة المنسدلة

  AllProductsState({
    this.status = AllProductsStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.selectedSortOption = 'Name', // القيمة الابتدائية الافتراضية للفرز
  });

  AllProductsState copyWith({
    AllProductsStatus? status,
    List<ProductEntity>? products,
    String? errorMessage,
    String? selectedSortOption,
  }) {
    return AllProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
    );
  }
}
