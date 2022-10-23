import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/config.dart';

class FirebaseConfigApi implements ConfigApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseConfigApi(this.fireStore) : ref = fireStore.collection('resource');


  @override
  Future<Config?> get() async {
    final querySnapshot = await ref.get();
    return querySnapshot.docs.map((doc) => Config.fromJson(doc.data())).first;
  }
}