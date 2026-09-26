// Original file: lib/utils/animations/fade_in_animation/animation_design.dart
// Converted: Get.put(FadeInAnimationController()) -> context.read<FadeInAnimationCubit>()
//            Obx(...) -> BlocBuilder<FadeInAnimationCubit, FadeInAnimationState>(...)
// NOTE: this widget no longer creates its own Cubit - it reads the one already provided
// by its parent screen (SplashScreen / WelcomeScreen), same as before where GetX's
// Get.put() transparently reused the same singleton across every TFadeInAnimation
// instance on the same screen.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fade_in_animation_cubit.dart';
import 'fade_in_animation_model.dart';

class TFadeInAnimation extends StatelessWidget {
  const TFadeInAnimation({
    super.key,
    required this.durationInMs,
    required this.child,
    this.animate,
    this.isTwoWayAnimation = true,
  });

  final int durationInMs;
  final TAnimatePosition? animate;
  final Widget child;
  final bool isTwoWayAnimation; //If two way then use animateTwoWay value otherwise animateSingle

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FadeInAnimationCubit, FadeInAnimationState>(
      builder: (context, state) {
        final animated = isTwoWayAnimation ? state.animateTwoWay : state.animateSingle;
        return AnimatedPositioned(
          duration: Duration(milliseconds: durationInMs),
          top: animated ? animate!.topAfter : animate!.topBefore,
          left: animated ? animate!.leftAfter : animate!.leftBefore,
          bottom: animated ? animate!.bottomAfter : animate!.bottomBefore,
          right: animated ? animate!.rightAfter : animate!.rightBefore,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: durationInMs),
            opacity: animated ? 1 : 0,
            child: child,
          ),
        );
      },
    );
  }
}