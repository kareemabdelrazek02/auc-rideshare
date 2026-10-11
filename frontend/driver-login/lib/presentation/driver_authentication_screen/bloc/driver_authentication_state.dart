part of 'driver_authentication_bloc.dart';

class DriverAuthenticationState extends Equatable {
  final DriverAuthenticationModel? driverAuthenticationModel;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isLoading;
  final bool isLoggedIn;

  const DriverAuthenticationState({
    this.driverAuthenticationModel,
    this.emailController,
    this.passwordController,
    this.isLoading = false,
    this.isLoggedIn = false,
  });

  @override
  List<Object?> get props => [
    driverAuthenticationModel,
    emailController,
    passwordController,
    isLoading,
    isLoggedIn,
  ];

  DriverAuthenticationState copyWith({
    DriverAuthenticationModel? driverAuthenticationModel,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    bool? isLoading,
    bool? isLoggedIn,
  }) {
    return DriverAuthenticationState(
      driverAuthenticationModel:
          driverAuthenticationModel ?? this.driverAuthenticationModel,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
