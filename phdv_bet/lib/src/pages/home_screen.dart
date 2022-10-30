import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/pages/ranking_screen.dart';
import 'package:web_dashboard/src/pages/standing_sceen.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import '../widgets/third_party/adaptive_scaffold.dart';
import 'match_screen.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;

  const HomePage({
    required this.onSignOut,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: const AppText('PH 88', color: SystemColor.WHITE, weight: FontWeight.w700, size: 22,),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () => _handleSignOut(),
            child: const Text('Sign Out'),
          ),
        )
      ],
      currentIndex: _pageIndex,
      destinations: const [
        AdaptiveScaffoldDestination(title: 'Match', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Ranking', icon: Icons.list),
        AdaptiveScaffoldDestination(title: 'Info', icon: Icons.info)
      ],
      body: _pageAtIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          _pageIndex = newIndex;
        });
      },
    );
  }

  Future<void> _handleSignOut() async {
    var shouldSignOut = await (showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    ));

    if (shouldSignOut == null || !shouldSignOut) {
      return;
    }

    widget.onSignOut();
  }

  static Widget _pageAtIndex(int index) {
    if (index == 0) {
      return MatchScreen();
    }

    if (index == 1) {
      return RankingScreen();
    }

    if (index == 2) {
      return const StandingPage();
    }

    return const Center(child: Text('Settings'));
  }
}
