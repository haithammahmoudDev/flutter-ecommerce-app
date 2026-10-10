import 'package:fit_store/features/auth/presentation/screens/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email,});
 static const routeName = '/reset-password-screen';
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(AppImages.deliveredEmailIllustration),
                width: HelperFunctions.screenWidth(context) * 0.6,
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),
              Text(email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text('Password Reset Email Sent', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text('Your account security is our priority! We have sent you a secure link to safely change your password and keep your account protected.', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (_)=>false);
                }, child: const Text(AppTexts.done)),
              ), // SizedBox
              const SizedBox(height: AppSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: () {
                  Navigator.pop(context);
                 }, child: const Text(AppTexts.resendEmail)),
              ), // SizedBox
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
