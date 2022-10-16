import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_dashboard/src/assets.dart';
import 'package:web_dashboard/src/color.dart';

class Indicator {
  static Future? indicator;
  static show(BuildContext context, {bool canDismiss = false, bool useSafeArea = true}) {
    hide(context); // hide first
    indicator = showDialog(
        context: context,
        barrierDismissible: canDismiss,
        useSafeArea: useSafeArea,
        builder: (_) {
          // Prevent android device press system back button
          return WillPopScope(child: const AppIndicator(), onWillPop: () async => false);
        });
  }

  static hide(BuildContext context) {
    if (indicator != null) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      indicator = null;
    }
  }
}

class AppIndicator extends StatelessWidget {
  const AppIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SystemColor.BLACK.withOpacity(0.6),
      child: Align(
          alignment: Alignment.center,
          child: Lottie.asset(
            Assets.animations.indicator,
            repeat: true,
            reverse: true,
            width: 150,
            height: 150,
          )
      ),
    );
  }
}