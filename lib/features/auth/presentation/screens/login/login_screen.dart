
import 'package:fit_store/features/auth/presentation/bloc/email_auth_bloc/email_auth_bloc.dart';
import 'package:fit_store/features/auth/presentation/cubit/social_auth-bloc/social_auth_cubit.dart';
import 'package:fit_store/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/form/form_divider_widget.dart';
import '../../../../../common/widgets/form/form_header_widget.dart';
import '../../../../../common/widgets/form/social_footer.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../signup/signup_screen.dart';
import '../signup/verify_email.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const routeName = 'login_screen';
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
  providers: [
    BlocProvider(
     create: (context) => sl<EmailAuthBloc>(),
),
    BlocProvider(
      create: (context) => sl<SocialAuthCubit>(),
    ),
  ],
    child: SafeArea(
             child: Scaffold(
               body: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.all(TSizes.defaultSpace),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const FormHeaderWidget(image: TImages.tWelcomeScreenImage, title: AppTexts.tLoginTitle, subTitle: AppTexts.tLoginSubTitle),
                         LoginFormWidget(),
                       const FormDividerWidget(),
                       SocialFooter(text1: AppTexts.tDontHaveAnAccount,
                           text2: AppTexts.tSignup,
                           onPressed: () =>
                               Navigator.pushReplacementNamed(context,
                                   SignupScreen.routeName)),
                     ],
                   ),
                 ),
               ),
             ),
           ),
);
  }
}
