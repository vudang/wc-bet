import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_dashboard/src/assets.dart';
import 'package:web_dashboard/src/color.dart';

class Congratulations extends StatelessWidget {
  final VoidCallback completed;
  final int duration;
  const Congratulations(
      {Key? key, this.duration = 3500, required this.completed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: duration), () => completed());
    return Material(
      color: SystemColor.WHITE,
      child: Align(
          alignment: Alignment.center,
          child: Lottie.asset(
            Assets.animations.congratulation,
            repeat: true,
            reverse: false,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )),
    );
  }
}
