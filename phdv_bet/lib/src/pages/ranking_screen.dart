import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/user.dart';
import 'package:web_dashboard/src/pages/user_bet_screen.dart';
import 'package:web_dashboard/src/utils/bet_helper.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';

import '../assets.dart';
import '../model/bet_result.dart';
import '../utils/constants.dart';
import '../utils/screen_helper.dart';

class RankingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  BetApi? _betApi;
  OddApi? _oddApi;
  UserApi? _userApi;
  FootballMatchApi? _matchApi;
  StreamController<List<UserBet>> _rankingStream = StreamController();
  StreamController<User> _userDetailStream = StreamController();

  _fetchData() async {
    final api = Provider.of<AppState>(context, listen: false).api;
    _userApi = api?.userApi;
    _betApi = api?.betApi;
    _oddApi = api?.oddApi;
    _matchApi = api?.footballMatchApi;

    final allUser = await _userApi?.list();

    /// Tất cả bet của người chơi
    final allBets = await _betApi?.list();

    /// Danh sach trận đã kết thúc
    final allMatchFinished = await _matchApi?.listFinished();

    /// Danh sách kèo đã khoá không cho bet nữa
    final allOddsLocked = await _oddApi?.list(isFillterLocked: true);

    final ranking = allUser?.map((user) {
      final userBet = BetHelper.getUserBetData(
          user: user,
          bets: allBets ?? [],
          matchs: allMatchFinished ?? [],
          odds: allOddsLocked ?? []);
      return userBet;
    }).toList();

    ranking?.sort((a, b) => b.availableScore.compareTo(a.availableScore));
    _rankingStream.add(ranking ?? []);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () => _fetchData());
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
        title: AppText("Ranking",
            size: 20, weight: FontWeight.w700, color: SystemColor.WHITE));
  }

  Widget _mainView() {
    return StreamBuilder<List<UserBet>>(
        stream: _rankingStream.stream,
        builder: (ctx, snapshot) {
          final listRanking = snapshot.data ?? [];
          if (listRanking.isEmpty) {
            return _emptyView();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _contentView(listRanking),
          );
        });
  }

  Widget _contentView(List<UserBet> listRanking) {
    if (ScreenHelper.isLargeScreen(context)) {
      return Row(
        children: [
          Expanded(child: _rankingView(listRanking)),
          Expanded(child: _userDetailView()),
        ],
      );
    }

    return _rankingView(listRanking);
  }

  Widget _userDetailView() {
    return StreamBuilder<User?>(
        stream: _userDetailStream.stream,
        builder: ((context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return Container();
          }
          return UserBetScreen(user: user);
        }));
  }

  Widget _rankingView(List<UserBet> listRanking) {
    return ListView.builder(
      itemCount: listRanking.length,
      itemBuilder: (ctx, index) {
        final ranking = listRanking[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: _rankingRow(ranking, index),
          ),
        );
      },
    );
  }

  Widget _rankingRow(UserBet? ranking, int index) {
    return ListTile(
      leading: _ranking(index),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        _avatar(ranking),
        SizedBox(width: 5),
        Icon(Icons.arrow_right)
      ]),
      onTap: () {
        _showUserDetail(ranking!.user);
      },
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("${ranking?.user.displayName}", weight: FontWeight.w700),
          AppText("Points: ${ranking?.availableScore}",
              weight: FontWeight.w500, color: SystemColor.RED, size: 15)
        ],
      ),
    );
  }

  Widget _avatar(UserBet? user) {
    final url = user?.user.photoUrl ?? "";
    return CircleAvatar(
        backgroundColor: SystemColor.GREY_LIGHT.withOpacity(0.6),
        radius: 20,
        child: url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                cacheKey: url,
                filterQuality: FilterQuality.low,
                memCacheWidth: PHOTO_COMPRESS_SIZE,
                maxWidthDiskCache: PHOTO_COMPRESS_SIZE,
                fit: BoxFit.cover)
            : Image.asset(Assets.icons.ic_unknown_user, width: 50, height: 50));
  }

  Widget _ranking(int index) {
    if (index == 0) {
      return Image.asset(Assets.icons.ic_gold, width: 40, height: 40);
    }
    if (index == 1) {
      return Image.asset(Assets.icons.ic_siliver, width: 40, height: 40);
    }
    if (index == 2) {
      return Image.asset(Assets.icons.ic_bronze, width: 40, height: 40);
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: SystemColor.GREY_LIGHT.withOpacity(0.2)),
      child: Align(
        alignment: Alignment.center,
        child: AppText(
          "${index + 1}",
          size: 20,
          weight: FontWeight.bold,
          align: TextAlign.center,
        ),
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
              Assets.animations.ranking,
              repeat: true,
              reverse: true,
              width: 200,
              height: 200,
            ),
          ]),
        ));
  }

  _showUserDetail(User user) {
    if (ScreenHelper.isLargeScreen(context)) {
      _userDetailStream.add(user);
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UserBetScreen(user: user)));
    }
  }
}
