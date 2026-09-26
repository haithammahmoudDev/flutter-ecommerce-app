import 'package:fit_store/utils/constants/image_strings.dart';
import 'package:fit_store/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../features/settings/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  late final TextEditingController userName;
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<UserCubit>().state.user;
     userName = TextEditingController(text: currentUser?.fullName ?? '');
  }

  @override
  void dispose() {
    userName.dispose();
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TAppBar(
          showBackArrow: true,
          title: Text(
            'Change Name',
            style: Theme.of(context).textTheme.headlineSmall,
          ), showActions: false, showSkipButton: false,
        ),
        body: SingleChildScrollView( // Added scrollview to cleanly prevent bottom overflow on keyboard popups
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use real name for easy verification. This name will appear on several pages.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                Form(
                  key: formKey, // Assigned the form key correctly here
                  child: TextFormField(
                    controller: userName,
                    validator: (value) => TValidator.validateEmptyText('Full name', value),
                    expands: false,
                    decoration: InputDecoration(
                      labelText: AppTexts.tFullName,
                      prefixIcon: const Icon(Iconsax.user),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// -- Save Button
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async{
                           if (formKey.currentState!.validate()) {
                             await context.read<UserCubit>().updateUserName(
                                   fullName: userName.text.trim(),
                                 );
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text('Save'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
