import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirAuth;
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/user.dart';

class FirebaseUserApi implements UserApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseUserApi(this.fireStore) : ref = fireStore.collection('user');

  @override
  Future<User?> get(String userId) async {
    print("Firebase get user => ${userId}");
    final querySnapshot = await ref.where("localId", isEqualTo: userId).get();
    print("Firebase get user => ${querySnapshot.docs.length}");
    final odds = querySnapshot.docs.map((doc) => User.fromJson(doc.data()));
    if (odds.isNotEmpty) {
      return odds.first;
    }
    return null;
  }

  @override
  Future<List<User>> list() async {
    final querySnapshot = await ref.get();
    final entries = querySnapshot.docs
        .map((doc) => User.fromJson(doc.data()))
        .toList();
    return entries;
  }


  @override
  Future<void> create() async {
    final authUser = FirAuth.FirebaseAuth.instance.currentUser;
    final user = User(userId: authUser?.uid, displayName: authUser?.displayName, email: authUser?.email, active: false);
    await ref.doc(authUser?.uid).set(user.toJson());
  }
}