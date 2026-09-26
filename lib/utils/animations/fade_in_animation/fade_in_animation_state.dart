part of 'fade_in_animation_cubit.dart';

class FadeInAnimationState extends Equatable {
  const FadeInAnimationState({
    this.animateTwoWay = false,
    this.animateSingle = false,
  });

  final bool animateTwoWay;
  final bool animateSingle;

  FadeInAnimationState copyWith({
    bool? animateTwoWay,
    bool? animateSingle,
  }) {
    return FadeInAnimationState(
      animateTwoWay: animateTwoWay ?? this.animateTwoWay,
      animateSingle: animateSingle ?? this.animateSingle,
    );
  }

  @override
  List<Object?> get props => [animateTwoWay, animateSingle];
}