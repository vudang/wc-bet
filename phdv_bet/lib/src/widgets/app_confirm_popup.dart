import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/widgets/app_button.dart';

import 'app_text.dart';

class AppConfirmPopup extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButton;
  final String negativeButton;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  
  const AppConfirmPopup({
    Key? key,
    required this.title, 
    required this.message,
    required this.positiveButton, 
    required this.negativeButton,
    this.onNegativePressed,
    this.onPositivePressed
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: SystemColor.WHITE,
      ),
      width: min(MediaQuery.of(context).size.width, 640),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(title,
                color: SystemColor.BLACK,
                size: 24,
                weight: FontWeight.w700),
            SizedBox(height: 20),
            AppText(message,
              color: SystemColor.BLACK,
              size: 18,
              weight: FontWeight.w500),
            SizedBox(height: 60),
            _buttons()
            
          ],
      ))
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(child: _negativeButton()),
        SizedBox(width: 20),
        Expanded(child: _positiveButton()),
      ],
    );
  }

  Widget _positiveButton() {
    return Visibility(
      visible: positiveButton.isNotEmpty,
      child: AppSystemRegularButton(
        text: positiveButton,
        onPressed: onPositivePressed,
        customColor: SystemColor.RED,
      ),
    );
  }

  Widget _negativeButton() {
    return Visibility(
      visible: negativeButton.isNotEmpty,
      child: AppSystemRegularButton(
        customColor: SystemColor.GREY_LIGHT.withOpacity(0.5),
        customTextColor: SystemColor.GREY,
        text: negativeButton,
        onPressed: onNegativePressed,
      ),
    );
  }
}
