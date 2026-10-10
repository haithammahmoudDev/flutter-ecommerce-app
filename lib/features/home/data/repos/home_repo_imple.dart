import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fit_store/common/local_storage/local_reo.dart';
import 'package:fit_store/features/home/domain/entities/banners_entity.dart';
import 'package:fit_store/features/home/domain/entities/product_entity.dart';
import 'package:fit_store/features/home/domain/repos/home_repo.dart';
import 'package:fit_store/features/home/data/model/product_model.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../../../common/errors/failure.dart';
import '../../../../common/network/firebase/database_services.dart';
import '../../../../common/local_storage/loacal_storage_service.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/search/search_utils.dart';
import '../../domain/entities/categories_entity.dart';
import '../model/category_model.dart';
import '../model/banners_model.dart';

class HomeRepoImple implements HomeRepo {
  final DatabaseServices _databaseServices;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  HomeRepoImple({required this._databaseServices});

  @override
  Future<Either<Failure, List<BannerEntity>>> fetchBanners() async {
    try {
      final List<Map<String, dynamic>> banners = await _databaseServices
          .getData(path: 'Banners');
      final List<BannerModel> bannerModelList =
      banners.map((banner) => BannerModel.fromFirebaseJson(banner)).toList();
      final bannerEntities = bannerModelList.map((e) => e.toEntity()).toList();
      await LocalStorageService.bannersRepo.saveData(bannerModelList);
      return right(bannerEntities);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedProducts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(4)
          .get();

      final List<ProductModel> featuredProducts = snapshot.docs
          .map((doc) => ProductModel.fromFirebaseJson(doc.data(), doc.id))
          .toList();
      final List<ProductEntity> FeaturedProductsEntity = featuredProducts.map((e)=>e.toEntity()).toList();
      await LocalStorageService.featuredProductsRepo.saveData(featuredProducts);
      return right(FeaturedProductsEntity);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchAllProducts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Products')
          .get();

      final List<ProductModel> allProducts = snapshot.docs
          .map((doc) => ProductModel.fromFirebaseJson(doc.data(), doc.id))
          .toList();
      final List<ProductEntity> allProductsEntity = allProducts.map((e)=>e.toEntity()).toList();
      await LocalStorageService.productsRepo.saveData(allProducts);
      return right(allProductsEntity);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProductsByQuery({
    required Map<String, dynamic> query,
  }) async {

    final bool isConnected = await NetworkManager.instance.isConnected();

    if (!isConnected) {
      return left(const NetworkFailure('لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.'));
    }

    try {
      Query<Map<String, dynamic>> queryRef = _db.collection('Products');

      query.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            if (value.isNotEmpty) {
              queryRef = queryRef.where(key, whereIn: value);
            }
          } else {
            queryRef = queryRef.where(key, isEqualTo: value);
          }
        }
      });

      final QuerySnapshot<Map<String, dynamic>> snapshot = await queryRef.get();


      final List<ProductModel> productModels = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromFirebaseJson(data, doc.id);
      }).toList();

      final List<ProductEntity> productEntities = productModels.map((e) => e.toEntity()).toList();

      return right(productEntities);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'حدث خطأ أثناء جلب البيانات من الخادم.'));
    } catch (e) {
      return left(const ServerFailure('Something went wrong. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsForBrand({
    required String brandId,
    int limit = -1,
  }) async {
    if (!await NetworkManager.instance.isConnected()) {
      return left(
          NetworkFailure('لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.'));
    }

    try {
      Query query = FirebaseFirestore.instance
          .collection('Products')
          .where('Brand.Id', isEqualTo: brandId);

      if (limit != -1) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      final List<ProductEntity> products = querySnapshot.docs
          .map((doc) =>
          ProductModel.fromFirebaseJson(doc.data() as Map<String, dynamic>, doc.id))
          .map((e) => e.toEntity())
          .toList();

      return right(products);
    } on FirebaseException catch (e) {
      return left(
          ServerFailure(e.message ?? 'حدث خطأ أثناء جلب البيانات من الخادم.'));
    } catch (e) {
      return left(
          const ServerFailure('Something went wrong. Please try again.'));
    }
  }

   @override
  Future<Either<Failure, List<ProductEntity>>> getFavouriteProducts({
    required List<String> productIds,
  }) async {
    final validIds =
    productIds.where((id) => id.trim().isNotEmpty).toSet().toList();
    if (validIds.isEmpty) return right([]);

    try {
      late final List<ProductModel> allCachedProducts;
      final List<ProductModel> CachedAllProducts =
          LocalStorageService.productsRepo.getData() ?? [];
      final List<ProductModel> CachedFeaturedProducts =
          LocalStorageService.featuredProductsRepo.getData() ?? [];

      if(CachedAllProducts.isNotEmpty) {
        allCachedProducts = CachedAllProducts;
      }else if(CachedFeaturedProducts.isNotEmpty){
        allCachedProducts = CachedFeaturedProducts;
      }else{
        return const Right([]);
      }

      final idsSet = validIds.toSet();
      final List<ProductModel> favoriteProductModels = allCachedProducts
          .where((product) => idsSet.contains(product.id))
          .toList();

      await LocalStorageService.favoritesRepo.saveData(favoriteProductModels);

      final List<ProductEntity> favoriteProducts =
      favoriteProductModels.map((e) => e.toEntity()).toList();

      return right(favoriteProducts);
    } catch (e) {
      return left(
          const ServerFailure('Something went wrong. Please try again.'));
    }
  }
  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return right([]);

    try {
       List<ProductModel> candidates =
          LocalStorageService.productsRepo.getData() ?? [];

       if (candidates.isEmpty) {
        if (!await NetworkManager.instance.isConnected()) {
          return left(const NetworkFailure(
              'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.'));
        }
        final List<Map<String, dynamic>> raw =
        await _databaseServices.getData(path: 'Products');
        candidates = raw
            .map((m) => ProductModel.fromFirebaseJson(m, m['id'] as String))
            .toList();
        await LocalStorageService.productsRepo.saveData(candidates);
      }

      final entities = candidates.map((e) => e.toEntity()).toList();

       final docs = entities
          .map((p) => SearchDoc.build(
        p,
        title: p.title,
        brand: p.brand?.name ?? '',
      ))
          .toList();

      final results = SearchUtils.searchIndex(docs, q);

      return right(results);
    } on FirebaseException catch (e) {
      return left(
          ServerFailure(e.message ?? 'حدث خطأ أثناء جلب البيانات من الخادم.'));
    } catch (e) {
      return left(const ServerFailure('Something went wrong. Please try again.'));
    }
  }
}