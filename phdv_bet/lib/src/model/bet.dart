import 'package:json_annotation/json_annotation.dart';
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
}
