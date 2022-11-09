import 'dart:math';

import 'package:web_dashboard/src/model/bet.dart';
import 'package:web_dashboard/src/model/user.dart';

enum BetResulttype { lose, win }

class BetResult {
  final Bet bet;
  final BetResulttype result;

  BetResult(this.bet, this.result);

  bool get isLoose {
    return result == BetResulttype.lose;
  }

  bool get isMissing {
    return bet.choosedTeam == null;
  }

  String get toValueString {
    if (isMissing) {
      return "Missed";
    }
    if (isLoose) {
      return "Lost";
    }
    return "Won";
  }
}

class UserBet {
  final User user;
  final List<BetResult> bets;
  int availableScore = 0;

  int get loseScore {
    return max((user.amount ?? 0) - availableScore, 0);
  }

  UserBet(this.user, this.bets) {
    int total = user.amount ?? 0;
    bets.forEach((bet) {
      if (bet.isLoose) {
        total -= (bet.bet.amount ?? 0);
      }
    });
    availableScore = total;
  }
}

class Ranking {
  final User user;
  final int amount;

  Ranking({required this.user, required this.amount});
}
