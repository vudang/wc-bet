import 'package:json_annotation/json_annotation.dart';
part 'winner.g.dart';

@JsonSerializable(includeIfNull: false)
class Winner {
  Winner({
    this.amount,
    this.teamId,
    this.userId,
    this.date
  });

  @JsonKey(name: "amount")
  final int? amount;

  @JsonKey(name: "chooseTeam")
  final int? teamId;

  @JsonKey(name: "userId")
  final String? userId;

  @JsonKey(name: "date")
  final DateTime? date;

  factory Winner.fromJson(Map<String, dynamic> json) => _$WinnerFromJson(json);

  Map<String, dynamic> toJson() => _$WinnerToJson(this);
}
