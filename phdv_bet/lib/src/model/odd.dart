import 'package:json_annotation/json_annotation.dart';
part 'odd.g.dart';

@JsonSerializable(includeIfNull: false)
class Odd {
  Odd({
      this.amount,
      this.fullMatch,
      this.matchId,
  });

  @JsonKey(name: "amount")
  final int? amount;

  @JsonKey(name: "fullMatch")
  final FullMatch? fullMatch;

  @JsonKey(name: "matchId")
  final int? matchId;

  factory Odd.fromJson(Map<String, dynamic> json) => _$OddFromJson(json);
  Map<String, dynamic> toJson() => _$OddToJson(this);
}

@JsonSerializable(includeIfNull: false)
class FullMatch {
  FullMatch({
      this.asianHandicap
  });

  @JsonKey(name: "asianHandicap")
  final List<AsianHandicap>? asianHandicap;


  factory FullMatch.fromJson(Map<String, dynamic> json) => _$FullMatchFromJson(json);
  Map<String, dynamic> toJson() => _$FullMatchToJson(this);
}

@JsonSerializable(includeIfNull: false)
class AsianHandicap {
  AsianHandicap({
      this.away,
      this.home,
      this.label,
      this.prefix,
  });

  @JsonKey(name: "away")
  final String? away;

  @JsonKey(name: "home")
  final String? home;

  @JsonKey(name: "label")
  final String? label;

  @JsonKey(name: "prefix")
  final String? prefix;

  factory AsianHandicap.fromJson(Map<String, dynamic> json) => _$AsianHandicapFromJson(json);
  Map<String, dynamic> toJson() => _$AsianHandicapToJson(this);
}
