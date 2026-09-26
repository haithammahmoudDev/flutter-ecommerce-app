// // Original file: lib/personalization/screens/profile/re_authenticate_otp_screen.dart
// // Converted: OTPController.instance -> context.read<OtpCubit>(), Obx -> BlocBuilder
// // (Uses the same OtpCubit from the authentication feature - already converted earlier.)
// // NOTE: fixed a pre-existing typo in the original (`@overridea` -> `@override`); that
// // wasn't valid Dart and wouldn't have compiled either way, so it isn't a "logic" change.
// import 'package:fit_store/utils/constants/colors.dart';
// import 'package:fit_store/utils/constants/sizes.dart';
// import 'package:fit_store/utils/constants/text_strings.dart';
// import 'package:fit_store/utils/helpers/helper_functions.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ReAuthenticatePhoneOtpScreen extends StatelessWidget {
//   const ReAuthenticatePhoneOtpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Scaffold(
//       backgroundColor: dark ? TColors.dark : TColors.white,
//       body: Container(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               TTexts.tOtpTitle,
//               style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
//             ),
//             Text(TTexts.tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 40.0),
//             const Text(TTexts.tOtpMessage, textAlign: TextAlign.center),
//             const SizedBox(height: 20.0),
//             OtpTextField(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 numberOfFields: 6,
//                 fillColor: Colors.black.withValues(alpha: 0.1),
//                 filled: true,
//                 onSubmit: (code) {
//                   controller.otp = code;
//                   controller.verifyOTP();
//                 }),
//             const SizedBox(height: 20.0),
//             BlocBuilder<OtpCubit, OtpState>(
//               builder: (context, state) {
//                 return SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       onPressed: state.loader ? () {} : () => controller.verifyOTP(),
//                       child: const Text(TTexts.tNext)),
//                 );
//               },
//             ),
//             const SizedBox(height: 20.0),
//             Center(
//               child: BlocBuilder<OtpCubit, OtpState>(
//                 builder: (context, state) {
//                   return RichText(
//                     text: TextSpan(
//                       text: TTexts.thenLets,
//                       style: Theme.of(context).textTheme.titleSmall,
//                       children: [
//                         TextSpan(
//                           text: TTexts.resendOTP,
//                           recognizer: (state.secondsRemaining > 0) ? null : TapGestureRecognizer()
//                             ?..onTap = () => controller.resendOTP(),
//                           style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                               color: (state.secondsRemaining > 0) ? TColors.darkGrey : TColors.primary),
//                         ),
//                         if (state.secondsRemaining > 0)
//                           TextSpan(
//                             text: " ${TTexts.inText} ${state.secondsRemaining}",
//                             style: Theme.of(context).textTheme.titleSmall?.copyWith(color: TColors.darkGrey),
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }