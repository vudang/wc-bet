import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../color.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_textfield_border.dart';

class RegisterForm extends StatefulWidget {
  final Function(List<String>) onRegister; // username / pass
  final VoidCallback onBacktoLogin;
  RegisterForm({super.key, required this.onRegister, required this.onBacktoLogin});
  
  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _emailController = TextEditingController(text: "");
  var _passwordController = TextEditingController(text: "");
  var _passwordConfirmController = TextEditingController(text: "");
  bool _isSecurePassword = true;
  bool _isSecureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return _registerForm();
  }

  Widget _registerForm() {
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
                  AppText("Register", weight: FontWeight.w700, size: 28),
                  SizedBox(height: 20),
                  AppText("Username"),
                  SizedBox(height: 5),
                  AppTextFieldBorder(
                      controller: _emailController,
                      placeholder: "abc@bet.com",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: 20),
                  AppText("Password"),
                  SizedBox(height: 5),
                  AppTextFieldBorder(
                    controller: _passwordController,
                    placeholder: "******",
                    obscureText: _isSecurePassword,
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
                  SizedBox(height: 20),
                  AppText("Re-Enter Password"),
                  SizedBox(height: 5),
                  AppTextFieldBorder(
                    controller: _passwordConfirmController,
                    placeholder: "******",
                    obscureText: _isSecureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: _isSecureConfirmPassword
                          ? Icon(CupertinoIcons.eye_solid,
                              color: SystemColor.GREY)
                          : Icon(CupertinoIcons.eye_slash_fill,
                              color: SystemColor.GREY),
                      onPressed: () {
                        setState(() => _isSecureConfirmPassword = !_isSecureConfirmPassword);
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  AppSystemRegularButton(
                      text: "Register",
                      size: AppButtonSize.huge,
                      onPressed: () => _registerPressed()),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () => widget.onBacktoLogin(),
                        child: AppText(
                          "Back to Login",
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
  
  _registerPressed() {
    widget.onRegister([_emailController.text, _passwordController.text, _passwordConfirmController.text]);
  }
}