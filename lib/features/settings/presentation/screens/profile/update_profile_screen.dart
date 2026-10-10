import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'profile_form.dart';
import 'widgets/image_with_icon.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          AppTexts.editProfile,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: const Column(
          children: [
            ImageWithIcon(),
            SizedBox(height: 50),
            ProfileFormScreen(),
          ],
        ),
      ),
    );
  }
}
