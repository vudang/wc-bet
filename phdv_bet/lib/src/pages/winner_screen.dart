import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/model/user.dart' as Model;
import 'package:web_dashboard/src/model/winner.dart';
import 'package:web_dashboard/src/pages/winner_reference_screen.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import 'package:web_dashboard/src/widgets/team_flag.dart';

import '../app.dart';
import '../color.dart';
import '../utils/screen_helper.dart';
import '../widgets/app_confirm_popup.dart';
import '../widgets/app_network_image.dart';
import '../widgets/app_text.dart';

class WinnerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  TeamApi? _teamApi;
  WinnerApi? _winnerApi;
  UserApi? _userApi;
  ConfigApi? _configApi;
  StreamController<Team?> _streamChoosedTeamController = StreamController();

  _fetchData() async {
    final api = Provider.of<AppState>(context, listen: false).api;
    _teamApi = api?.teamApi;
    _winnerApi = api?.winnerApi;
    _userApi = api?.userApi;
    _configApi = api?.configApi;
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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final teamStream = _teamApi?.list().asStream();
    final userStream = _userApi?.get(userId).asStream();
    final winnerStream = _winnerApi?.subcribe();
    return StreamBuilder3<List<Team>, List<Winner>, Model.User?>(
      streams: StreamTuple3(teamStream!, winnerStream!, userStream!),
      builder: ((context, snapshots) {
          final teams = snapshots.snapshot1.data?.where((e) => e.active == true) ?? [];
          final user = snapshots.snapshot3.data;
          final winners = snapshots.snapshot2.data ?? [];
          if (teams.isEmpty) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _contentView(teams.toList(), winners, user),
          );
      })
    );
  }


  Widget _contentView(List<Team> teams, List<Winner> winners, Model.User? user) {
    if (ScreenHelper.isLargeScreen(context)) {
      return Row(
        children: [
          Expanded(child: _winnerView(teams, winners, user)),
          Expanded(child: _detailWinnerView(winners)),
        ],
      );
    }

    return _winnerView(teams, winners, user);
  }

  Widget _winnerView(List<Team> teams, List<Winner> winners, Model.User? user) {
    teams.forEach((team) {
      final count = winners.where((e) => e.teamId == team.id).length;
      team.winnerCount = count;
    });
    teams.sort(((b, a) => (a.winnerCount ?? 0).compareTo((b.winnerCount ?? 0))));

    return ListView.builder(
          itemCount: teams.length,
          itemBuilder: (ctx, index) {
            final team = teams[index];
            return Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: _teamRow(team, winners, user),
              ),
            );
          },
        );
  }

  Widget _teamRow(Team? team, List<Winner> winners, Model.User? user) {
    final isChoosed = winners.firstWhere((e) => e.userId == FirebaseAuth.instance.currentUser?.uid && e.teamId == team?.id, orElse: () => Winner()).userId != null;
    return ListTile(
      leading: TeamFag(url: team?.flag ?? ""),
      trailing: GestureDetector(
        onTap: () {
          _showWinnerRefView(team!, winners);
        },
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(width: 5),
          Visibility(visible: isChoosed, child: _avatar(user)),
          SizedBox(width: 5),
          _counting(team?.winnerCount ?? 0),
          Icon(Icons.arrow_right)
        ]),
      ),
      onTap: () {
        if (!isChoosed) {
          _confirmSelectTeam(team);
        }
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
  
  Widget _detailWinnerView(List<Winner> winners) {
    return StreamBuilder<Team?>(
      stream: _streamChoosedTeamController.stream,
      builder: ((context, snapshot) {
        final team = snapshot.data;
        if (team == null) {
          return Container();
        }

        return WinnerReferenceScreen(team: team, winners: winners);
      })
    );
  }


  Widget _avatar(Model.User? user) {
    final url = user?.photoUrl ?? "";
    return CircleAvatar(
        backgroundColor: SystemColor.RED.withOpacity(0.6),
        radius: 20,
        child: AppNetworkImage(url: url));
  }

  Widget _counting(int count) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: SystemColor.GREY_LIGHT.withOpacity(0.2)),
      child: Align(
        alignment: Alignment.center,
        child: AppText(
          "$count",
          size: 16,
          weight: FontWeight.bold,
          align: TextAlign.center,
        ),
      ),
    );
  }
  
  _confirmSelectTeam(Team? team) async {
    final config = await _configApi?.get();
    final endTime = config?.winnerTimeEnd ?? "18:00 03/12/2022";
    if (config?.winnerLock == true) {
      final dialog = AppConfirmPopup(
        title: "Time Over!",
        message: "Winner game was closed at $endTime",
        positiveButton: "Back",
        negativeButton: "Close",
        onNegativePressed: () {
          Navigator.of(context).pop();
        },
        onPositivePressed: () {
          Navigator.of(context).pop();
        },
      );

      showCupertinoModalPopup(
          context: context,
          barrierColor: SystemColor.BLACK.withOpacity(0.8),
          builder: (_) {
            return dialog;
          });

      return;
    } 

    final dialog = AppConfirmPopup(
      title: "Are you sure ${team?.nameEn?.toUpperCase()} will be the Champion?",
      message: "You can change utils $endTime",
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
  
  _showWinnerRefView(Team team, List<Winner> winners) {
    if (ScreenHelper.isLargeScreen(context)) {
      _streamChoosedTeamController.add(team);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WinnerReferenceScreen(team: team, winners: winners)));
    }
  }
}