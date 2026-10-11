part of 'splash_bloc.dart';

/// Abstract class for all events that can be dispatched from the
/// Splash screen UI.
abstract class SplashEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the Splash screen is first opened
class SplashInitialEvent extends SplashEvent {}

/// Event that is dispatched when the user taps on the login button
class OnLoginTapEvent extends SplashEvent {}

/// Event that is dispatched when the user taps on the sign up button
class OnSignUpTapEvent extends SplashEvent {}
