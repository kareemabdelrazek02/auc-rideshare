import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/text_style_helper.dart';

/// A customizable button widget that provides consistent styling with
/// configurable appearance options.
///
/// This button can be used throughout the application with different styles,
/// colors, and text while maintaining a consistent look and feel.
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.width,
    this.height,
    this.decoration,
    this.alignment,
    this.margin,
    this.onPressed,
    required this.text,
    this.buttonStyle,
    this.buttonTextStyle,
    this.isDisabled = false,
    this.borderRadius,
    this.backgroundColor,
  }) : super(key: key);

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Decoration for the button container
  final BoxDecoration? decoration;

  /// Alignment of the button
  final Alignment? alignment;

  /// Margin around the button
  final EdgeInsets? margin;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Text to display on the button
  final String text;

  /// Style for the button
  final ButtonStyle? buttonStyle;

  /// Text style for the button text
  final TextStyle? buttonTextStyle;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Border radius for the button
  final double? borderRadius;

  /// Background color for the button
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: _buildButtonWidget,
        )
        : _buildButtonWidget;
  }

  Widget get _buildButtonWidget => Container(
    width: width ?? double.maxFinite,
    height: height ?? 42.h,
    margin: margin,
    decoration: decoration,
    child: ElevatedButton(
      style:
          buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? appTheme.colorFF95A1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 21.h),
            ),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
      onPressed: isDisabled ? null : onPressed ?? () {},
      child: Text(
        text,
        style: buttonTextStyle ?? TextStyleHelper.instance.title16SemiBold,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
