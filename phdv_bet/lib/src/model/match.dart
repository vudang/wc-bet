import 'package:json_annotation/json_annotation.dart';
import 'package:web_dashboard/src/utils/day_helpers.dart';
part 'match.g.dart';

@JsonSerializable(includeIfNull: false)
class FootballMatch {
  FootballMatch({
    this.id,
    this.awayScore,
    this.awayScorers,
    this.awayTeamId,
    this.finished,
    this.group,
    this.homeScore,
    this.homeScorers,
    this.homeTeamId,
    this.matchId,
    this.localDate,
    this.matchday,
    this.persianDate,
    this.stadiumId,
    this.timeElapsed,
    this.type,
    this.homeTeamFa,
    this.awayTeamFa,
    this.homeTeamEn,
    this.awayTeamEn,
    this.homeFlag,
    this.awayFlag,
  });

  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "away_score")
  final int? awayScore;

  @JsonKey(name: "away_scorers")
  final List<String>? awayScorers;

  @JsonKey(name: "away_team_id")
  final String? awayTeamId;

  @JsonKey(name: "finished")
  final String? finished;

  @JsonKey(name: "group")
  final String? group;

  @JsonKey(name: "home_score")
  final int? homeScore;

  @JsonKey(name: "home_scorers")
  final List<String>? homeScorers;

  @JsonKey(name: "home_team_id")
  final String? homeTeamId;

  @JsonKey(name: "id")
  final int? matchId;

  @JsonKey(name: "local_date")
  final String? localDate;

  @JsonKey(name: "matchday")
  final int? matchday;

  @JsonKey(name: "persian_date")
  final String? persianDate;

  @JsonKey(name: "stadium_id")
  final String? stadiumId;

  @JsonKey(name: "time_elapsed")
  final String? timeElapsed;

  @JsonKey(name: "type")
  final String? type;

  @JsonKey(name: "home_team_fa")
  final String? homeTeamFa;

  @JsonKey(name: "away_team_fa")
  final String? awayTeamFa;

  @JsonKey(name: "home_team_en")
  final String? homeTeamEn;

  @JsonKey(name: "away_team_en")
  final String? awayTeamEn;

  @JsonKey(name: "home_flag")
  final String? homeFlag;

  @JsonKey(name: "away_flag")
  final String? awayFlag;


  factory FootballMatch.fromJson(Map<String, dynamic> json) => _$FootballMatchFromJson(json);
  Map<String, dynamic> toJson() => _$FootballMatchToJson(this);

  @JsonKey(ignore: true)
  DateTime? get date {
    return DateHelper.parseDateTime(input: localDate ?? "");
  }
}