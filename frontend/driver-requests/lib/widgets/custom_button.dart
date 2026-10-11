import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/text_style_helper.dart';

/// A customizable button widget that can be used throughout the application
/// with flexible styling options.
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.decoration,
    this.width,
    this.margin,
    this.onTap,
    this.alignment,
    this.padding,
    required this.text,
    this.buttonStyle,
    this.buttonTextStyle,
    this.isDisabled = false,
  }) : super(key: key);

  final BoxDecoration? decoration;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final String text;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: _buildButtonWidget(),
        )
        : _buildButtonWidget();
  }

  Widget _buildButtonWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: TextButton(
        style: buttonStyle,
        onPressed: isDisabled ? null : onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Text(
            text,
            style: buttonTextStyle ?? TextStyleHelper.instance.body13Medium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
