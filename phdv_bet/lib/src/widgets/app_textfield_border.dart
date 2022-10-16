import 'package:flutter/material.dart';
import 'package:web_dashboard/src/color.dart';

class AppTextFieldBorder extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final String placeholder;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? textInputType;

  const AppTextFieldBorder({
    Key? key,
    required this.controller,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.placeholder = "",
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.readOnly = false,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.textInputType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      readOnly: readOnly,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      obscureText: obscureText,
      style: TextStyle(
        color: SystemColor.BLACK,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: SystemColor.BLACK,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
        hintText: placeholder,
        counterText: "",
        border: InputBorder.none,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
          color: SystemColor.GREY,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF2F3540),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF2F3540),
            width: 2,
          ),
        ),
      ),
    );
  }
}
