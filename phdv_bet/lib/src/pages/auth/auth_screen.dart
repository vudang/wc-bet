import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthen;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/app.dart';
import 'package:web_dashboard/src/auth/firebase.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/pages/auth/login_form.dart';
import 'package:web_dashboard/src/pages/auth/register_form.dart';
import 'package:web_dashboard/src/widgets/app_confirm_popup.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import '../../assets.dart';
import '../../auth/auth.dart';
import '../../widgets/app_button.dart';

class AuthScreen extends StatelessWidget {
  final Auth auth;
  final UserApi userApi;
  final ValueChanged<User> onSuccess;

  const AuthScreen({
    required this.auth,
    required this.userApi,
    required this.onSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(Assets.images.background, fit: BoxFit.cover),
          ),
          Center(
            child: AuthForm(auth: auth, onSuccess: onSuccess, userApi: userApi),
          )
        ],
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  final Auth auth;
  final UserApi userApi;
  final ValueChanged<User> onSuccess;

  const AuthForm({
    required this.auth,
    required this.userApi,
    required this.onSuccess,
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Future<bool>? _checkSignInFuture;
  bool _showRegister = false;
  
  @override
  void initState() {
    super.initState();
    _checkSignInFuture = _checkIfSignedIn();
  }

  Future<bool> _checkIfSignedIn() async {
    var alreadySignedIn = await widget.auth.isSignedIn;
    if (alreadySignedIn) {
      final user = FirebaseUser(FirebaseAuthen.FirebaseAuth.instance.currentUser!.uid);
      return await _checkUserAuth(user);
    }
    return false;
  }

  Future<void> _signIn(String email, String password) async {
    try {
      Indicator.show(context);
      var user = await widget.auth.signIn(username: email, password: password);
      Indicator.hide(context);
      if (user != null) {
        _checkUserAuth(user);
      }
    } on SignInException {
      Indicator.hide(context);
      _showError();
    }
  }

   Future<void> _register(String email, String password) async {
    try {
      Indicator.show(context);
      var user = await widget.auth.register(username: email, password: password);
      if (user != null) {
        await widget.userApi.create();
        Indicator.hide(context);
        _checkUserAuth(user);
      } else {
        Indicator.hide(context);
      }
    } on SignInException {
      Indicator.hide(context);
      _showError();
    }
  }


  Future<bool> _checkUserAuth(User user) async {
    print("Check User active: ${user.uid} => ");
    final appUser = await widget.userApi.get(user.uid);
    print("User active: ${appUser?.toJson()} => ${appUser?.active}");
    if ((appUser?.active ?? false) == false) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: AppText("Unlock your account", weight: FontWeight.w700),
            content: AppText("Please waitting or contact to admin to active your account :p"),
            actions: [
              SizedBox(
                width: 100,
                child: AppSystemRegularButton(
                    text: "Got it",
                    onPressed: () => Navigator.of(context).pop(),
                    customColor: Colors.transparent,
                    customTextColor: SystemColor.RED,
                ),
              )
            ],
          );
        }
      );
      return false;
    }
    widget.onSuccess(user);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkSignInFuture,
      builder: (context, snapshot) {
        var alreadySignedIn = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done || alreadySignedIn == true) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          _showError();
        }

        return Container(
          width: kIsWeb ? 430 : null,
          child: _showRegister ? _registerForm() : _loginForm()
        );
      },
    );
  }

  
  
  Widget _loginForm() {
    return LoginForm(
      onSigin: (args) {
        _signInPressed(email: args.first, password: args.last);
      },
      onRegisterPressed: () {
        _registerPressed();
      },
    );
  }

  Widget _registerForm() {
    return RegisterForm(
      onRegister: (args) {
        _onRegister(args[0], args[1], args[2]);
      },
      onBacktoLogin: () {
        setState(() {
          _showRegister = false;
        });
      });
  }

  _signInPressed({required String email, required String password}) {
    if (email.trim().isEmpty || password.isEmpty) {
      _showError(message: "Please enter your email / password to SignIn");
      return;
    }
    _signIn(email, password);
  }

  _registerPressed() {
    setState(() {
      _showRegister = true;
    });;
  }
  
  _onRegister(String email, String password, String confirmPassword) {
    if (email.trim().isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError(message: "Please enter your email / password to SignIn");
      return;
    }

    if (password != confirmPassword) {
      _showError(message: "Please check your password");
      return;
    }

    _register(email, password);
  }

  _showError({String message = 'Unable to sign in.'}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: SystemColor.RED,
        content: AppText(message, size: 17, color: SystemColor.WHITE),
      ),
    );
  }
}
