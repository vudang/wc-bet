import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/api/api.dart';

import '../model/match.dart';

class FirebaseFootballMatchApi implements FootballMatchApi {
  final FirebaseFirestore fireStore;
  final CollectionReference<Map<String, dynamic>> ref;

  FirebaseFootballMatchApi(this.fireStore) : ref = fireStore.collection('match');

  @override
  Future<FootballMatch?> get(String id) async {
    var document = ref.doc('$id');
    var snapshot = await document.get();
    return FootballMatch.fromJson(snapshot.data()!);
  }

  @override
  Future<List<FootballMatch>> list() async {
    final querySnapshot = await ref.get();
    final entries = querySnapshot.docs
        .map((doc) => FootballMatch.fromJson(doc.data()))
        .toList();
    entries.sort(((a, b) => ((a.date ?? DateTime.now())).compareTo((b.date ?? DateTime.now()))));
    return entries;
  }

  @override
  Future<List<FootballMatch>> listFinished() async {
    final querySnapshot = await ref.where("finished", isEqualTo: true).get();
    final entries = querySnapshot.docs
        .map((doc) => FootballMatch.fromJson(doc.data()))
        .toList();
    entries.sort(((a, b) => ((a.date ?? DateTime.now())).compareTo((b.date ?? DateTime.now()))));
    return entries;
  }

  @override
  Stream<List<FootballMatch>> subscribe() {
    var snapshots = ref.snapshots();
    var result = snapshots.map<List<FootballMatch>>((querySnapshot) {
      final list = querySnapshot.docs.map<FootballMatch>((snapshot) {
        return FootballMatch.fromJson(snapshot.data());
      }).toList();
      list.sort(((a, b) => ((a.date ?? DateTime.now())).compareTo((b.date ?? DateTime.now()))));
      return list;
    });

    return result;
  }
  
  @override
  Future<List<FootballMatch>> listForTeam(String teamId) async {
    final querySnapshot = await ref.get();
    final entries = querySnapshot.docs
        .map((doc) => FootballMatch.fromJson(doc.data()))
        .where((team) {
          return team.awayTeamId == teamId || team.homeTeamId == teamId;
        })
        .toList();
    return entries;
  }

}