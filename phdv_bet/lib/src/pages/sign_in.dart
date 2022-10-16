import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthen;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_dashboard/src/auth/firebase.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/app_textfield_border.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';
import '../assets.dart';
import '../auth/auth.dart';
import '../widgets/app_button.dart';

class SignInPage extends StatelessWidget {
  final Auth auth;
  final ValueChanged<User> onSuccess;

  const SignInPage({
    required this.auth,
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
            child: SignInForm(auth: auth, onSuccess: onSuccess),
          )
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final Auth auth;
  final ValueChanged<User> onSuccess;

  const SignInForm({
    required this.auth,
    required this.onSuccess,
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  Future<bool>? _checkSignInFuture;
  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  var _isSecurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkSignInFuture = _checkIfSignedIn();
  }

  Future<bool> _checkIfSignedIn() async {
    var alreadySignedIn = await widget.auth.isSignedIn;
    if (alreadySignedIn) {
      final user = FirebaseUser(FirebaseAuthen.FirebaseAuth.instance.currentUser!.uid);
      print("Already auth with user: ${user.uid}");
      widget.onSuccess(user);
    }
    return alreadySignedIn;
  }

  Future<void> _signIn() async {
    try {
      Indicator.show(context);
      var user = await widget.auth.signIn(username: _emailController.text, password: _passwordController.text);
      Indicator.hide(context);
      if (user != null) {
        widget.onSuccess(user);
      }
    } on SignInException {
      Indicator.hide(context);
      _showError();
    }
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

        return _loginForm();
      },
    );
  }

  Widget _loginForm() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText("Sign In", weight: FontWeight.w700, size: 28),
                SizedBox(height: 20),
                AppText("Username"),
                SizedBox(height: 5),
                AppTextFieldBorder(
                  controller: _emailController,
                  placeholder: "abc@bet.com",
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress
                ),
                SizedBox(height: 20),
                AppText("Password"),
                SizedBox(height: 5),
                AppTextFieldBorder(
                  controller: _passwordController,
                  placeholder: "******",
                  obscureText: _isSecurePassword,
                  suffixIcon: IconButton(
                    icon: _isSecurePassword ? Icon(CupertinoIcons.eye_solid, color: SystemColor.GREY) : Icon(CupertinoIcons.eye_slash_fill, color: SystemColor.GREY),
                    onPressed: () {
                      setState(() => _isSecurePassword = !_isSecurePassword);
                    },
                  ),
                ),
                SizedBox(height: 40),
                AppSystemRegularButton(
                  text: "Sign In",
                  size: AppButtonSize.huge,
                  onPressed: () => _signInPressed()
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () => _contactUsPressed(),
                      child: AppText(
                        "Contact Us",
                        size: 15,
                        color: SystemColor.GREY,
                        weight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      )
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }

  _signInPressed() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showError(message: "Please enter your email / password to SignIn");
      return;
    }
    _signIn();
  }

  _contactUsPressed() {
    final uri = Uri.parse("https://forms.gle/5tb3aSsc3UfpnXP1A");
    launchUrl(uri);
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
