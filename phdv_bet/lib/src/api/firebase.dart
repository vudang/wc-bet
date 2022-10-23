import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/firebase_match.dart';
import 'package:web_dashboard/src/api/firebase_standing.dart';

import 'api.dart';

class FirebaseApi implements Api {
  @override
  final FootballMatchApi footballMatchApi;

  @override
  final StandingApi standingApi;

  FirebaseApi(FirebaseFirestore firestore, String userId) :
   footballMatchApi = FirebaseFootballMatchApi(firestore),
        standingApi = FirebaseStandingApi(firestore);
}
