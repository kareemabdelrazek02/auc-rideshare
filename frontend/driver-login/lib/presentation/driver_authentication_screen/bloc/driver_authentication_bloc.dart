import 'package:flutter/material.dart';
import '../models/driver_authentication_model.dart';
import '../../../core/app_export.dart';

part 'driver_authentication_event.dart';
part 'driver_authentication_state.dart';

class DriverAuthenticationBloc
    extends Bloc<DriverAuthenticationEvent, DriverAuthenticationState> {
  DriverAuthenticationBloc(DriverAuthenticationState initialState)
    : super(initialState) {
    on<DriverAuthenticationInitialEvent>(_onInitialize);
    on<ChangeEmailEvent>(_onChangeEmail);
    on<ChangePasswordEvent>(_onChangePassword);
    on<LoginButtonPressedEvent>(_onLoginButtonPressed);
    on<SignUpButtonPressedEvent>(_onSignUpButtonPressed);
  }

  _onInitialize(
    DriverAuthenticationInitialEvent event,
    Emitter<DriverAuthenticationState> emit,
  ) {
    emit(
      state.copyWith(
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        isLoading: false,
      ),
    );
  }

  _onChangeEmail(
    ChangeEmailEvent event,
    Emitter<DriverAuthenticationState> emit,
  ) {
    emit(
      state.copyWith(
        driverAuthenticationModel: state.driverAuthenticationModel?.copyWith(
          email: event.email,
        ),
      ),
    );
  }

  _onChangePassword(
    ChangePasswordEvent event,
    Emitter<DriverAuthenticationState> emit,
  ) {
    emit(
      state.copyWith(
        driverAuthenticationModel: state.driverAuthenticationModel?.copyWith(
          password: event.password,
        ),
      ),
    );
  }

  _onLoginButtonPressed(
    LoginButtonPressedEvent event,
    Emitter<DriverAuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // Here would be authentication logic to authenticate the driver
    // For now, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 1));

    // After authentication logic, update the state
    emit(state.copyWith(isLoading: false, isLoggedIn: true));
  }

  _onSignUpButtonPressed(
    SignUpButtonPressedEvent event,
    Emitter<DriverAuthenticationState> emit,
  ) {
    // Navigation to sign up screen would be handled in the UI
  }
}
