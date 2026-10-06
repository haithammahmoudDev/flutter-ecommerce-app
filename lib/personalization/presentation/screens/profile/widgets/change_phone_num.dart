import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../features/settings/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class ChangePhoneNum extends StatefulWidget {
  const ChangePhoneNum({super.key});

  @override
  State<ChangePhoneNum> createState() => _ChangePhoneNumState();
}

class _ChangePhoneNumState extends State<ChangePhoneNum> {
  late final TextEditingController phoneNum;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<UserCubit>().state.user;
    phoneNum = TextEditingController(text: currentUser?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    phoneNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Change Phone Number',
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
                'Use real Phone Number for easy verification.'
                    ' This Phone Number will appear on several pages.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Form(
                key: formKey,
                child: TextFormField(
                  controller: phoneNum,
                  validator: (value) =>
                      TValidator.validateEmptyText('Phone Number', value),
                  expands: false,
                  decoration: InputDecoration(
                    labelText: AppTexts.tPhoneNumber,
                    prefixIcon: const Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child:  ElevatedButton(
                      onPressed: () async{
                        if (formKey.currentState!.validate()) {
                         await context.read<UserCubit>().updatePhoneNumber(
                              phoneNum: phoneNum.text.trim(),
                            );
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Save'),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
