import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A customizable text field component that supports various input types and styling options.
///
/// This component provides a consistent text input experience with customizable
/// appearance including background color, border radius, text styling, and more.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.alignment,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final Alignment? alignment;
  final double? width;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? textStyle;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: _buildTextFieldWidget(),
        )
        : _buildTextFieldWidget();
  }

  Widget _buildTextFieldWidget() {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        style: textStyle,
        obscureText: obscureText,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines,
        decoration: _buildDecoration(),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      isDense: true,
      contentPadding: contentPadding ?? EdgeInsets.all(16.h),
      fillColor: fillColor,
      filled: filled,
      border: borderDecoration ?? InputBorder.none,
      enabledBorder: borderDecoration ?? InputBorder.none,
      focusedBorder: borderDecoration ?? InputBorder.none,
      disabledBorder: borderDecoration ?? InputBorder.none,
    );
  }
}
