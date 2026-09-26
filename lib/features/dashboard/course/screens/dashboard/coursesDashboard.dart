// Original file: lib/features/dashboard/course/screens/dashboard/courses_dashboard.dart
// Converted: UserController.instance -> context.read<UserCubit>()
// NOTE: original never wrapped this in Obx (one-shot, non-reactive read at build time),
// so no BlocBuilder added here - kept 1:1 with the original behaviour.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/drawer/drawer.dart';
 import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import 'widgets/appbar.dart';
import 'widgets/banners.dart';
import 'widgets/categories.dart';
import 'widgets/search.dart';
import 'widgets/top_courses.dart';

class CoursesDashboard extends StatelessWidget {
  const CoursesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    //Variables
    final txtTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: DashboardAppBar(),

        /// Create a new Header
        drawer: TDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Heading
               // Text(userCubit.state.user.fullName.isEmpty ? TTexts.tDashboardTitle : "Hey, ${userCubit.state.user.fullName}", style: txtTheme.bodyMedium),
                Text(AppTexts.dashboardHeading, style: txtTheme.displayMedium),
                const SizedBox(height: TSizes.lg),

                //Search Box
                DashboardSearchBox(txtTheme: txtTheme),
                const SizedBox(height: TSizes.lg),

                //Categories
                DashboardCategories(txtTheme: txtTheme),
                const SizedBox(height: TSizes.lg),

                //Banners
                DashboardBanners(txtTheme: txtTheme),
                const SizedBox(height: TSizes.lg),

                //Top Course
                Text(AppTexts.dashboardTopCourses, style: txtTheme.headlineMedium?.apply(fontSizeFactor: 1.2)),
                DashboardTopCourses(txtTheme: txtTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}