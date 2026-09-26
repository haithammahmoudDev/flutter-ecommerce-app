// import 'package:flutter/cupertino.dart';
//
// class NavigationService {
//   static final navigatorKey = GlobalKey<NavigatorState>();
//
//   static Future<dynamic> pushNamed(String route,{Object? arguments}) {
//     return navigatorKey.currentState!
//         .pushNamed(route, arguments: arguments);
//   }
//
//   static Future<dynamic> pushNamedAndRemoveUntil(
//       String route, {
//         Object? arguments,
//       }) {
//     return navigatorKey.currentState!.pushNamedAndRemoveUntil(
//       route,
//           (route) => false,
//       arguments: arguments,
//     );
//   }
//
//   static void pop<T extends Object?>([T? result]) {
//     navigatorKey.currentState?.pop(result);
//   }
// }