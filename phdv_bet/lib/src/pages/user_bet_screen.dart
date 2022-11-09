import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/user.dart';
import 'package:web_dashboard/src/utils/constants.dart';
import 'package:web_dashboard/src/utils/screen_helper.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';

import '../api/api.dart';
import '../app.dart';
import '../assets.dart';
import '../model/bet_result.dart';
import '../model/match.dart';
import '../utils/bet_helper.dart';

class UserBetScreen extends StatelessWidget {
  final User user;
  UserBetScreen({super.key, required this.user});
  
  BetApi? _betApi;
  OddApi? _oddApi;
  FootballMatchApi? _matchApi;
  List<FootballMatch> _allMatches = [];
  late BuildContext _context;
  StreamController<UserBet> _userBetStream = StreamController();

  _fetchData(BuildContext context) async {
    final api = Provider.of<AppState>(context, listen: false).api;
    _betApi = api?.betApi;
    _oddApi = api?.oddApi;
    _matchApi = api?.footballMatchApi;

    /// Tất cả bet của người chơi
    final allBets = await _betApi?.list();

    /// Danh sach trận đã kết thúc
    final allMatchFinished = await _matchApi?.listFinished();
    _allMatches = allMatchFinished ?? [];

    /// Danh sách kèo đã khoá không cho bet nữa
    final allOddsLocked = await _oddApi?.list(isFillterLocked: true);

    final userBet = BetHelper.getUserBetData(
        user: user,
        bets: allBets ?? [],
        matchs: allMatchFinished ?? [],
        odds: allOddsLocked ?? []);

    _userBetStream.add(userBet);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _fetchData(context);
    return Scaffold(
      appBar: ScreenHelper.isLargeScreen(context) ? null : AppBar(
        title: AppText(user.displayName ?? "", color: SystemColor.WHITE, weight: FontWeight.bold),
      ),
      body: _userBet()
    ); 
  }

  Widget _userInfo(UserBet userBet) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
            children: [
              _avatar(user),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(user.displayName ?? "", size: 20, weight: FontWeight.bold),
                  SizedBox(height: 5),
                  AppText("Available: ${userBet.availableScore} pts", color: SystemColor.GREEN, weight: FontWeight.w700),
                  AppText("Losed: ${userBet.loseScore} pts", color: SystemColor.RED, weight: FontWeight.w500),
                ],
              )
            ],
          ),
      )
    );
  }


  Widget _avatar(User user) {
    final url = user.photoUrl ?? "";
    return CircleAvatar(
      backgroundColor: SystemColor.GREY_LIGHT.withOpacity(0.6),
      radius: 40,
      child: url.isNotEmpty ? CachedNetworkImage(
          imageUrl: url,
          cacheKey: url,
          filterQuality: FilterQuality.low,
          memCacheWidth: PHOTO_COMPRESS_SIZE,
          maxWidthDiskCache: PHOTO_COMPRESS_SIZE,
          fit: BoxFit.cover)
      : Icon(Icons.emoji_people)
    );
  }

  Widget _userBet() {
    return StreamBuilder<UserBet>(
      stream: _userBetStream.stream,
      builder: (ctx, snapshot) {
        final userBet = snapshot.data;
        if (userBet == null || userBet.bets.isEmpty) {
          return _emptyView();
        }
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _userInfo(userBet),
              SizedBox(height: 20),
              Expanded(child: _listBetInfo(userBet)),
            ],
          ),
        );
      }
    );
  }

  Widget _listBetInfo(UserBet userBet) {
    return ListView.builder(
      itemCount: userBet.bets.length,
      itemBuilder: ((context, index) {
          final bet = userBet.bets[index];
          return _betItem(bet);
      })
    );
  }

  Widget _betItem(BetResult bet) {
    final match = _allMatches.firstWhere((m) => m.matchId == bet.bet.matchId, orElse: () => FootballMatch());
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(child: _matchInfo(match, bet.bet.teamChoosed.isHome, isMissing: bet.bet.choosedTeam == null)),
            SizedBox(width: 30),
            _result(bet),
            SizedBox(width: 10),
          ],
        ),
      )
    );
  }

  Widget _matchInfo(FootballMatch match, bool chooseHome, {bool isMissing = false}) {
    return Row(
      children: [
        _teamHome(match, chooseHome, isMissing: isMissing),
        SizedBox(width: 5),
        AppText("${match.homeScore ?? "-"} : ${match.awayScore ?? "-"}", weight: FontWeight.bold),
        SizedBox(width: 5),
        _teamAway(match, !chooseHome, isMissing: isMissing)
      ],
    );
  }

  Widget _result(BetResult result) {
    Color color = SystemColor.GREEN;
    if (result.isLoose) {
      color = SystemColor.RED;
    }
    return Container(
      width: 80,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color
      ),
      child: Align(
        alignment: Alignment.center, 
        child: AppText(result.toValueString, color: SystemColor.WHITE, weight: FontWeight.bold, size: 14)
      ),
    );
  }

  Widget _teamHome(FootballMatch match, bool isChoosed, {bool isMissing = false}) {
    final text = isMissing ? "Missed bet" : (isChoosed ? "(Choosed)" : " ");
    return Expanded(child: Column(
      children: [
        TeamFag(url: match.homeFlag ?? ""),
        AppText(match.homeTeamEn ?? ""),
        AppText(text, color: SystemColor.RED, size: 15, fontStyle: FontStyle.italic)
      ],
    ));
  }

  Widget _teamAway(FootballMatch match, bool isChoosed, {bool isMissing = false}) {
    final text = isMissing ? "Missed bet" : (isChoosed ? "(Choosed)" : " ");
    return Expanded(child: Column(
      children: [
        TeamFag(url: match.awayFlag ?? ""),
        AppText(match.awayTeamEn ?? ""),
        AppText(text, color: SystemColor.RED, size: 15, fontStyle: FontStyle.italic)
      ],
    ));
  }

  Widget _emptyView() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Lottie.asset(
            Assets.animations.football,
            repeat: true,
            reverse: true,
            width: MediaQuery.of(_context).size.width - 100,
            height: MediaQuery.of(_context).size.height - 400,
          ),
        ]),
      ));
  }
}