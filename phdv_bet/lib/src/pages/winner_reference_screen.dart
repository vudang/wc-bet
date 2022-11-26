import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/bet.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/model/user.dart';
import 'package:web_dashboard/src/model/winner.dart';
import 'package:web_dashboard/src/widgets/app_network_image.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';

import '../assets.dart';
import '../utils/constants.dart';

class WinnerReferenceScreen extends StatelessWidget {
  final Team team;
  final List<Winner> winners;
  WinnerApi? _winnerApi;
  UserApi? _userApi;

  WinnerReferenceScreen({super.key, required this.team, required this.winners});

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<AppState>(context).api;
    _winnerApi = api?.winnerApi;
    _userApi = api?.userApi;
    final title = team.nameEn;

    return Scaffold(
      appBar: AppBar(
        title: AppText("Who are choosing $title?",
            color: SystemColor.WHITE, weight: FontWeight.w700),
      ),
      body: StreamBuilder<List<User>>(
          stream: _userApi!.list().asStream(),
          builder: (ctx, snapshot) {
            final users = snapshot.data;
            
            return Padding(
              padding: EdgeInsets.all(16),
              child: _listUsersInBet(context, winners, users),
            );
          }),
    );
  }

  Widget _listUsersInBet(BuildContext context, List<Winner>? winners, List<User>? users) {
    final finalUsers = users?.where((u) => winners?.firstWhere((w) => w.userId == u.userId && w.teamId == team.id, orElse: () => Winner()).userId != null).toList() ?? [];
    if (finalUsers.isEmpty) {
      return _emptyView();
    }
    return ListView.separated(
      itemCount: finalUsers.length,
      itemBuilder: (ctx, index) {
        final user = finalUsers[index];
        return _userItemCell(user);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  Widget _userItemCell(User? user) {
    final url = user?.photoUrl ?? "";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: SystemColor.GREY_LIGHT.withOpacity(0.6),
              radius: 25,
              child: AppNetworkImage(url: url)
          ),
          SizedBox(width: 10),
          AppText(user?.displayName ?? "", size: 18, color: SystemColor.BLACK, weight: FontWeight.w700)
        ],
      ),
    );
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
              width: 150,
              height: 150,
            ),
            AppText("Nobody choose this team :D")
          ]),
        ));
  }
}
