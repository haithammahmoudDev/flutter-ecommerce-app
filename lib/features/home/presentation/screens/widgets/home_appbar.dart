import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/appbar/home_appbar.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../cart/screens/cart_menu_icon.dart';
import '../../../../settings/presentation/controllers/user_cubit/user_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TEComAppBar(
      title: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, TRoutes.profileScreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppTexts.homeAppbarTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.apply(color: TColors.grey),
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    buildWhen: (previous, current) =>
                        previous.user?.fullName != current.user?.fullName,
                    builder: (context, state) {
                      final user = state.user;
                      return Text(
                        user?.fullName ?? 'Guest',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.apply(color: TColors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TCartCounterIcon(
          iconColor: TColors.white,
          counterBgColor: TColors.black,
          counterTextColor: TColors.white,
        ),
      ],
    );
  }
}
