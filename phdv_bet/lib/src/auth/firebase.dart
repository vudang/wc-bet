// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth.dart';

class FirebaseAuthService implements Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<bool> get isSignedIn async {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<User?> signIn({required String username, required String password}) async {
    try {
      return await _signIn(username, password);
    } on PlatformException {
      throw SignInException();
    }
  }

  @override
  Future<User?> register({required String username, required String password}) async {
    try {
      return await _register(username, password);
    } on PlatformException {
      throw SignInException();
    }
  }

  Future<User?> _signIn(String username, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      print("Sign in success with user id: ${credential.user!.uid}");
      return FirebaseUser(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }


  Future<User?> _register(String username, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      print("Create account success with user id: ${credential.user!.uid}");
      return FirebaseUser(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
    ]);
  }
}

class FirebaseUser implements User {
  @override
  final String uid;

  FirebaseUser(this.uid);
}
