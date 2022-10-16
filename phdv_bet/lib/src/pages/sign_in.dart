// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthen;
import 'package:flutter/material.dart';
import 'package:web_dashboard/src/auth/firebase.dart';
import 'package:web_dashboard/src/color.dart';
import 'package:web_dashboard/src/widgets/app_text.dart';
import 'package:web_dashboard/src/widgets/app_textfield_border.dart';
import 'package:web_dashboard/src/widgets/indicator.dart';

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
      body: Center(
        child: SignInForm(auth: auth, onSuccess: onSuccess),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                  autofocus: true,
                ),
                SizedBox(height: 20),
                AppText("Password"),
                SizedBox(height: 5),
                AppTextFieldBorder(
                  controller: _passwordController,
                  placeholder: "******",
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
    _signIn();
  }

  _contactUsPressed() {}

  _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unable to sign in.'),
      ),
    );
  }
}
