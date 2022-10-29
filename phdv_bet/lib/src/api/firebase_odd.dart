import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/odd.dart';

class FirebaseOddApi implements OddApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseOddApi(this.fireStore) : ref = fireStore.collection('odds');

  @override
  Future<Odd?> get({required int matchId}) async {
    final querySnapshot = await ref.where("matchId", isEqualTo: matchId).get();
    final odds = querySnapshot.docs.map((doc) => Odd.fromJson(doc.data()));
    if (odds.isNotEmpty) {
      return odds.first;
    }
    return null;
  }
}