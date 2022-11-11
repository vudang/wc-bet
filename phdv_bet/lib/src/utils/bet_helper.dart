
import 'package:web_dashboard/src/model/user.dart';

import '../model/bet.dart';
import '../model/bet_result.dart';
import '../model/match.dart';
import '../model/odd.dart';

class BetHelper {
  /// Lấy kết quả bet của tất cả các trận đã đá của user
  static UserBet getUserBetData({
    required User user,
    required List<Bet> bets,
    required List<FootballMatch> matchs,
    required List<Odd> odds}) {

    /// Trong tất cả các trận đã đá, lấy danh sách các trận đã đặt cược của người chơi
    final List<Bet> userBets = matchs.map((m) {
      final bet = bets.firstWhere((b) => b.matchId == m.matchId && b.userId == user.userId, orElse: () => Bet());
      return bet;
    }).toList();

    /// Kiểm tra kết qủa bet
    final List<BetResult> userBetsResult = odds.map((odd) {
      final bet = userBets.firstWhere((b) => b.matchId == odd.matchId, orElse: () => Bet());
      final match = matchs.firstWhere((m) => m.matchId == odd.matchId, orElse: () => FootballMatch());
      if (bet.matchId != null) {
        final BetResulttype type = bet.betResult(odd, match);
        final result = BetResult(bet, type);
        return result;
      } else {
        /// Không BET mặc định là thua
        final looseBet = Bet(amount: odd.amount, matchId: odd.matchId, userId: user.userId);
        final result = BetResult(looseBet, BetResulttype.lose);
        return result;
      }
    }).toList();

    return UserBet(user, userBetsResult);
  }

  /// Lấy kết danh sách các trận bet của user mà chưa đá xong
  static UserBet getUserBetDoesNotPlay({
    required User user,
    required List<Bet> bets,
    required List<FootballMatch> matchs}) {

    /// Trong tất cả các trận, lấy danh sách các trận đã đặt cược của người chơi
    final matchNotPlays = matchs.where((element) => element.finished == false);
    final List<Bet> userBets = matchNotPlays.map((m) {
      final bet = bets.firstWhere((b) => b.matchId == m.matchId && b.userId == user.userId, orElse: () => Bet());
      return bet;
    }).toList();
    userBets.removeWhere((element) => element.matchId == null);

    final betResults = userBets.map((e) => BetResult(e, BetResulttype.waiting)).toList();

    return UserBet(user, betResults);
  }
}

