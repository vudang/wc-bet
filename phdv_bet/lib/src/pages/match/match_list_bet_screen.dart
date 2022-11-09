import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/bet.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/odd.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/utils/day_helpers.dart';
import 'package:web_dashboard/src/widgets/app_button.dart';
import 'package:web_dashboard/src/widgets/app_confirm_popup.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';

import '../../widgets/congratulations.dart';


class MatchListAndBetScreen extends StatelessWidget {
  final List<FootballMatch> list;
  final List<Odd> odds;
  final List<Bet> userBets;
  final bool enableHeader;
  final String? title;
  final Function(FootballMatch)? onSelected;
  
  MatchListAndBetScreen({
    super.key,
    this.enableHeader = false,
    this.title,
    this.onSelected,
    required this.list,
    this.odds = const [],
    this.userBets = const [],
  });

  late BuildContext _context;
  late BetApi? _betApi;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _betApi = Provider.of<AppState>(context).api?.betApi;
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
    final odd = odds.firstWhere((element) => element.matchId == match.matchId, orElse: (() => Odd()));
    return ListTile(
      onTap: () {
        if (onSelected != null) {
          onSelected!(match);
        }
      },
      contentPadding: EdgeInsets.zero,
      title: Card(
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
                  AppText("(${match.matchId}) - Group ${match.group} - ${odd.amount} pts", color: SystemColor.RED)
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _homeTeam(match),
                  SizedBox(width: 10),
                  Visibility(
                    visible: match.finished == false,
                    child: AppText("VS", weight: FontWeight.w500, size: 20)
                  ),
                  Visibility(
                      visible: match.finished == true,
                      child: AppText("${match.homeScore} : ${match.awayScore}", weight: FontWeight.w500, size: 20)),
                  SizedBox(width: 10),
                  _awayTeam(match)
                ],
              ),
              SizedBox(height: 16),
              AppText(DateHelper.parseDateTime(input: match.localDate ?? "").toCurrentTimeZone()),
              SizedBox(height: 16),
              _oddInfo(match),
              SizedBox(height: 5),
              _placeBet(match),
            ],
          ),
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
          AppText(match.awayTeamEn ?? "",
              size: 18, color: SystemColor.BLACK, weight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _oddInfo(FootballMatch match) {
    final odd = odds.firstWhere((element) => element.matchId == match.matchId && element.matchId != null, orElse: () => Odd());
    if (odd.matchId == null) {
      return AppText("Missing odds", fontStyle: FontStyle.italic, color: SystemColor.GREY_LIGHT);
    }
    return AppText("${odd.desciption ?? ""}", fontStyle: FontStyle.italic, color: SystemColor.GREY_LIGHT);
  }

  Widget _placeBet(FootballMatch match) {
    final odd = odds.firstWhere((element) => element.matchId == match.matchId && element.matchId != null, orElse: () => Odd());
    if (odd.matchId == null) {
      return Container();
    }

    final mybet = userBets.firstWhere((element) => element.matchId == match.matchId, orElse: (() => Bet()));
    final hadBet = mybet.matchId != null;
    final state = hadBet || match.finished == true ? AppButtonState.disable : AppButtonState.normal;
    final isChooseHome = hadBet && mybet.teamChoosed.isHome;
    final isChooseAway = hadBet && mybet.teamChoosed.isAway;
    final textColor = state == AppButtonState.disable ? SystemColor.BLACK : SystemColor.WHITE;

    return Row(
      children: [
        Expanded(
          child: AppSystemRegularButton(
            state: state,
            customTextColor: textColor,
            text: "👍 ${match.homeTeamEn}",
            customTextSize: 14,
            customDisableColor: isChooseHome ? SystemColor.RED.withOpacity(0.2) : SystemColor.GREY_LIGHT.withOpacity(0.2),
            onPressed: (() => _selectedOdds(TeamType.home(), odd))
          )
        ),
        SizedBox(width: 20),
        Expanded(
          child: AppSystemRegularButton(
            state: state,
            customTextColor: textColor,
            text: "👍 ${match.awayTeamEn}", 
            customTextSize: 14,
            customDisableColor: isChooseAway ? SystemColor.RED.withOpacity(0.2) : SystemColor.GREY_LIGHT.withOpacity(0.2),
            onPressed: (() => _selectedOdds(TeamType.away(), odd))
          )
        ),
      ],
    );
  }

  _selectedOdds(TeamType teamType, Odd odd) {
    final chooseTeam = (teamType.isHome ? odd.teamHome : odd.teamAway)?.toLowerCase();
    final dialog = AppConfirmPopup(
          title: "Are you sure with your decision?",
          message: "When you press `BET $chooseTeam` button, you won't have second chance :D",
          positiveButton: "BET $chooseTeam",
          negativeButton: "Cancel",
          onNegativePressed: () {
            Navigator.of(_context).pop();
          },
          onPositivePressed: () {
            Navigator.of(_context).pop();
            _onPlaceBet(teamType, odd);
          },
        );
        
    showCupertinoModalPopup(
        context: _context,
        barrierColor: SystemColor.BLACK.withOpacity(0.8),
        builder: (_) {
          return dialog;
    });
  }
        

  _onPlaceBet(TeamType teamType, Odd odd) async {
    Indicator.show(_context);
    await _betApi?.placeBet(Bet(
        amount: odd.amount,
        choosedTeam: teamType.type,
        userId: FirebaseAuth.instance.currentUser?.uid,
        matchId: odd.matchId));
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