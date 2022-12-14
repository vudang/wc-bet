// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract class Auth {
  Future<bool> get isSignedIn;
  Future<User?> signIn({required String username, required String password});
  Future<User?> register({required String username, required String password});
  Future signOut();
}

abstract class User {
  String get uid;
}

class SignInException implements Exception {}
