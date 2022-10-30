import 'package:json_annotation/json_annotation.dart';
import 'package:web_dashboard/src/model/match.dart';
import 'package:web_dashboard/src/model/odd.dart';
import 'package:web_dashboard/src/model/bet_result.dart';
import 'package:web_dashboard/src/model/team.dart';
part 'bet.g.dart';

@JsonSerializable(includeIfNull: false)
class Bet {
  Bet({
    this.amount,
    this.matchId,
    this.choosedTeam,
    this.userId
  });

  @JsonKey(name: "amount")
  final int? amount;

  @JsonKey(name: "matchId")
  final int? matchId;

  @JsonKey(name: "choosedTeam")
  final String? choosedTeam;

  @JsonKey(name: "userId")
  final String? userId;

  factory Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);
  Map<String, dynamic> toJson() => _$BetToJson(this);

  @JsonKey(ignore: true)
  TeamType get teamChoosed {
    return TeamType(choosedTeam ?? "");
  }

  /// Check bet result
  BetResulttype betResult(Odd odd, FootballMatch match) {
    final homePrefix = "${odd.homePrefix}${odd.label}";
    final double prefixValue = double.parse(homePrefix);
    final totalHomeScore = (match.homeScore ?? 0).toDouble() + prefixValue;
    final totalAwayScore = match.awayScore ?? 0;

    late BetResulttype result;
    final isChooseHome = teamChoosed.isHome;
    if (isChooseHome) {
      /// Chọn đội chủ nhà
      result = totalHomeScore >= totalAwayScore ? BetResulttype.win : BetResulttype.lose;
    } else {
      /// Chọn đội khách
      result = totalHomeScore <= totalAwayScore ? BetResulttype.win : BetResulttype.lose;
    }

    return result;
  }
}
