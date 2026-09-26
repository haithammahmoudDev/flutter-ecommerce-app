// // Original file: lib/personalization/screens/all_users/all_users_screen.dart
// // Converted: Get.put(UserController()) -> context.read<UserCubit>()
// // ⚠️ `controller.getAllUsers()` is called below but was NOT defined anywhere in the
// // UserController code you sent me - so it's not in UserCubit either. This file will not
// // compile until you add a `getAllUsers()` method to UserCubit (same logic as whatever
// // was in your original UserController - just send it and I'll wire it in).
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart'; // kept only for Get.back() navigation - out of scope
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
//
//  import '../../../../../utils/constants/colors.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../../../personalization/controllers/user_cubit.dart';
//
// class AllUsers extends StatelessWidget {
//   const AllUsers({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<UserCubit>();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: TColors.primary,
//         leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left_solid)),
//         title: Text("Users", style: Theme.of(context).textTheme.headlineMedium),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(TSizes.defaultSpace),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("All Users", style: Theme.of(context).textTheme.headlineMedium),
//               const SizedBox(height: 20.0),
//               FutureBuilder<List<UserModel>>(
//                 future: controller.getAllUsers(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (c, index) {
//                           return Column(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(10.0),
//                                 decoration: BoxDecoration(
//                                   color: TColors.primary.withValues(alpha: 0.1),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   border: const Border(bottom: BorderSide(), top: BorderSide(), left: BorderSide(), right: BorderSide()),
//                                 ),
//                                 child: ListTile(
//                                   leading: Container(
//                                     padding: const EdgeInsets.all(10.0),
//                                     decoration: const BoxDecoration(shape: BoxShape.circle, color: TColors.primary),
//                                     child: const Icon(LineAwesomeIcons.user, color: Colors.black),
//                                   ),
//                                   title: Text(snapshot.data![index].fullName, style: Theme.of(context).textTheme.headlineMedium),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [Text(snapshot.data![index].phoneNumber), Text(snapshot.data![index].email, overflow: TextOverflow.ellipsis)],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                             ],
//                           );
//                         },
//                       );
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text(snapshot.error.toString()));
//                     } else {
//                       return const Center(child: Text('Something went wrong'));
//                     }
//                   } else {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }