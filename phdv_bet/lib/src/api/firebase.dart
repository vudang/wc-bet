import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/firebase_bet.dart';
import 'package:web_dashboard/src/api/firebase_config.dart';
import 'package:web_dashboard/src/api/firebase_match.dart';
import 'package:web_dashboard/src/api/firebase_odd.dart';
import 'package:web_dashboard/src/api/firebase_standing.dart';

import 'api.dart';

class FirebaseApi implements Api {
  @override
  final FootballMatchApi footballMatchApi;

  @override
  final StandingApi standingApi;

  @override
  final OddApi oddApi;

  @override
  final ConfigApi configApi;

  @override
  final BetApi betApi;

  FirebaseApi(FirebaseFirestore firestore, String userId) :
   footballMatchApi = FirebaseFootballMatchApi(firestore),
        standingApi = FirebaseStandingApi(firestore),
             oddApi = FirebaseOddApi(firestore),
          configApi = FirebaseConfigApi(firestore),
             betApi = FirebaseBetApi(firestore);
}
