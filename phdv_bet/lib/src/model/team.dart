import 'package:json_annotation/json_annotation.dart';
part 'team.g.dart';

class TeamType {
  static const String HOME = "home";
  static const String AWAY = "away";
  final String type;

  TeamType(this.type);
  
  static TeamType home() {
    return TeamType(HOME);
  }

  static TeamType away() {
    return TeamType(AWAY);
  }

  bool get isHome {
    return type == HOME;
  }

  bool get isAway {
    return type == AWAY;
  }
}

@JsonSerializable(includeIfNull: false)
class Team {
  Team({
      this.id,
      this.teamId,
      this.nameEn,
      this.flag,
      this.groups,
      this.pts
  });

  @JsonKey(name: "name_en")
  final String? nameEn;

  @JsonKey(name: "flag")
  final String? flag;

  @JsonKey(name: "groups")
  final String? groups;

  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "team_id")
  final String? teamId;

  @JsonKey(name: "pts")
  final String? pts;

  @JsonKey(ignore: true)
  int get ptsInt {
    return int.parse(pts ?? "0");
  }

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}