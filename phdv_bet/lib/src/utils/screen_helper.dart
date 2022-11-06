import 'package:flutter/cupertino.dart';

class ScreenHelper {
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 640.0;
  }

}