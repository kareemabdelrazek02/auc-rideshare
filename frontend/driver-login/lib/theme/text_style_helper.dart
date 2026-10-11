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

  TextStyle get headline26MonomaniacOne => TextStyle(
    fontSize: 26.fSize,
    fontFamily: 'Monomaniac One',
    color: appTheme.blackCustom,
  );

  TextStyle get headline24SemiBoldOutfit => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Outfit',
    color: appTheme.colorFF053F,
  );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: Color(0xFF000000),
  );

  TextStyle get title16SemiBoldPoppins => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: appTheme.whiteCustom,
  );

  TextStyle get title16SemiBold => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.whiteCustom,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body14 =>
      TextStyle(fontSize: 14.fSize, color: appTheme.colorFF908D);
}
