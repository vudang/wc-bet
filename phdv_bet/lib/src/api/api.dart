import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/standing.dart';

/// Manipulates app data,
abstract class Api {
  FootballMatchApi get footballMatchApi;
  StandingApi get standingApi;
}

/// Match
abstract class FootballMatchApi {
  Future<List<FootballMatch>> list();
  Future<FootballMatch?> get(String id);
  Future<List<FootballMatch>> listForTeam(String teamId);
  Stream<List<FootballMatch>> subscribe();
}


/// Standing
abstract class StandingApi {
  Future<List<Standing>> list();
  Future<Standing?> get(String id);
  Stream<List<Standing>> subscribe();
}
