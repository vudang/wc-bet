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
import 'package:web_dashboard/src/widgets/app_text.dart';

import '../assets.dart';
import '../model/bet.dart';
import '../model/match.dart';
import '../model/odd.dart';
import '../model/bet_result.dart';
import '../utils/constants.dart';

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
      final userBet = _getUserBetData(
        user: user, 
        bets: allBets ?? [], 
        matchs: allMatchFinished ?? [], 
        odds: allOddsLocked ?? []
      );
      return userBet;
    }).toList();
    
    ranking?.sort((a, b) => b.availableScore.compareTo(a.availableScore));
    _rankingStream.add(ranking ?? []);
  }

  /// Lấy kết quả bet của tất cả các trận đã đá của user
  UserBet _getUserBetData(
      {required User user,
      required List<Bet> bets,
      required List<FootballMatch> matchs,
      required List<Odd> odds}) {
    
    /// Trong tất cả các trận đã đá, lấy danh sách các trận đã đặt cược của người chơi
    final List<Bet> userBets = matchs.map((m) {
      final bet = bets.firstWhere(
          (b) => b.matchId == m.matchId && b.userId == user.userId,
          orElse: () => Bet());
      return bet;
    }).toList();

    /// Kiểm tra kết qủa bet
    final List<BetResult> userBetsResult = odds.map((odd) {
      final bet = userBets.firstWhere((b) => b.matchId == odd.matchId, orElse: () => Bet());
      final match = matchs.firstWhere((m) => m.matchId == odd.matchId, orElse: () => FootballMatch());
      if (bet.matchId != null) {
        final BetResulttype type = bet.betResult(odd, match);
        final result = BetResult(bet, type);
        return result;
      } else {
        /// Không BET mặc định là thua
        final looseBet = Bet(amount: odd.amount, matchId: odd.matchId, userId: user.userId);
        final result = BetResult(looseBet, BetResulttype.lose);
        return result;
      }
    }).toList();

    return UserBet(user, userBetsResult);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
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
      }
    );
  }

  Widget _contentView(List<UserBet> listRanking) {
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _avatar(ranking),
          SizedBox(width: 5),
          Icon(Icons.arrow_right)
        ]
      ),
      onTap: () {
        _showUserDetail(ranking!.user);
      },
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("${ranking?.user.displayName}", weight: FontWeight.w700),
          AppText("Points: ${ranking?.availableScore}", weight: FontWeight.w500, color: SystemColor.RED, size: 15)
        ],
      ),
    );
  }

  Widget _avatar(UserBet? user) {
    final url = user?.user.photoUrl ?? "";
    return CircleAvatar(
      backgroundColor: SystemColor.GREY_LIGHT.withOpacity(0.6),
      radius: 20,
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
        color: SystemColor.GREY_LIGHT.withOpacity(0.2)
      ),
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
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.height - 400,
            ),
          ]),
        ));
  }

  _showUserDetail(User user) {
    Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => UserBetScreen(user: user)));
  }
}
