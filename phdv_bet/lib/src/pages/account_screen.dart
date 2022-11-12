import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/pages/standing_sceen.dart';
import 'package:web_dashboard/src/pages/user_bet_screen.dart';
import '../color.dart';
import '../utils/screen_helper.dart';
import '../widgets/app_text.dart';

enum AccountMenu {
  profile, standing, rule, help 
}

class AccountScreen extends StatelessWidget {
  final _listMenus = [AccountMenu.standing, AccountMenu.rule, AccountMenu.help];
  late BuildContext _context;
  UserApi? _userApi;
  ConfigApi? _configApi;

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<AppState>(context).api;
    _context = context;
    _userApi = api?.userApi;
    _configApi = api?.configApi;
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
        title: AppText("PH 88",
            size: 20, weight: FontWeight.w700, color: SystemColor.WHITE));
  }

  Widget _mainView() {
    return Column(
      children: _listMenus.map((menu) {
        return _menuItem(menu);
      }).toList(),
    );
  }
  
  Widget _menuItem(AccountMenu menu) {
    return ListTile(
      title: _menuTypeItem(menu),
      leading: _menuIconItem(menu),
      trailing: Icon(Icons.arrow_right),
      onTap: () => _pressedMenu(menu),
    );
  }

  Widget _menuIconItem(AccountMenu menu) {
    switch (menu) {
      case AccountMenu.profile:
        return Icon(Icons.person);
      case AccountMenu.standing:
        return Icon(Icons.table_chart);
      case AccountMenu.rule:
        return Icon(Icons.rule);
      case AccountMenu.help:
        return Icon(Icons.help);
    }
  }

  Widget _menuTypeItem(AccountMenu menu) {
    switch (menu) {
      case AccountMenu.profile:
        return AppText("Account");
      case AccountMenu.standing:
        return AppText("Standing");
      case AccountMenu.rule:
        return AppText("Game rules");
      case AccountMenu.help:
        return AppText("How to play?");
    }
  }
  
  _pressedMenu(AccountMenu menu) {
    switch (menu) {
      case AccountMenu.profile:
        return _gotoAccountDetail();
      case AccountMenu.standing:
        return _gotoStanding();
      case AccountMenu.rule:
        return _gotoRules();
      case AccountMenu.help:
        return _gotoHelp();
    }
  }

  _gotoStanding() {
    Navigator.of(_context).push(MaterialPageRoute(builder: (context) => StandingPage()));
  }
  
  _gotoAccountDetail() async {
    final user = await _userApi?.get(FirebaseAuth.instance.currentUser!.uid);
    Navigator.of(_context)
        .push(MaterialPageRoute(builder: (context) => UserBetScreen(user: user!)));
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
  
}