import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: Color(0xFF000000),
  );

  TextStyle get title18Medium => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.colorFF4141,
  );

  TextStyle get title16Medium =>
      TextStyle(fontSize: 16.fSize, fontWeight: FontWeight.w500);

  TextStyle get title16 =>
      TextStyle(fontSize: 16.fSize, color: appTheme.colorFF4141);

  // Body Styles
  // Standard text styles for body content

  TextStyle get body12Medium =>
      TextStyle(fontSize: 12.fSize, fontWeight: FontWeight.w500);
}
