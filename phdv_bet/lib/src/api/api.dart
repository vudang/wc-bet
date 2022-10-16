import 'package:web_dashboard/src/model/match.dart';

/// Manipulates app data,
abstract class Api {
  FootballMatchApi get footballMatch;
}

/// Match
abstract class FootballMatchApi {
  Future<List<FootballMatch>> list();
  Future<FootballMatch?> get(String id);
  Stream<List<FootballMatch>> subscribe();
}
