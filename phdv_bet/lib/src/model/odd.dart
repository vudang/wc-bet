import 'package:json_annotation/json_annotation.dart';
part 'odd.g.dart';

@JsonSerializable(includeIfNull: false)
class Odd {
  Odd({
      this.amount,
      this.fullMatch,
      this.matchId,
      this.teamAway,
      this.teamHome,
      this.isLock
  });

  @JsonKey(name: "amount")
  final int? amount;

  @JsonKey(name: "fullMatch")
  final FullMatch? fullMatch;

  @JsonKey(name: "matchId")
  final int? matchId;

  @JsonKey(name: "teamAway")
  final String? teamAway;

  @JsonKey(name: "teamHome")
  final String? teamHome;

  @JsonKey(name: "lock")
  final bool? isLock;

  factory Odd.fromJson(Map<String, dynamic> json) => _$OddFromJson(json);
  Map<String, dynamic> toJson() => _$OddToJson(this);


  @JsonKey(ignore: true)
  String? get label {
    final label = fullMatch?.asianHandicap?.first.label;
    return label;
  }

  @JsonKey(ignore: true)
  String? get homePrefix {
    final prefix = fullMatch?.asianHandicap?.first.prefix;
    return prefix;
  }

  @JsonKey(ignore: true)
  String? get awayPrefix {
    final prefix = fullMatch?.asianHandicap?.first.prefix;
    return prefix == "+" ? "-" : "+";
  }

  @JsonKey(ignore: true)
  String? get desciption {
    final label = fullMatch?.asianHandicap?.first.label;
    final prefix = fullMatch?.asianHandicap?.first.prefix;
    if (label == "0") {
      return "Đồng banh, kẻ tám lạng người nửa kilogram :D";
    }

    if (prefix == "-") {
      return "$teamHome chấp $teamAway $label quả";
    }

    return "$teamAway chấp đội $teamHome $label quả";
  }

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

  @JsonKey(ignore: true)
  String? get homePrefix {
    return prefix;
  }

  @JsonKey(ignore: true)
  String? get awayPrefix {
    return prefix == "+" ? "-" : "+";
  }

  factory AsianHandicap.fromJson(Map<String, dynamic> json) => _$AsianHandicapFromJson(json);
  Map<String, dynamic> toJson() => _$AsianHandicapToJson(this);
}
