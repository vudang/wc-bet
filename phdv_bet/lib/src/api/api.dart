import 'package:web_dashboard/src/model/bet.dart';
import 'package:web_dashboard/src/model/config.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/odd.dart';
import 'package:web_dashboard/src/model/standing.dart';
import 'package:web_dashboard/src/model/team.dart';
import 'package:web_dashboard/src/model/user.dart';
import 'package:web_dashboard/src/model/winner.dart';

/// Manipulates app data,
abstract class Api {
  FootballMatchApi get footballMatchApi;
  StandingApi get standingApi;
  OddApi get oddApi;
  ConfigApi get configApi;
  BetApi get betApi;
  UserApi get userApi;
  WinnerApi get winnerApi;
  TeamApi get teamApi;
}

/// Winner
abstract class WinnerApi {
  Stream<List<Winner>> subcribe();
  Future<void> placeWinner(Winner winner);
}

/// Team
abstract class TeamApi {
  Future<List<Team>> list();
}


/// User
abstract class UserApi {
  Future<List<User>> list();
  Future<User?> get(String userId);
  Future<void> create();
}


/// Bat
abstract class BetApi {
  Future<List<Bet>> list();
  Stream<List<Bet>> subscribe();
  Stream<List<Bet>> getListBetForMatch(int matchId);
  Stream<List<Bet>> getListMyBet();
  Stream<Bet?> getMyBet(int matchId);
  Future<void> placeBet(Bet bet);
}

/// Match
abstract class FootballMatchApi {
  Future<List<FootballMatch>> list();
  Future<List<FootballMatch>> listFinished();
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

/// Odd
abstract class OddApi {
  Future<List<Odd>> list({bool isFillterLocked = true});
  Future<Odd?> get({required int matchId});
}

/// Config
abstract class ConfigApi {
  Future<Config?> get();
}
