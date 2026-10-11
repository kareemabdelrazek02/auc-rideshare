import 'package:flutter/material.dart';
import '../presentation/ride_profile_menu_screen/ride_profile_menu_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String rideProfileMenuScreen = '/ride_profile_menu_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
    rideProfileMenuScreen: RideProfileMenuScreen.builder,
    appNavigationScreen: AppNavigationScreen.builder,
    initialRoute: AppNavigationScreen.builder,
  };
}
