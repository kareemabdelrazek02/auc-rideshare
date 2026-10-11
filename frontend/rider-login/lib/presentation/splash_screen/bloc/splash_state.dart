part of 'splash_bloc.dart';

/// Represents the state of Splash in the application.
class SplashState extends Equatable {
  SplashState({this.splashModel});

  SplashModel? splashModel;

  @override
  List<Object?> get props => [splashModel];

  SplashState copyWith({SplashModel? splashModel}) {
    return SplashState(splashModel: splashModel ?? this.splashModel);
  }
}
