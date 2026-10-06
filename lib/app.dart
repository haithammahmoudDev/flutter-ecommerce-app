  import 'package:fit_store/data/services/notifications/lib/core/navigation/navigation_service.dart';
  import 'package:fit_store/features/auth/presentation/screens/splash_screen/splash_screen.dart';
import 'package:fit_store/personalization/presentation/controllers/theme/theme_controller_provider.dart';
 import 'package:fit_store/routes/app_routes.dart';
 import 'package:fit_store/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

  class App extends StatelessWidget {
    const App({super.key});

    @override
    Widget build(BuildContext context) {
      final themeController = context.watch<ThemeController>();

      return MaterialApp(
        title: 'Starter Template',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        themeMode: themeController.themeMode,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      );
    }
  }