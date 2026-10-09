 import 'package:dartz/dartz.dart';
import 'package:fit_store/common/network/firebase/database_services.dart';
import 'package:fit_store/features/home/data/model/category_model.dart';
import 'package:fit_store/features/home/data/model/product_model.dart';
import 'package:fit_store/features/home/domain/entities/product_entity.dart';

import '../../../../common/errors/failure.dart';
import '../../../../common/local_storage/local_storage.dart';
import '../entities/banners_entity.dart';
import '../entities/categories_entity.dart';

abstract interface class HomeRepo {
   Future<Either<Failure, List<BannerEntity>>> fetchBanners();
  Future<Either<Failure, List<ProductEntity>>> fetchFeaturedProducts();
  Future<Either<Failure, List<ProductEntity>>> fetchProductsByQuery({required Map<String, dynamic> query});
   Future<Either<Failure, List<ProductEntity>>> getProductsForBrand({
    required String brandId,
    int limit = -1,
  });
  Future<Either<Failure, List<ProductEntity>>> getFavouriteProducts({
    required List<String> productIds,
  });
   Future<Either<Failure, List<ProductEntity>>> fetchAllProducts();
   Future<Either<Failure, List<ProductEntity>>> searchProducts({
     required String query,
   });
}