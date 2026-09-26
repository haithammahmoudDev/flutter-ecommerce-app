// // Original file: lib/personalization/controllers/theme_controller.dart
// // Converted: GetxController -> Cubit. Logic untouched.
// // State here is just a single bool, so Cubit<bool> is used directly instead of a
// // custom state class - no need to over-engineer a one-field state object.
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart'; // kept only for Get.changeThemeMode() - out of scope for this conversion
// import 'package:get_storage/get_storage.dart';
//
// class ThemeCubit extends Cubit<bool> {
//   ThemeCubit() : super(false) {
//     // Load saved theme preference (was onInit())
//     final isDark = _box.read('isDarkMode') ?? false;
//     // Apply saved theme
//     Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
//     emit(isDark);
//   }
//
//   final GetStorage _box = GetStorage();
//
//   void toggleTheme() {
//     final newValue = !state;
//     // Save preference
//     _box.write('isDarkMode', newValue);
//     // Apply theme
//     Get.changeThemeMode(newValue ? ThemeMode.dark : ThemeMode.light);
//     emit(newValue);
//   }
// }
