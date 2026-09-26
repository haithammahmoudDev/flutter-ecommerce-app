import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/constants/text_strings.dart';
import 'package:fit_store/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/form/custom_form_field.dart';
import '../../../../features/settings/presentation/controllers/user_cubit/user_cubit.dart';

class ReAuthLoginForm extends StatefulWidget {
  const ReAuthLoginForm({super.key});
  static const routeName = 're_auth_login_form';

  @override
  State<ReAuthLoginForm> createState() => _ReAuthLoginFormState();
}

class _ReAuthLoginFormState extends State<ReAuthLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController email;
  late final TextEditingController password;
 @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
 }
 @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Authenticate User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               TextFormField(
                controller: email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                  labelText: AppTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              CustomFormfieldWidget(
                label: AppTexts.password,
                controller: password,
                prefixIcon: Icon(Icons.fingerprint),
                validator: (String? value) {
                  TValidator.validatePassword(value);
                },
                withdownEar: false,),
              const SizedBox(height: TSizes.spaceBtwSections),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:(){
                    if(_formKey.currentState!.validate()) {
                      context.read<UserCubit>()
                          .reAuthenticateEmailAndPasswordUser(
                          email: email.text.trim(),
                          password: password.text.trim(),
                          context: context);
                    }
                  },
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}