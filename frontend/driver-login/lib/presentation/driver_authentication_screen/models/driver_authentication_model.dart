import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

/// This class is used in the [driver_authentication_screen] screen.

// ignore_for_file: must_be_immutable
class DriverAuthenticationModel extends Equatable {
  DriverAuthenticationModel({this.email, this.password});

  String? email;
  String? password;

  DriverAuthenticationModel copyWith({String? email, String? password}) {
    return DriverAuthenticationModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}
