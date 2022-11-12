import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/pages/account_detail_screen.dart';
import 'package:web_dashboard/src/pages/account_screen.dart';
import 'package:web_dashboard/src/pages/ranking_screen.dart';
import 'package:web_dashboard/src/pages/standing_sceen.dart';
import 'package:web_dashboard/src/utils/screen_helper.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import '../app.dart';
import '../widgets/third_party/adaptive_scaffold.dart';
import 'download_app_screen.dart';
import 'help_screen.dart';
import 'match/match_screen.dart';

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
  ConfigApi? _configApi;

  @override
  void initState() {
    _requestPushNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<AppState>(context).api;
    _configApi = api?.configApi;
    
    final isWeb = ScreenHelper.isLargeScreen(context);
    final menus = isWeb  ? const [
        AdaptiveScaffoldDestination(title: 'Match', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Ranking', icon: Icons.list),
        AdaptiveScaffoldDestination(title: 'Account', icon: Icons.person),
        AdaptiveScaffoldDestination(title: 'Standing', icon: Icons.table_chart),
        AdaptiveScaffoldDestination(title: 'Game Rules', icon: Icons.rule),
        AdaptiveScaffoldDestination(title: 'How to play?', icon: Icons.help),
        AdaptiveScaffoldDestination(title: 'Download Mobile App?', icon: Icons.install_mobile)
      ] :
      const [
        AdaptiveScaffoldDestination(title: 'Match', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Ranking', icon: Icons.list),
        AdaptiveScaffoldDestination(title: 'Account', icon: Icons.person),
        AdaptiveScaffoldDestination(title: 'More', icon: Icons.more_rounded)
      ];

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
      destinations: menus,
      body: isWeb ? _webPageAtIndex(_pageIndex) : _mobilePageAtIndex(_pageIndex),
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

  static Widget _mobilePageAtIndex(int index) {
    if (index == 0) {
      return MatchScreen();
    }

    if (index == 1) {
      return RankingScreen();
    }

    if (index == 2) {
      return AccountDetailScreen();
    }
    
    return AccountScreen();
  }

  Widget _webPageAtIndex(int index) {
    if (index == 0) {
      return MatchScreen();
    }

    if (index == 1) {
      return RankingScreen();
    }

    if (index == 2) {
      return AccountDetailScreen();
    }

    if (index == 3) {
      return StandingPage();
    }

    if (index == 4) {
      _gotoRules();
      return Container();
    }

    if (index == 5) {
      _gotoHelp();
      return Container();
    }

    return DownloadAppScreen();
  }


  _gotoRules() async {
    final config = await _configApi?.get();
    Uri _url = Uri.parse(config?.ruleUrl ?? "");
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  _gotoHelp() async {
    final config = await _configApi?.get();
    Uri _url = Uri.parse(config?.helpUrl ?? "");
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  _requestPushNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }
}
