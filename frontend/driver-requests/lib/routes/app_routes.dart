import 'package:flutter/material.dart';
import '../presentation/ride_request_list_screen/ride_request_list_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String rideRequestListScreen = '/ride_request_list_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
    rideRequestListScreen: RideRequestListScreen.builder,
    appNavigationScreen: AppNavigationScreen.builder,
    initialRoute: AppNavigationScreen.builder,
  };
}
