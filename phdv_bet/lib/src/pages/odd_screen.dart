import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/config.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/odd.dart';
import 'package:web_dashboard/src/widgets/app_confirm_popup.dart';
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
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _odds(context),
                SizedBox(height: 30),
                _referenceBet()
              ],
            ),
        )
      ),
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
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _homeTeam(match),
                SizedBox(width: 10),
                AppText("VS", weight: FontWeight.w500, size: 20, color: SystemColor.WHITE),
                SizedBox(width: 10),
                _awayTeam(match)
              ],
            ),
            SizedBox(height: 20),
            AppText(match.localDate ?? "", color: SystemColor.WHITE)
          ],
        ),
      ),
    );
  }

  Widget _homeTeam(FootballMatch match) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          TeamFag(url: match.homeFlag ?? ""),
          SizedBox(width: 20),
          AppText(match.homeTeamEn ?? "", size: 18, color: SystemColor.WHITE, weight: FontWeight.w500),
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
          AppText(match.awayTeamEn ?? "", size: 18, color: SystemColor.WHITE, weight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _odds(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final api = appState.api!.oddApi;
    return StreamBuilder<Odd?>(
      stream: api.get(matchId: match.matchId ?? 0).asStream(),
      builder: (context, snapshot) {
        final odds = snapshot.data;
        if (odds == null) {
          return const Center(
            child: AppText("Odd for this match is comming soon !!!"),
          );
        }

        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppText("Odds", weight: FontWeight.bold),
              SizedBox(height: 20),
              Row(
                children: [
                  _oddsItemView(odds, true, context),
                  SizedBox(width: 20),
                  _oddsItemView(odds, false, context)
                ],
              ),
              SizedBox(height: 20),
              AppText("${odds.desciption ?? ""}",
                  fontStyle: FontStyle.italic, color: SystemColor.GREY_LIGHT),
            ]),
          ),
        );
      },
    );
  }

  Widget _oddsItemView(Odd odds, bool isHome, BuildContext context) {
    final text = isHome ? odds.homePrefix : odds.awayPrefix;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectedOdds(odds, isHome, context),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: SystemColor.BLACK.withAlpha(20),
          ),
          child: Center(
              child: AppText("${text ?? ""} ${odds.label ?? ""}",
                  size: 20, weight: FontWeight.bold)),
        )
      ),
    );
  }

  Widget _referenceBet() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("References", weight: FontWeight.bold),
          _referenceChooseHome(),
          _referenceChooseAway()
        ]
      ),
    );
  }

  Widget _referenceChooseHome() {
    return Card(
      child: ListTile(
        leading: TeamFag(url: match.homeFlag ?? ""),
        title: AppText("Who are choosing ${match.homeTeamEn} ?"),
        trailing: Icon(Icons.arrow_right),
        onTap: () => _selectedHomeRef(),
      ),
    );
  }

   Widget _referenceChooseAway() {
    return Card(
      child: ListTile(
        leading: TeamFag(url: match.awayFlag ?? ""),
        title: AppText("Who are choosing ${match.awayTeamEn} ?"),
        trailing: Icon(Icons.arrow_right),
        onTap: () => _selectedAwayRef(),
      ),
    );
  }
  
  _selectedOdds(Odd odds, bool isHome, BuildContext context) {
    final chooseTeam = (isHome ? odds.teamHome : odds.teamAway)?.toLowerCase();
    showCupertinoModalPopup(
      context: context, 
      barrierColor: SystemColor.BLACK.withOpacity(0.8),
      builder: (_) {
        return AppConfirmPopup(
          title: "Are you sure with your decision?",
          message: "When you press `BET $chooseTeam` button, you won't have second chance :D",
          positiveButton: "BET $chooseTeam",
          negativeButton: "Cancel",
          onNegativePressed: () {
            Navigator.of(context).pop();
          },
          onPositivePressed: () {
            // TODO: BET
            Navigator.of(context).pop();
          },
        );
      }
    );
  }
  
  _selectedHomeRef() {}

  _selectedAwayRef() {}
}