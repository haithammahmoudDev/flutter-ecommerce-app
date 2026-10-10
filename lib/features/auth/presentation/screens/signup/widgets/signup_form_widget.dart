import 'package:fit_store/features/auth/presentation/bloc/email_auth_bloc/email_auth_bloc.dart';
import 'package:fit_store/features/auth/presentation/screens/signup/widgets/terms_and_condition_oncheckbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../utils/popups/loaders.dart';
import '../verify_email.dart';

class SignUpFormWidget extends StatelessWidget {
  SignUpFormWidget({super.key});
  bool privacyPolicy = false;
  final email = TextEditingController();
  final fullName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<EmailAuthBloc, EmailAuthState>(
          listener: (context, state) {
            if (state is EmailAuthLoading) {
              FullScreenLoader.openLoadingDialog(
                'we are processing your information....',
                AppImages.docerAnimation,
                context,
              );
            }

            if (state is EmailAuthFailure) {
              FullScreenLoader.stopLoading(context);
              Loaders.errorSnackBar(
                title: 'Error',
                message: state.errorMessage,
                context: context,
              );
            }

            if (state is EmailAuthSuccess) {
              FullScreenLoader.stopLoading(context);
              Loaders.successSnackBar(
                title: 'Success',
                message:
                    'Your account has been created successfully! Please verify your email.',
                context: context,
              );
              Navigator.pushNamed(
                context,
                VerifyEmailScreen.routeName,
                arguments: email.text.trim(),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.only(
              top: AppSizes.xl - 15,
              bottom: AppSizes.xl,
            ),
            child: Form(
              key: _signupFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormfieldWidget.withdownEar(
                    label: AppTexts.fullName,
                    controller: fullName,
                    prefixIcon: Icon(LineAwesomeIcons.user),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }

                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters long';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.xl - 20),
                  CustomFormfieldWidget.withdownEar(
                    label: AppTexts.email,
                    controller: email,
                    prefixIcon: Icon(LineAwesomeIcons.envelope),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }

                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.xl - 20),
                  CustomFormfieldWidget.withdownEar(
                    label: AppTexts.phoneNo,
                    controller: phoneNumber,
                    prefixIcon: Icon(LineAwesomeIcons.phone_solid),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

                      if (!phoneRegex.hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.xl - 20),
                  CustomFormfieldWidget(
                    label: AppTexts.password,
                    controller: password,
                    prefixIcon: Icon(Icons.fingerprint),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }

                      return null;
                    },
                    withdownEar: false,
                  ),
                  const SizedBox(height: AppSizes.xl - 10),
                  TermsAndConditionOncheckbox(
                    valueChanged: (bool value) => privacyPolicy = value,
                  ),
                  const SizedBox(height: AppSizes.xl - 10),
                  BlocBuilder<EmailAuthBloc, EmailAuthState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        isLoading: state is EmailAuthLoading,
                        text: AppTexts.signup.tr,
                        onPressed: () {
                          if (_signupFormKey.currentState!.validate()) {
                            if (!privacyPolicy) {
                              Loaders.warningSnackBar(
                                title: 'Accept Privacy Policy',
                                message:
                                    'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
                                context: context,
                              );
                              return;
                            }
                            context.read<EmailAuthBloc>().add(
                              SignUpWithEmailEvent(
                                userName: fullName.text.trim(),
                                email: email.text.trim(),
                                password: password.text.trim(),
                                phoneNumber: phoneNumber.text.trim(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
