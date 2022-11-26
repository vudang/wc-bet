import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/winner.dart';

class FirebaseWinnerApi implements WinnerApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseWinnerApi(this.fireStore) : ref = fireStore.collection('winner');

  @override
  Future<void> placeWinner(Winner winner) {
    return ref.doc(winner.userId).set(winner.toJson());
  }
  
  @override
  Stream<List<Winner>> subcribe() {
    var snapshots = ref.snapshots();
    var result = snapshots.map<List<Winner>>((querySnapshot) {
      final list = querySnapshot.docs.map<Winner>((snapshot) {
        return Winner.fromJson(snapshot.data());
      }).toList();
      return list;
    });

    return result;
  }
}