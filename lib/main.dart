import 'package:firebase_core/firebase_core.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/images_cubit.dart';
import 'package:fit_store/features/settings/data/models/user_model.dart';
import 'package:fit_store/features/settings/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fit_store/personalization/data/models/address_model.dart';
import 'package:fit_store/personalization/data/models/order_model.dart';
import 'package:fit_store/personalization/presentation/controllers/address_cubit.dart';
import 'package:fit_store/personalization/presentation/controllers/cart/cart_cubit.dart';
import 'package:fit_store/personalization/presentation/controllers/order/order_cubit.dart';
import 'package:fit_store/personalization/presentation/controllers/theme/theme_controller_provider.dart';
import 'package:fit_store/routes/custom_routes/user_model_entity.dart';
import 'package:fit_store/utils/validators/addess_model_adapter.dart';
import 'package:fit_store/utils/validators/banner_model_adapter.dart';
import 'package:fit_store/utils/validators/brand_model_adapter.dart';
import 'package:fit_store/utils/validators/cart_item_model_adapter.dart';
import 'package:fit_store/common/preferences/loacal_storage_service.dart';
import 'package:fit_store/utils/validators/order_model_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart'; // 1. Make sure provider is imported
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'common/di/injection_container.dart';
import 'common/local_storage/local_storage.dart';
import 'common/preferences/preferences_manager.dart';
import 'common/preferences/save_user_by_hive.dart';
import 'data/services/notifications/notification_service.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/cart/models/cart_item_model.dart';
import 'features/home/data/model/banners_model.dart';
import 'features/home/data/model/product_model.dart';
import 'features/home/presentation/controller/all_products/all_products_cubit.dart';
import 'features/home/presentation/controller/categories_cubit/categories_cubit.dart';
import 'features/home/presentation/controller/favorites_cubit/favorites_cubit.dart';
import 'features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'features/store/data/models/brand_model.dart';
import 'features/store/presentation/controller/brand_cubit/brand_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHER_KEY']!,
  );
  await PreferencesManager().init();
  await LocalStorageService.init();
  await initDependencies();

  // Initialize theme controller and load preference
  final themeController = ThemeController();
  await themeController.init();

  TNotificationService();

  runApp(
    // 2. Wrap MultiBlocProvider with ChangeNotifierProvider.value
    ChangeNotifierProvider.value(
      value: themeController,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<AllProductsCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<FavoritesCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<AddressCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<CartCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<UserCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<ImagesCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<OrderCubit>(),
          ),
          BlocProvider(create: (context) => sl<CategoriesCubit>()),
          BlocProvider(create: (context) => sl<BrandCubit>()),
          BlocProvider(create: (context) => sl<ProductsCubit>()),
        ],
        child: const App(),
      ),
    ),
  );
}