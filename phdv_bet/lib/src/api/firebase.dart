import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/firebase_match.dart';

import 'api.dart';

class FirebaseApi implements Api {
  @override
  final FootballMatchApi footballMatch;

  FirebaseApi(FirebaseFirestore firestore, String userId)
      : footballMatch = FirebaseFootballMatchApi(firestore);
}
