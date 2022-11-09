import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/utils/constants.dart';

class TeamFag extends StatelessWidget {
  final String url;
  const TeamFag({super.key, required this.url});
  
  @override
  Widget build(BuildContext context) {
    return _flag(url);
  }
  
  Widget _flag(String url) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: SystemColor.GREY_LIGHT, width: 2)),
      child: url.isEmpty ? Icon(CupertinoIcons.flag_circle_fill, color: SystemColor.RED) : CachedNetworkImage(
          imageUrl: url,
          cacheKey: url,
          filterQuality: FilterQuality.low,
          memCacheWidth: PHOTO_COMPRESS_SIZE,
          maxWidthDiskCache: PHOTO_COMPRESS_SIZE,
          fit: BoxFit.cover,
          useOldImageOnUrlChange: false),
    );
  }
}