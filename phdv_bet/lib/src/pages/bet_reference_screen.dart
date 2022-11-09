import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/bet.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/user.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';

import '../assets.dart';
import '../utils/constants.dart';

class BetReferenceScreen extends StatelessWidget {
  final FootballMatch match;
  final bool chooseHome;

  BetApi? _betApi;
  UserApi? _userApi;

  BetReferenceScreen(
      {super.key, required this.match, required this.chooseHome});

  @override
  Widget build(BuildContext context) {
    _betApi = Provider.of<AppState>(context).api?.betApi;
    _userApi = Provider.of<AppState>(context).api?.userApi;
    final title = chooseHome ? match.homeTeamEn : match.awayTeamEn;

    return Scaffold(
      appBar: AppBar(
        title: AppText("Who are choosing $title?",
            color: SystemColor.WHITE, weight: FontWeight.w700),
      ),
      body: StreamBuilder<List<Bet>>(
          stream: _betApi?.getListBetForMatch(match.matchId!),
          builder: (ctx, snapshot) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: _listUsersInBet(context, snapshot.data),
            );
          }),
    );
  }

  Widget _listUsersInBet(BuildContext context, List<Bet>? bets) {
    if (bets == null || bets.isEmpty) {
      return _emptyView();
    }

    return StreamBuilder<List<User>>(
        stream: _userApi?.list().asStream(),
        builder: (ctx, snapshot) {
          final allUsers = snapshot.data;

          /// Tìm user đang có trong danh sách bet của trận đấu
          final userInBets = allUsers?.where((u) {
            final bet = bets.firstWhere((b) => b.userId == u.userId,
                orElse: () => Bet());
            if (chooseHome) {
              return bet.teamChoosed.isHome;
            }
            return bet.teamChoosed.isAway;
          }).toList();

          if (userInBets == null || userInBets.isEmpty) {
            return _emptyView();
          }

          return ListView.separated(
            itemCount: userInBets.length,
            itemBuilder: (ctx, index) {
              final user = userInBets[index];
              return _userItemCell(user);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
        });
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
              child: url.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: url,
                      cacheKey: url,
                      filterQuality: FilterQuality.low,
                      memCacheWidth: PHOTO_COMPRESS_SIZE,
                      maxWidthDiskCache: PHOTO_COMPRESS_SIZE,
                      fit: BoxFit.cover)
                  : Image.asset(Assets.icons.ic_unknown_user,
                      width: 50, height: 50)),
          SizedBox(width: 10),
          AppText(user?.displayName ?? "",
              size: 18, color: SystemColor.BLACK, weight: FontWeight.w700)
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
            AppText("Nobody bet for this team :D")
          ]),
        ));
  }
}
