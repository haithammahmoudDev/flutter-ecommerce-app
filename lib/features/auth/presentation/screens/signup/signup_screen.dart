import 'package:fit_store/features/auth/presentation/screens/signup/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/buttons/clickable_richtext_widget.dart';
import '../../../../../common/widgets/form/form_divider_widget.dart';
import '../../../../../common/widgets/form/form_header_widget.dart';
import '../../../../../common/widgets/form/social_footer.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../bloc/email_auth_bloc/email_auth_bloc.dart';
import '../login/login_screen.dart';
import 'widgets/signup_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  static const routeName = 'signup_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmailAuthBloc>(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormHeaderWidget(
                    image: TImages.tWelcomeScreenImage,
                    title: AppTexts.tSignUpTitle,
                    subTitle: AppTexts.tSignUpSubTitle,
                    imageHeight: 0.1,
                  ),
                  SignUpFormWidget(),
                  Align(
                    alignment: Alignment.center,
                    child: ClickableRichTextWidget(
                      text1: AppTexts.tAlreadyHaveAnAccount,
                      text2: AppTexts.login,
                        onPressed: () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
