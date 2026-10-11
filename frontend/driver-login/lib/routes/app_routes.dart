import 'package:flutter/material.dart';
import '../presentation/driver_authentication_screen/driver_authentication_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String driverAuthenticationScreen =
      '/driver_authentication_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
    driverAuthenticationScreen: DriverAuthenticationScreen.builder,
    appNavigationScreen: AppNavigationScreen.builder,
    initialRoute: AppNavigationScreen.builder,
  };
}
