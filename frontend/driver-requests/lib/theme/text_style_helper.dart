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

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline24SemiBold => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.blackCustom,
  );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: Color(0xFF000000),
  );

  TextStyle get title16 => TextStyle(fontSize: 16.fSize, color: Colors.black54);

  TextStyle get title16SemiBold => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.blackCustom,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body13Medium => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.colorFF95A1,
  );

  // Label Styles
  // Small text styles for labels, captions, and hints

  TextStyle get label10Medium => TextStyle(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.blackCustom,
  );

  TextStyle get label10 =>
      TextStyle(fontSize: 10.fSize, color: appTheme.blackCustom);

  TextStyle get label9Medium => TextStyle(
    fontSize: 9.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.blackCustom,
  );

  TextStyle get label9 =>
      TextStyle(fontSize: 9.fSize, color: appTheme.blackCustom);

  // Other Styles
  // Miscellaneous text styles without specified font size

  TextStyle get textStyle4 => TextStyle(color: appTheme.whiteCustom);
}
