import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/pages/match_list_screen.dart';
import 'package:web_dashboard/src/pages/odd_screen.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import '../app.dart';

class MatchScreen extends StatelessWidget {
  final StreamController<int> _segmentController = StreamController<int>();
  final _pageController = PageController();

  MatchScreen({super.key}) {
    _segmentController.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_headerView(), Expanded(child: _matches(context))],
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
                _headerItem("Comming", index == 0, 0),
                SizedBox(width: 10),
                _headerItem("Finished", index == 1, 1),
                SizedBox(width: 2),
              ]),
          ),
        );
      }
    );
  }

  Widget _headerItem(String title, bool selected, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _segmentController.add(index);
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300 ), curve: Curves.linear);
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
    return StreamBuilder<List<FootballMatch>>(
      stream: appState.api!.footballMatchApi.subscribe(),
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
      itemCount: 2,
      onPageChanged: (value) {
        _segmentController.add(value);
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _matchComming(matches, context);
        }
        return _matchFinished(matches, context);
      },
    );
  }

  Widget _matchComming(List<FootballMatch> matches, BuildContext context) {
    final comming = matches.where((element) => element.finished == false);
    return MatchListScreen(
      list: comming.toList(),
      onSelected: (match) => _selectedMatch(match, context),
    );
  }

  Widget _matchFinished(List<FootballMatch> matches, BuildContext context) {
    final comming = matches.where((element) => element.finished == true);
    return MatchListScreen(
      list: comming.toList(),
      onSelected: (match) => _selectedMatch(match, context),
    );
  }

  _selectedMatch(FootballMatch match, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => OddScreen(match: match)));
  }
}
