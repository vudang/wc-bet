import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class HelpScreen extends StatelessWidget {
  final String url;

  const HelpScreen({super.key, required this.url});
 
  @override
  Widget build(BuildContext context) {
    return WebViewX(
      width: MediaQuery.of(context).size.width, 
      height: MediaQuery.of(context).size.height,
      onWebViewCreated: ((controller) {
        controller.loadContent(url, SourceType.url);
      }),
    );
  }
}