import 'package:flutter/material.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/utils/day_helpers.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';


class MatchListScreen extends StatelessWidget {
  final List<FootballMatch> list;
  final bool enableHeader;
  final String? title;
  const MatchListScreen({
    super.key,
    this.enableHeader = false,
    this.title,
    required this.list
  });

  @override
  Widget build(BuildContext context) {
    if (enableHeader) {
      return Scaffold(
        appBar: AppBar(
          title: AppText("${title ?? ""}'s matches", color: SystemColor.WHITE, weight: FontWeight.w700, size: 20,),
        ),
        body: _matchList(list),
      );
    }
    return _matchList(list);
  }

  Widget _matchList(List<FootballMatch> list) {
    return ListView.builder(
        itemCount: list.length,
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
          TeamFag(url: match.homeFlag ?? "")
        ],
      ),
    );
  }

  Widget _awayTeam(FootballMatch match) {
    return Expanded(
      child: Row(
        children: [
          TeamFag(url: match.awayFlag ?? ""),
          SizedBox(width: 10),
          AppText(match.awayTeamEn ?? "", size: 18, color: SystemColor.BLACK, weight: FontWeight.w500),
        ],
      ),
    );
  }
}