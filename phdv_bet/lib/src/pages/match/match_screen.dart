import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/pages/odd_screen.dart';
import 'package:web_dashboard/src/utils/screen_helper.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';

import '../../app.dart';
import '../../assets.dart';
import 'match_list_bet_screen.dart';
import 'match_list_screen.dart';

enum MatchFilterType {
  today, comming, finished
}

class MatchScreen extends StatelessWidget {
  final StreamController<int> _segmentController = StreamController<int>();
  final StreamController<FootballMatch?> _selectedMatchController = StreamController<FootballMatch?>();
  final _pageController = PageController();

  MatchScreen({super.key}) {
    _segmentController.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _mainView(context)
    );
  }

  AppBar? _appBar(BuildContext context) {
    if (ScreenHelper.isLargeScreen(context)) {
      return null;
    }
    return AppBar(title: AppText("Match", size: 20, weight: FontWeight.w700, color: SystemColor.WHITE));
  }

  Widget _mainView(BuildContext context) {
    if (ScreenHelper.isLargeScreen(context)) {
      return Row(
        children: [
          Expanded(child: _matchListView(context)),
          Expanded(child: _matchDetailView(context))
        ],
      );
    }

    return _matchListView(context);
  }

  Widget _matchListView(BuildContext context) {
    return Column(
        children: [_headerView(), Expanded(child: _matches(context))],
      );
  }

  Widget _matchDetailView(BuildContext context) {
    return StreamBuilder<FootballMatch?>(
      stream: _selectedMatchController.stream,
      builder: (ctx, snapshot) {
        final match = snapshot.data;
        return Visibility(
          visible: ScreenHelper.isLargeScreen(context) && match != null,
          child: match == null ? Container() : OddScreen(match: match),
        );
      }
    );
  }

  Widget _headerView() {
    return StreamBuilder<int>(
      stream: _segmentController.stream,
      builder: (ctx, snapshot) {
        final index = snapshot.data;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: SystemColor.RED.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              children: [
                SizedBox(width: 2),
                _headerItem("Today", index == 0, MatchFilterType.today),
                SizedBox(width: 10),
                _headerItem("Up comming", index == 1, MatchFilterType.comming),
                SizedBox(width: 10),
                _headerItem("Played", index == 2, MatchFilterType.finished),
                SizedBox(width: 2),
              ]),
          ),
        );
      }
    );
  }

  Widget _headerItem(String title, bool selected, MatchFilterType type) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _segmentController.add(type.index);
          _pageController.animateToPage(type.index, duration: Duration(milliseconds: 300 ), curve: Curves.linear);
        },
        child:  Container(
          height: 36,
          decoration: BoxDecoration(
            color: SystemColor.RED.withOpacity(selected ? 1 : 0),
            borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: AppText(title, color: SystemColor.WHITE, weight: FontWeight.w500)
            ),
        ),
      )
    );
  }

  Widget _matches(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final matchStream = appState.api!.footballMatchApi.subscribe();
    final oddStream = appState.api!.oddApi.list();
    final betStream = appState.api!.betApi.getListMyBet();

    return StreamBuilder<List<FootballMatch>>(
      stream: matchStream,
      builder: (ctx, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final matches = snapshot.data ?? [];
        return _machesWidget(matches, context);
      },
    );
  }

  Widget _machesWidget(List<FootballMatch> matches, BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 3,
      onPageChanged: (value) {
        _segmentController.add(value);
        _showFirstMatchDefault(value, context);
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _matchToday(matches, context);
        }
        if (index == 1) {
          return _matchComming(matches, context);
        }
        return _matchFinished(matches, context);
      },
    );
  }

  Widget _matchToday(List<FootballMatch> matches, BuildContext context) {
    final comming = matches.where((match) {
      return (match.date?.millisecondsSinceEpoch ?? 0) < DateTime.now().millisecondsSinceEpoch + 86400000;
    });
    if (comming.isEmpty) {
      return _emptyView();
    }
    return MatchListAndBetScreen(
      list: comming.toList(),
      onSelected: (match) => _selectedMatch(match, context),
    );
  }


  Widget _matchComming(List<FootballMatch> matches, BuildContext context) {
    final comming = matches.where((element) => element.finished == false);
    return MatchListAndBetScreen(
      list: comming.toList(),
      onSelected: (match) => _selectedMatch(match, context),
    );
  }

  Widget _matchFinished(List<FootballMatch> matches, BuildContext context) {
    final comming = matches.where((element) => element.finished == true);
    return MatchListAndBetScreen(
      list: comming.toList(),
      onSelected: (match) => _selectedMatch(match, context),
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
            AppText("No match today :(")
          ]),
        )
    );
  }

  _selectedMatch(FootballMatch match, BuildContext context) {
    if (ScreenHelper.isLargeScreen(context)) {
      _selectedMatchController.add(match);
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OddScreen(match: match)));
  }
  
  _showFirstMatchDefault(int value, BuildContext context) {
    if (!ScreenHelper.isLargeScreen(context)) {
      return;
    }
  }
}
