import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_textfield_border.dart';

class LoginForm extends StatefulWidget {
  final Function(List<String>) onSigin; // username / pass
  final VoidCallback onRegisterPressed;
  LoginForm({super.key, required this.onSigin, required this.onRegisterPressed});
  
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _emailController = TextEditingController(text: "");
  var _passwordController = TextEditingController(text: "");
  bool _isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return _loginForm();
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
                      onFieldSubmitted: (value) => _signInPressed(),
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: 20),
                  AppText("Password"),
                  SizedBox(height: 5),
                  AppTextFieldBorder(
                    controller: _passwordController,
                    placeholder: "******",
                    obscureText: _isSecurePassword,
                    onFieldSubmitted: (value) => _signInPressed(),
                    suffixIcon: IconButton(
                      icon: _isSecurePassword
                          ? Icon(CupertinoIcons.eye_solid,
                              color: SystemColor.GREY)
                          : Icon(CupertinoIcons.eye_slash_fill,
                              color: SystemColor.GREY),
                      onPressed: () {
                        setState(() => _isSecurePassword = !_isSecurePassword);
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  AppSystemRegularButton(
                      text: "Sign In",
                      size: AppButtonSize.huge,
                      onPressed: () => _signInPressed()),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () => _registerPressed(),
                        child: AppText(
                          "Register",
                          size: 15,
                          color: SystemColor.GREY,
                          weight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        )),
                  )
                ],
              ),
            )),
      ),
    );
  }
  
  _signInPressed() {
    widget.onSigin([_emailController.text, _passwordController.text]);
  }
  
  _registerPressed() {
    widget.onRegisterPressed();
  }
}