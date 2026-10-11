import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/text_style_helper.dart';

/// A custom button widget that can be used for various button needs like login, submit, etc.
///
/// This button offers customizable styling including background color, text style,
/// rounded corners, and flexible sizing.
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
    this.margin,
    this.onTap,
    this.padding,
    this.buttonTextStyle,
    this.buttonColor,
    this.borderRadius,
    required this.text,
    this.isDisabled = false,
  }) : super(key: key);

  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final TextStyle? buttonTextStyle;
  final Color? buttonColor;
  final double? borderRadius;
  final String text;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: buildButtonWidget,
        )
        : buildButtonWidget;
  }

  Widget get buildButtonWidget {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: appTheme.transparentCustom,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: Container(
            width: width ?? double.maxFinite,
            height: height ?? 43.h,
            padding: padding,
            decoration:
                decoration ??
                BoxDecoration(
                  color: buttonColor ?? Color(0xFF95A1D5),
                  borderRadius: BorderRadius.circular(borderRadius ?? 21.h),
                ),
            child: Center(
              child: Text(
                text,
                style:
                    buttonTextStyle ?? TextStyleHelper.instance.title16SemiBold,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
