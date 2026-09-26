// Original file: lib/utils/animations/fade_in_animation/fade_in_animation_controller.dart
// Converted: GetxController -> Cubit. Logic untouched.
// This is used locally by SplashScreen and WelcomeScreen, each creating its own instance
// (same as the original - each screen did its own Get.put()) - no cross-route sharing
// needed, so this stays created locally wherever it's used, not in app.dart.
import 'package:equatable/equatable.dart';
import 'package:fit_store/data/services/notifications/lib/core/navigation/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/presentation/screens/welcome/welcome_screen.dart';


part 'fade_in_animation_state.dart';

class FadeInAnimationCubit extends Cubit<FadeInAnimationState> {
  FadeInAnimationCubit() : super(const FadeInAnimationState());

  Future<void> startSplashAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(animateTwoWay: true));

    await Future.delayed(const Duration(milliseconds: 3000));
    emit(state.copyWith(animateTwoWay: false));

  }

  // Can be used to animate In after calling the next screen.
  Future<void> animationIn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(animateSingle: true));
  }

  // Can be used to animate Out before calling the next screen.
  Future<void> animationOut() async {
    emit(state.copyWith(animateSingle: false));
    await Future.delayed(const Duration(milliseconds: 100));
  }
}