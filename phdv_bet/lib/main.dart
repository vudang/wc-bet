// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await initFirebaseForWeb();
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } else {
    await Firebase.initializeApp();
  }
  runApp(DashboardApp.firebase());
}

Future<void> initFirebaseForWeb() async {
  final apiKey = "AIzaSyD58NcI6jfkI47q_PYy0bYvIpLpANLLJZQ";
  final authDomain = "worldbet-aaa29.firebaseapp.com";
  final projectId = "worldbet-aaa29";
  final storageBucket = "worldbet-aaa29.appspot.com";
  final messagingSenderId = "452255726009";
  final appId = "1:452255726009:web:17cac3a23bcf944e689e68";
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId
  ));
}