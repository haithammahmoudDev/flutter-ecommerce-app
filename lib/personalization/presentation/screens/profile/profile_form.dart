 import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class ProfileFormScreen extends StatelessWidget {
  const ProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Form(
       child: Column(
        children: [
          TextFormField(
             decoration: const InputDecoration(
              label: Text(AppTexts.tFullName),
              prefixIcon: Icon(LineAwesomeIcons.user),
            ),
          ),
          const SizedBox(height: TSizes.xl - 20),

          TextFormField(
            // enabled: controller.email.text.isEmpty,
            // controller: controller.email,
            decoration: const InputDecoration(
              label: Text(AppTexts.email),
              prefixIcon: Icon(LineAwesomeIcons.envelope),
            ),
          ),
          const SizedBox(height: TSizes.xl - 20),

          TextFormField(
            // enabled: controller.phoneNo.text.isEmpty,
            // controller: controller.phoneNo,
            decoration: const InputDecoration(
              label: Text(AppTexts.tPhoneNo),
              prefixIcon: Icon(LineAwesomeIcons.phone_solid),
            ),
          ),
          const SizedBox(height: TSizes.xl),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){},
              child: const Text(AppTexts.editProfile),
            ),
          ),

          const SizedBox(height: TSizes.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: AppTexts.joined,
                  style: const TextStyle(fontSize: 12),
                  children: [
                    // TextSpan(
                    //   text: state.user.createdAt == null
                    //       ? ''
                    //       : THelperFunctions.getFormattedDate(
                    //     state.user.createdAt!,
                    //   ),
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 12,
                    //   ),
                    //),
                  ],
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                ),
                onPressed: () => _showDeleteDialog(context),
                child: const Text(AppTexts.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account permanently?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
             },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}