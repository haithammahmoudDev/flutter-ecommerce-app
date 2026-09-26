import 'package:fit_store/personalization/presentation/screens/profile/widgets/change_phone_num.dart';
import 'package:fit_store/personalization/presentation/screens/profile/widgets/change_user_name.dart';
import 'package:fit_store/personalization/presentation/screens/profile/widgets/profile_menu.dart';
import 'package:fit_store/personalization/presentation/screens/profile/widgets/profile_menu_shimmer.dart';
import 'package:fit_store/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../features/settings/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/popups/loaders.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.userDataStatus == UserDataStatus.error) {
          Navigator.pop(context);
          TLoaders.errorSnackBar(
            title: 'Operation Failed',
            context: context,
            message: state.errorMessage ?? 'Something went wrong.',
          );
        }
        if (state.userDataStatus == UserDataStatus.loading) {
           TFullScreenLoader.popUpCircular(context);
         }

        if (state.userDataStatus == UserDataStatus.loaded) {
          Navigator.pop(context);
          TLoaders.successSnackBar(
            context: context,
             message: 'The operation was completed successfully!', title: 'successfully!',
          );        }
      },
      child: Scaffold(
        appBar: const TAppBar(
          showBackArrow: true,
          title: Text('Profile'),
          showActions: false,
          showSkipButton: false,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          BlocBuilder<UserCubit, UserState>(
                            buildWhen: (previous, current) =>
                            previous.user?.profilePicture != current.user?.profilePicture,
                            builder: (context, state) {
                              final user = state.user;
                              return CircularImage(
                                image: user!.profilePicture,
                                isNetworkImage: true,
                                width: 110,
                                height: 110,
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () async {
                               await context.read<UserCubit>().pickImage(
                                ImageSource.gallery,
                              );
                            },
                            child: const Text('Change Profile Picture'),
                          ),
                        ],
                      ),
                    ),

                    /// -- Details Divider
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// -- Heading Profile Info
                    const SectionHeading(
                      title: 'Profile Information',
                      showActionButton: false,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Column(
                      children: [
                        BlocBuilder<UserCubit, UserState>(
                          buildWhen: (previous, current) =>
                          previous.user?.fullName != current.user?.fullName,
                          builder: (context, state) {
                            final user = state.user;
                            return ProfileMenu(
                              title: 'Name',
                              value: user?.fullName ?? '-',
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<UserCubit>(),
                                        child: ChangeName(),
                                      );
                                    },
                                  ),
                                );
                                if (result == true) {
                                  context.read<UserCubit>().getUserData();
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        ProfileMenu(title: 'E-mail', value: context.read<UserCubit>().state.user?.email ?? '-'),
                        BlocBuilder<UserCubit, UserState>(
                          buildWhen: (previous, current) =>
                          previous.user?.phoneNumber != current.user?.phoneNumber,
                          builder: (context, state) {
                            final user = state.user;
                            return ProfileMenu(
                          title: 'Phone Number',
                          value: (user?.phoneNumber != null && user!.phoneNumber.isNotEmpty)
                              ? user.phoneNumber
                              : 'Enter Phone Number',
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: context.read<UserCubit>(),
                                    child: ChangePhoneNum(),
                                  );
                                },
                              ),
                            );
                            if (result == true) {
                              context.read<UserCubit>().getUserData();
                            }
                          },
                        );
  },
),
                        const Divider(),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _showDeleteAccountDialog(context);
                            },
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            PrimaryButton(
              isFullWidth: false,
              text: 'Yes',
              onPressed: () async {
                context.read<UserCubit>().deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }
}

