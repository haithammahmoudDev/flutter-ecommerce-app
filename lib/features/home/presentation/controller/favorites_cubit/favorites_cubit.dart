import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fit_store/features/home/domain/repos/home_repo.dart';
import 'package:fit_store/common/preferences/loacal_storage_service.dart';
import 'package:fit_store/utils/popups/loaders.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._homeRepo) : super(const FavoritesState()) {
    _initFavorites();
  }

  final HomeRepo _homeRepo;

  /// تحميل معرفات المفضلة + آخر نسخة محفوظة من المنتجات من التخزين المحلي
  /// عند إنشاء الـ Cubit، ثم تحديثها في الخلفية.
  Future<void> _initFavorites() async {
    final Map<String, bool> favorites =
        LocalStorageService.favoriteIdsRepo.getData() ?? {};

    final cachedProducts = LocalStorageService.favoritesRepo.getData() ?? [];
    final cachedEntities = cachedProducts.map((e) => e.toEntity()).toList();

    emit(state.copyWith(
      favorites: favorites,
      favoriteProducts: cachedEntities,
      status: cachedEntities.isNotEmpty
          ? FavoritesStatus.success
          : FavoritesStatus.initial,
    ));

    if (favorites.isNotEmpty) {
      await fetchFavoriteProducts();
    }
  }

  /// التحقق السريع من حالة المنتج
  bool isFavourite(String productId) => state.favorites[productId] ?? false;

  /// إضافة أو إزالة المنتج: تحديث تفاؤلي فوري للواجهة، ثم حفظ محلي ومزامنة
  Future<void> toggleFavoriteProduct(
      String productId, BuildContext context) async {
    if (productId.trim().isEmpty) return;

    final updated = Map<String, bool>.from(state.favorites);
    final isAdding = !updated.containsKey(productId);

    if (isAdding) {
      updated[productId] = true;
    } else {
      updated.remove(productId);
    }

    await LocalStorageService.favoriteIdsRepo.saveData(updated);

    emit(state.copyWith(favorites: updated));

    Loaders.customToast(
      message: isAdding
          ? 'Product has been added to the Wishlist.'
          : 'Product has been removed from the Wishlist.',
      context: context,
    );

    await fetchFavoriteProducts();
  }

  /// جلب منتجات المفضلة: المصدر محلي بالكامل (productsRepo/featuredProductsRepo
  /// عبر الـ Repo)، فلا حاجة لفحص الاتصال بالإنترنت هنا.
  Future<void> fetchFavoriteProducts() async {
    if (state.favorites.isEmpty) {
      await LocalStorageService.favoritesRepo.clearData();
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favoriteProducts: [],
      ));
      return;
    }

    // نمنع ظهور الـ Shimmer لو أصلاً عندنا منتجات معروضة بالفعل على الشاشة
    // (زي حالة إعادة الجلب عند فتح شاشة الـ Wishlist)، عشان نتفادى الوميض.
    if (state.favoriteProducts.isEmpty) {
      emit(state.copyWith(status: FavoritesStatus.loading));
    }

    final ids = state.favorites.keys.toList();
    final result = await _homeRepo.getFavouriteProducts(productIds: ids);

    result.fold(
          (failure) {
        emit(state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        ));
      },
          (products) {
        emit(state.copyWith(
          status: FavoritesStatus.success,
          favoriteProducts: products,
        ));
      },
    );
  }
}