import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/bet.dart';
import 'package:web_dashboard/src/model/config.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/odd.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/pages/bet_reference_screen.dart';
import 'package:web_dashboard/src/utils/screen_helper.dart';
import 'package:web_dashboard/src/widgets/app_confirm_popup.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/congratulations.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';
import '../app.dart';

class OddScreen extends StatelessWidget {
  final FootballMatch match;
  BetApi? _betApi;
  OddApi? _oddApi;
  Odd? _odd;
  late BuildContext _context;

  OddScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    _context = context;
    _betApi = Provider.of<AppState>(context).api?.betApi;
    _oddApi = Provider.of<AppState>(context).api?.oddApi;
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
                AppText(match.finished == true ? "${match.homeScore} : ${match.awayScore}" : "VS", weight: FontWeight.w500, size: 20, color: SystemColor.WHITE),
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
    return StreamBuilder<Odd?>(
      stream: _oddApi?.get(matchId: match.matchId ?? 0).asStream(),
      builder: (context, snapshot) {
        final odds = snapshot.data;
        if (odds == null) {
          return const Center(
            child: AppText("Odds for this match is not available at the moment. Please check back later."),
          );
        }

        _odd = odds;

        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppText("Place your bet", weight: FontWeight.bold),
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
              SizedBox(height: 5),
              _myBetInfo()
            ]),
          ),
        );
      },
    );
  }

  Widget _oddsItemView(Odd odds, bool isHome, BuildContext context) {
    final text = isHome ? odds.homePrefix : odds.awayPrefix;
    return StreamBuilder<Bet?>(
      stream: _betApi?.getMyBet(odds.matchId!),
      builder: (ctx, snapshots) {
        final alreadyBet = snapshots.data != null;
        final isExpired = odds.isLock == true;
        final canBet = alreadyBet == false && isExpired == false;
        var color = canBet ? SystemColor.RED : SystemColor.GREY_LIGHT.withAlpha(20);
        final txtcolor = canBet
              ? SystemColor.WHITE
              : SystemColor.BLACK;
        if (alreadyBet) {
          final isBetHome = snapshots.data?.teamChoosed.isHome == true;
          if (isBetHome && isHome) {
            color = SystemColor.RED.withOpacity(0.2);
          }
          if (!isBetHome && !isHome) {
            color = SystemColor.RED.withOpacity(0.2);
          }
        }

        final flag = isHome ? match.homeFlag : match.awayFlag;
        final teamName = isHome ? match.homeTeamEn : match.awayTeamEn;

        return Expanded(
          child: GestureDetector(
            onTap: () => canBet == false ? null : _selectedOdds(odds, isHome, context),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TeamFag(url: flag ?? ""),
                      // SizedBox(width: 10),
                      AppText("Choose $teamName",
                          size: 17, weight: FontWeight.w500, color: txtcolor)
                    ],
                  )
                  
              ),
            )
          ),
        );
      }
    );
  }


  Widget _myBetInfo() {
    return StreamBuilder<Bet?>(
        stream: _betApi?.getMyBet(match.matchId!),
        builder: (ctx, snapshots) {
          final alreadyBet = snapshots.data != null;
          final isHome = snapshots.data?.teamChoosed.isHome == true;
          final teamName = isHome ? match.homeTeamEn : match.awayTeamEn;
          
          return Visibility(
            visible: alreadyBet,
            child: AppText("You bet '$teamName'", color: SystemColor.RED.withOpacity(0.6)),
          );
        });
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
    final dialog = AppConfirmPopup(
          title: "Are you sure with your decision?",
          message: "When you press `BET $chooseTeam` button, you won't have second chance :D",
          positiveButton: "BET $chooseTeam",
          negativeButton: "Cancel",
          onNegativePressed: () {
            Navigator.of(context).pop();
          },
          onPositivePressed: () {
            Navigator.of(context).pop();
            if (isHome) {
              _placeBet(TeamType.home());
            } else {
              _placeBet(TeamType.away());
            }
          },
        );
        
    showCupertinoModalPopup(
      context: context,
      barrierColor: SystemColor.BLACK.withOpacity(0.8),
      builder: (_) {
        return dialog;
    });
  }
  
  _selectedHomeRef() {
    showCupertinoModalPopup(
        context: _context,
        barrierColor: SystemColor.BLACK.withOpacity(0.8),
        builder: (_) {
          return BetReferenceScreen(match: match, chooseHome: true);
        });
  }

  _selectedAwayRef() {
    showCupertinoModalPopup(
        context: _context,
        barrierColor: SystemColor.BLACK.withOpacity(0.8),
        builder: (_) {
          return BetReferenceScreen(match: match, chooseHome: false);
        });
  }

  _placeBet(TeamType teamType) async {
    if (_odd == null) {
      return;
    }

    Indicator.show(_context);
    await _betApi?.placeBet(Bet(
      amount: _odd?.amount,
      choosedTeam: teamType.type,
      userId: FirebaseAuth.instance.currentUser?.uid,
      matchId: _odd?.matchId
    ));
    Indicator.hide(_context);
    _showBetSuccessful();
  }

  _showBetSuccessful() {
      showCupertinoModalPopup(
        context: _context,
        builder: (ctx) {
          return Congratulations(completed: () {
            Navigator.of(ctx).pop();
          });
      });
  }
}