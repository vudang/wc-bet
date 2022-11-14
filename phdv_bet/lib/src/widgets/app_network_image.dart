import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/src/assets.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/utils/constants.dart';
import 'package:web_dashboard/src/utils/screen_helper.dart';

class AppNetworkImage extends StatelessWidget {

  final String url;
  final Widget? placeholder;

  const AppNetworkImage({super.key, required this.url, this.placeholder});
  
  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return placeholder ?? Image.asset(Assets.icons.ic_unknown_user, width: 50, height: 50);
    }
    if (ScreenHelper.isLargeScreen(context)) {
      return _web();
    }
    return _mobile();
  }

  Widget _mobile() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40))
      ),
      child: CachedNetworkImage(
          imageUrl: url,
          cacheKey: url,
          filterQuality: FilterQuality.low,
          memCacheWidth: PHOTO_COMPRESS_SIZE,
          maxWidthDiskCache: PHOTO_COMPRESS_SIZE,
          fit: BoxFit.cover),
    );
  }

  Widget _web() {
    return Image.network(url);
  }
}