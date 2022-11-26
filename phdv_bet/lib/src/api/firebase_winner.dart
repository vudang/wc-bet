import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/winner.dart';

class FirebaseWinnerApi implements WinnerApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseWinnerApi(this.fireStore) : ref = fireStore.collection('winner');

  @override
  Future<List<Winner>> list() async {
    final querySnapshot = await ref.get();
    final entries = querySnapshot.docs.map((doc) => Winner.fromJson(doc.data())).toList();
    return entries;
  }

  @override
  Future<void> placeWinner(Winner winner) {
    return ref.doc(winner.userId).set(winner.toJson());
  }
}