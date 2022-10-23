import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/config.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/odd.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';
import '../app.dart';

class OddScreen extends StatelessWidget {
  final FootballMatch match;
  const OddScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: AppText("${match.homeTeamEn} vs ${match.awayTeamEn}", color: SystemColor.WHITE, weight: FontWeight.w700, size: 16,),
                  background: Stack(
                    children: [
                      Positioned.fill(child: _header(context)),
                      Positioned(
                        bottom: 70, left: 10, right: 10,
                        child: _matchInfo(context),
                      )
                    ],
                  )
            ),)
          ];
        },
        body: Center(
          child: Text("Sample Text"),
        ),
      ),
    );
  }
  
  Widget _odds(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final api = appState.api!.oddApi;
    return StreamBuilder<Odd?>(
      stream: api.get(matchId: match.matchId ?? 0).asStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container();
      },
    );
  }

  Widget _header(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final api = appState.api!.configApi;
    return StreamBuilder<Config?>(
      stream: api.get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        final imageUrl = snapshot.data?.stadiumUrl ?? "https://firebasestorage.googleapis.com/v0/b/worldbet-aaa29.appspot.com/o/banner%2Fbanner_01.png?alt=media&token=b3ddd7e2-0355-4c21-b6e9-fe0f68afd085";
        return CachedNetworkImage(
          imageUrl: imageUrl,
          cacheKey: imageUrl,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _matchInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            AppText(match.localDate ?? "")
          ],
        ),
      ),
    );
  }

  Widget _homeTeam(FootballMatch match) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TeamFag(url: match.homeFlag ?? ""),
          SizedBox(width: 20),
          AppText(match.homeTeamEn ?? "",
              size: 18, color: SystemColor.BLACK, weight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _awayTeam(FootballMatch match) {
    return Expanded(
      child: Column(
        children: [
          TeamFag(url: match.awayFlag ?? ""),
          SizedBox(width: 10),
          AppText(match.awayTeamEn ?? "",
              size: 18, color: SystemColor.BLACK, weight: FontWeight.w500),
        ],
      ),
    );
  }
}