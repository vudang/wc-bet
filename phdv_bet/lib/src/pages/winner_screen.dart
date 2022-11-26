import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/model/winner.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';

import '../app.dart';
import '../color.dart';
import '../utils/screen_helper.dart';
import '../widgets/app_confirm_popup.dart';
import '../widgets/app_text.dart';

class WinnerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  StreamController<List<Team>> _teamStream = StreamController();
  StreamController<List<Winner>> _winnerStream = StreamController();
  TeamApi? _teamApi;
  WinnerApi? _winnerApi;

  _fetchData() async {
    final api = Provider.of<AppState>(context, listen: false).api;
    _teamApi = api?.teamApi;
    _winnerApi = api?.winnerApi;
    
  }
  
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _mainView(),
    );
  }

  AppBar? _appBar(BuildContext context) {
    if (ScreenHelper.isLargeScreen(context)) {
      return null;
    }
    return AppBar(
        title: AppText("Winner",
            size: 20, weight: FontWeight.w700, color: SystemColor.WHITE));
  }

  Widget _mainView() {
    return StreamBuilder<List<Team>>(
        stream: _teamApi?.list().asStream(),
        builder: (ctx, snapshot) {
          final teams = snapshot.data ?? [];
          if (teams.isEmpty) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _contentView(teams),
          );
        });
  }


  Widget _contentView(List<Team> listRanking) {
    if (ScreenHelper.isLargeScreen(context)) {
      return Row(
        children: [
          Expanded(child: _winnerView(listRanking)),
          Expanded(child: _userDetailView()),
        ],
      );
    }

    return _winnerView(listRanking);
  }

  Widget _winnerView(List<Team> listRanking) {
    return ListView.builder(
          itemCount: listRanking.length,
          itemBuilder: (ctx, index) {
            final ranking = listRanking[index];
            return Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _teamRow(ranking, index),
              ),
            );
          },
        );
  }

  Widget _teamRow(Team? team, int index) {
    return ListTile(
      leading: TeamFag(url: team?.flag ?? ""),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(width: 5),
        Icon(Icons.arrow_right)
      ]),
      onTap: () {
        _confirmSelectTeam(team);
      },
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("${team?.nameEn}", weight: FontWeight.w700),
        ],
      ),
    );
  }
  
  Widget _userDetailView() {
    return Container();
  }
  
  _confirmSelectTeam(Team? team) {
    final dialog = AppConfirmPopup(
      title: "Are you sure ${team?.nameEn?.toUpperCase()} will be the Champion?",
      message: "You can change utils 18:00, 03/12/2022",
      positiveButton: "BET ${team?.nameEn}",
      negativeButton: "Cancel",
      onNegativePressed: () {
        Navigator.of(context).pop();
      },
      onPositivePressed: () {
        Navigator.of(context).pop();
        _onPlaceBet(team);
      },
    );

    showCupertinoModalPopup(
        context: context,
        barrierColor: SystemColor.BLACK.withOpacity(0.8),
        builder: (_) {
          return dialog;
        });
  }
  
  _onPlaceBet(Team? team) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final winner = Winner(
      teamId: team?.id, 
      userId: userId,
      date: DateTime.now()
    );

    Indicator.show(context);
    await _winnerApi?.placeWinner(winner);
    Indicator.hide(context);
  }
}