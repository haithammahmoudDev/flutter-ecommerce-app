// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../../../utils/constants/sizes.dart';
//
// class ProfileMenuShimmer extends StatelessWidget {
//   const ProfileMenuShimmer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // تحديد الألوان تلقائياً بناءً على ثيم التطبيق (مظلم أو مضيء)
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
//     final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
//
//     return Shimmer.fromColors(
//       baseColor: baseColor,
//       highlightColor: highlightColor,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems / 1.5),
//         child: Row(
//           children: [
//             // 1. Shimmer الخاص بالعنوان (Title)
//             Expanded(
//               flex: 3,
//               child: Container(
//                 height: 12,
//                 margin: const EdgeInsets.only(right: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),
//
//             // 2. Shimmer الخاص بالقيمة (Value)
//             Expanded(
//               flex: 5,
//               child: Container(
//                 height: 14,
//                 margin: const EdgeInsets.only(right: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),
//
//             // 3. Shimmer الخاص بالأيقونة (Icon)
//             const Expanded(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: SizedBox(
//                   height: 18,
//                   width: 18,
//                   child: ColoredBox(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }