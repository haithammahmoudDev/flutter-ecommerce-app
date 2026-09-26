import 'package:fit_store/features/home/data/model/category_model.dart';
import 'package:fit_store/utils/validators/product_model_adapter.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../features/settings/data/models/user_model_adapter.dart';
import '../../utils/validators/addess_model_adapter.dart';
import '../../utils/validators/category_model_adapter.dart';
import '../../utils/validators/product_attributes_model_adapter.dart';
import 'save_user_by_hive.dart';
import '../../features/cart/models/cart_item_model.dart';
import '../../features/home/data/model/banners_model.dart';
import '../../features/home/data/model/product_model.dart';
import '../../features/home/data/model/product_attribute_model.dart';
import '../../features/home/data/model/product_variation_model.dart';
import '../../features/settings/data/models/user_model.dart';
import '../../features/store/data/models/brand_model.dart';
import '../../personalization/data/models/address_model.dart';
import '../../personalization/data/models/order_model.dart';
import '../../utils/validators/banner_model_adapter.dart';
import '../../utils/validators/brand_model_adapter.dart';
import '../../utils/validators/cart_item_model_adapter.dart';
import '../../utils/validators/order_model_adapter.dart';
import '../../utils/validators/product_variation_model_adapter.dart';

class LocalStorageService {
  static late final LocalRepository<UserModel> userRepo;
  static late final LocalRepository<List<ProductModel>> productsRepo;
  static late final LocalRepository<List<ProductModel>> featuredProductsRepo;
  static late final LocalRepository<List<BrandModel>> brandsRepo;
  static late final LocalRepository<List<BannerModel>> bannersRepo;
  static late final LocalRepository<List<ProductModel>> favoritesRepo;
  static late final LocalRepository<List<CartItemModel>> cartRepo;
  static late final LocalRepository<List<AddressModel>> addressRepo;
  static late final LocalRepository<List<OrderModel>> ordersRepo;
  static late final LocalRepository<List<CategoryModel>> categoriesRepo;
  static late final LocalRepository<List<ProductModel>> categoriesProductsRepo;

  // ✅ مستودع الأقسام الفرعية الثابت والمستقر
  static late final LocalRepository<List<CategoryModel>> subCategoriesRepo;

  // ✅ مستودع معرفات المفضلة فقط (id -> bool) لعرض القلب فوراً في أي مكان
  static late final LocalRepository<Map<String, bool>> favoriteIdsRepo;

  /// Central initializer for all Hive boxes.
  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<UserModel>(UserModelAdapter());
    }  if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter<ProductModel>(ProductModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter<BrandModel>(BrandModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter<BannerModel>(BannerModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter<CartItemModel>(CartItemModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) { // ✅ Ensure AddressAdapter is registered
      Hive.registerAdapter<AddressModel>(AddressModelAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) { // ✅ Add OrderModelAdapter registration here!
      Hive.registerAdapter<OrderModel>(OrderModelAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter<ProductAttributeModel>(ProductAttributeModelAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter<ProductVariationModel>(ProductVariationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    }

    // ── User ───────────────────────────────────────────────────────────────
    userRepo = LocalRepository<UserModel>(
      boxName: 'user_box',
      key: 'current_user',
    );
    await userRepo.init<UserModel>(
      adapter: UserModelAdapter(),
      typeId: 0,
    );

    // ── Products (home) ────────────────────────────────────────────────────
    productsRepo = LocalRepository<List<ProductModel>>(
      boxName: 'products_box',
      key: 'products_store',
      fromStorage: (raw) => (raw as List).cast<ProductModel>(),
    );
    await productsRepo.init<ProductModel>(
      adapter: ProductModelAdapter(),
      typeId: 1,
    );

    featuredProductsRepo = LocalRepository<List<ProductModel>>(
      boxName: 'products_box',
      key: 'featured_products_store',
      fromStorage: (raw) => (raw as List).cast<ProductModel>(),
    );
    await featuredProductsRepo.init<ProductModel>(
      adapter: ProductModelAdapter(),
      typeId: 1,
    );

    // ── Brands ─────────────────────────────────────────────────────────────
    brandsRepo = LocalRepository<List<BrandModel>>(
      boxName: 'brands_box',
      key: 'brands_store',
      fromStorage: (raw) => (raw as List).cast<BrandModel>(),
    );
    await brandsRepo.init<BrandModel>(
      adapter: BrandModelAdapter(),
      typeId: 2,
    );

    // ── Banners ────────────────────────────────────────────────────────────
    bannersRepo = LocalRepository<List<BannerModel>>(
      boxName: 'banners_box',
      key: 'banners_app',
      fromStorage: (raw) => (raw as List).cast<BannerModel>(),
    );
    await bannersRepo.init<BannerModel>(
      adapter: BannerModelAdapter(),
      typeId: 3,
    );

    // ── Favorites (full products cache) ───────────────────────────────────
    favoritesRepo = LocalRepository<List<ProductModel>>(
      boxName: 'favorites_box',
      key: 'favorite_items',
      fromStorage: (raw) => (raw as List).cast<ProductModel>(),
    );
    await favoritesRepo.init<ProductModel>(
      adapter: ProductModelAdapter(),
      typeId: 1,
    );

    // ── Favorites (ids map only) ────────────────────────────────────────────
    // نفس favorites_box بس بمفتاح مختلف؛ Map<String, bool> عادية فمش محتاجة
    // TypeAdapter، فبنفتحها بـ initRaw() بدل init().
    favoriteIdsRepo = LocalRepository<Map<String, bool>>(
      boxName: 'favorites_box',
      key: 'favorite_ids',
      fromStorage: (raw) => Map<String, bool>.from(raw as Map),
    );
    await favoriteIdsRepo.initRaw();

    // ── Cart ───────────────────────────────────────────────────────────────
    cartRepo = LocalRepository<List<CartItemModel>>(
      boxName: 'cart_box',
      key: 'cart_items',
      fromStorage: (raw) => (raw as List).cast<CartItemModel>(),
    );
    await cartRepo.init<CartItemModel>(
      adapter: CartItemModelAdapter(),
      typeId: 4,
    );

    // ── Addresses ──────────────────────────────────────────────────────────
    addressRepo = LocalRepository<List<AddressModel>>(
      boxName: 'address_box',
      key: 'my_address',
      fromStorage: (raw) => (raw as List).cast<AddressModel>(),
    );
    await addressRepo.init<AddressModel>(
      adapter: AddressModelAdapter(),
      typeId: 5,
    );

    // ── Orders ─────────────────────────────────────────────────────────────
    ordersRepo = LocalRepository<List<OrderModel>>(
      boxName: 'orders_box',
      key: 'my_orders',
      fromStorage: (raw) => (raw as List).cast<OrderModel>(),
    );
    await ordersRepo.init<OrderModel>(
      adapter: OrderModelAdapter(),
      typeId: 6,
    );

    // ── Categories ─────────────────────────────────────────────────────────
    categoriesRepo = LocalRepository<List<CategoryModel>>(
      boxName: 'categories_box',
      key: 'my_categories',
      fromStorage: (raw) => (raw as List).cast<CategoryModel>(),
    );
    await categoriesRepo.init<CategoryModel>(
      adapter: CategoryModelAdapter(),
      typeId: 9,
    );

    // ── Sub-Categories ─────────────────────────────────────────────────────
    subCategoriesRepo = LocalRepository<List<CategoryModel>>(
      boxName: 'sub_categories_box',
      key: 'default_sub_categories',
      fromStorage: (raw) => (raw as List).cast<CategoryModel>(),
    );
    await subCategoriesRepo.init<CategoryModel>(
      adapter: CategoryModelAdapter(),
      typeId: 9,
    );

    categoriesProductsRepo = LocalRepository<List<ProductModel>>(
      boxName: 'categories_products_box',
      key: 'default_categories_products',
      fromStorage: (raw) => (raw as List).cast<ProductModel>(),
    );
    await categoriesProductsRepo.init<ProductModel>(
      adapter: ProductModelAdapter(),
      typeId: 1,
    );
  }
}