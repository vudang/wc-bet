import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/standing.dart';

class FirebaseStandingApi implements StandingApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseStandingApi(this.fireStore) : ref = fireStore.collection('standing');

  @override
  Future<Standing?> get(String id) async {
    var document = ref.doc('$id');
    var snapshot = await document.get();
    return Standing.fromJson(snapshot.data()!);
  }

  @override
  Future<List<Standing>> list() async {
    final querySnapshot = await ref.get();
    return querySnapshot.docs
        .map((doc) => Standing.fromJson(doc.data()))
        .toList();
  }

  @override
  Stream<List<Standing>> subscribe() {
    var snapshots = ref.snapshots();
    var result = snapshots.map<List<Standing>>((querySnapshot) {
      return querySnapshot.docs.map<Standing>((snapshot) {
        return Standing.fromJson(snapshot.data());
      }).toList();
    });

    return result;
  }

}