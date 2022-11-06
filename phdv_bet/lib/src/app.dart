import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/color.dart';
import 'api/api.dart';
import 'api/firebase.dart';
import 'auth/auth.dart';
import 'auth/firebase.dart';
import 'pages/home_screen.dart';
import 'pages/auth/auth_screen.dart';

class AppState {
  final Auth auth;
  Api? api;

  AppState(this.auth);
}

/// Creates a [Api] for the given user. This allows users of this
/// widget to specify whether [MockDashboardApi] or [ApiBuilder] should be
/// created when the user logs in.
typedef ApiBuilder = Api Function();

/// An app that displays a personalized dashboard.
class DashboardApp extends StatefulWidget {
  static Api _apiBuilder() => FirebaseApi(FirebaseFirestore.instance);

  final Auth auth;
  final ApiBuilder apiBuilder;

  /// Runs the app using Firebase
  DashboardApp.firebase({super.key}) : auth = FirebaseAuthService(), apiBuilder = _apiBuilder ;

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState(widget.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: MaterialColor(0xFFC8102E, <int, Color>{
              50: Color(0xFFF3E5F5),
              100: Color(0xFFE1BEE7),
              200: Color(0xFFCE93D8),
              300: Color(0xFFBA68C8),
              400: Color(0xFFAB47BC),
              500: Color(0xFFC8102E),
              600: Color(0xFF8E24AA),
              700: Color(0xFF7B1FA2),
              800: Color(0xFF6A1B9A),
              900: Color(0xFF4A148C),
            },)
        ),
        home: SignInSwitcher(
          appState: _appState,
          apiBuilder: widget.apiBuilder,
        ),
      ),
    );
  }
}

class SignInSwitcher extends StatefulWidget {
  final AppState? appState;
  final ApiBuilder? apiBuilder;

  const SignInSwitcher({
    this.appState,
    this.apiBuilder,
    super.key,
  });

  @override
  State<SignInSwitcher> createState() => _SignInSwitcherState();
}

class _SignInSwitcherState extends State<SignInSwitcher> {
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
      child: _isSignedIn
          ? HomePage(
              onSignOut: _handleSignOut,
            )
          : AuthScreen(
              auth: widget.appState!.auth,
              userApi: widget.apiBuilder!().userApi,
              onSuccess: _handleSignIn,
            ),
    );
  }

  void _handleSignIn(User user) {
    widget.appState!.api = widget.apiBuilder!();

    setState(() {
      _isSignedIn = true;
    });
  }

  Future _handleSignOut() async {
    await widget.appState!.auth.signOut();
    setState(() {
      _isSignedIn = false;
    });
  }
}
