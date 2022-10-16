import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/utils/constants.dart';
import 'package:web_dashboard/src/utils/day_helpers.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import '../app.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return FutureBuilder<List<FootballMatch>>(
      future: appState.api!.footballMatch.list(),
      builder: (context, futureSnapshot) {
        if (!futureSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<List<FootballMatch>>(
          initialData: futureSnapshot.data,
          stream: appState.api!.footballMatch.subscribe(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return _matchList(snapshot.data ?? []);
          },
        );
      },
    );
  }

  Widget _matchList(List<FootballMatch> list) {
    return ListView.builder(
        itemBuilder: (ctx, index) {
          final match = list[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _matchItem(match),
          );
        }
    );
  }

  Widget _matchItem(FootballMatch match) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.sports_baseball_rounded, color: SystemColor.RED),
                SizedBox(width: 10),
                AppText("Group ${match.group}", color: SystemColor.RED)
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _homeTeam(match),
                SizedBox(width: 10),
                AppText("VS", weight: FontWeight.w500, size: 20),
                SizedBox(width: 10),
                _awayTeam(match)
              ],
            ),
            SizedBox(height: 16),
            AppText(DateHelper.parseDateTime(input: match.localDate ?? "").toCurrentTimeZone())
          ],
        ),
      ),
    );
  }

  Widget _homeTeam(FootballMatch match) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(match.homeTeamEn ?? "", size: 18, color: SystemColor.BLACK, weight: FontWeight.w500),
          SizedBox(width: 10),
          _flag(match.homeFlag ?? "")
        ],
      ),
    );
  }

  Widget _awayTeam(FootballMatch match) {
    return Expanded(
      child: Row(
        children: [
          _flag(match.awayFlag ?? ""),
          SizedBox(width: 10),
          AppText(match.awayTeamEn ?? "", size: 18, color: SystemColor.BLACK, weight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _flag(String url) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: SystemColor.GREY_LIGHT, width: 2)
      ),
      child: CachedNetworkImage(
          imageUrl: url,
          cacheKey: url,
          filterQuality: FilterQuality.low,
          memCacheWidth: PHOTO_COMPRESS_SIZE,
          maxWidthDiskCache: PHOTO_COMPRESS_SIZE,
          fit: BoxFit.cover,
          useOldImageOnUrlChange: false
      ),
    );
  }
}