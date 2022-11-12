import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/assets.dart';
import 'package:web_dashboard/src/model/config.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';

class DownloadAppScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Config?>(
      stream: Provider.of<AppState>(context).api?.configApi.get().asStream(),
      builder: ((context, snapshot) {
        final config = snapshot.data;
        return Center(child: Row(
          children: [
            Expanded(child: _ios(config?.iosDownloadLink ?? "")),
            SizedBox(width: 20),
            Expanded(child: _android(config?.iosDownloadLink ?? "")),
          ],
        ));
      })
    );
  }

  Widget _ios(String link) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText("Download iOS"),
        SizedBox(height: 10),
        QrImage(
          data: link,
          version: QrVersions.auto,
          size: 200,
          gapless: true,
        )
      ],
    );
  }

  Widget _android(String link) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText("Download Android"),
        SizedBox(height: 10),
        QrImage(
          data: link,
          version: QrVersions.auto,
          size: 200,
          gapless: true,
        )
      ],
    );
  }
}