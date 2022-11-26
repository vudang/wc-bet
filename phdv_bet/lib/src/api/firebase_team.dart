import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/model/winner.dart';

class FirebaseTeamApi implements TeamApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseTeamApi(this.fireStore) : ref = fireStore.collection('team');

  @override
  Future<List<Team>> list() async {
    final querySnapshot = await ref.get();
    final entries = querySnapshot.docs.map((doc) => Team.fromJson(doc.data())).toList();
    return entries;
  }

}