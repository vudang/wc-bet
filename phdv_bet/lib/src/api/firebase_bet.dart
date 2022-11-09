import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/model/bet.dart';

class FirebaseBetApi implements BetApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseBetApi(this.fireStore) : ref = fireStore.collection('bet');

  @override
  Future<void> placeBet(Bet bet) {
    return ref.add(bet.toJson());
  }

  @override
  Stream<List<Bet>> subscribe() {
    var snapshots = ref.snapshots();
    var result = snapshots.map<List<Bet>>((querySnapshot) {
      return querySnapshot.docs.map<Bet>((snapshot) {
        return Bet.fromJson(snapshot.data());
      }).toList();
    });
    return result;
  }
  
  @override
  Stream<Bet?> getMyBet(int matchId) {
    return ref.where("matchId", isEqualTo: matchId)
    .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    .snapshots()
    .map((snapshots) {
      final results = snapshots.docs.map<Bet>((snapshot) {
        return Bet.fromJson(snapshot.data());
      }).toList();
      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    });
  }
  
  @override
  Stream<List<Bet>> getListBetForMatch(int matchId) {
    final snapshots = ref.where("matchId", isEqualTo: matchId).snapshots();
    var result = snapshots.map<List<Bet>>((querySnapshot) {
      return querySnapshot.docs.map<Bet>((snapshot) {
        return Bet.fromJson(snapshot.data());
      }).toList();
    });
    return result;
  }

  @override
  Future<List<Bet>> list() async {
    final querySnapshot = await ref.get();
    final entries = querySnapshot.docs.map((doc) => Bet.fromJson(doc.data())).toList();
    return entries;
  }
  
  @override
  Stream<List<Bet>> getListMyBet() {
    final authID = FirebaseAuth.instance.currentUser?.uid;
    if (authID == null) {
      return Stream.fromIterable([]);
    }
    final snapshots = ref.where("userId", isEqualTo: authID).snapshots();
    var result = snapshots.map<List<Bet>>((querySnapshot) {
      return querySnapshot.docs.map<Bet>((snapshot) {
        return Bet.fromJson(snapshot.data());
      }).toList();
    });
    return result;
  }
}