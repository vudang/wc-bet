// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FootballMatch _$MatchFromJson(Map<String, dynamic> json) => FootballMatch(
      id: json['_id'] as String?,
      awayScore: json['away_score'] as int?,
      awayScorers: (json['away_scorers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      awayTeamId: json['away_team_id'] as String?,
      finished: json['finished'] as String?,
      group: json['group'] as String?,
      homeScore: json['home_score'] as int?,
      homeScorers: (json['home_scorers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      homeTeamId: json['home_team_id'] as String?,
      matchId: json['id'] as int?,
      localDate: json['local_date'] as String?,
      matchday: json['matchday'] as int?,
      persianDate: json['persian_date'] as String?,
      stadiumId: json['stadium_id'] as String?,
      timeElapsed: json['time_elapsed'] as String?,
      type: json['type'] as String?,
      homeTeamFa: json['home_team_fa'] as String?,
      awayTeamFa: json['away_team_fa'] as String?,
      homeTeamEn: json['home_team_en'] as String?,
      awayTeamEn: json['away_team_en'] as String?,
      homeFlag: json['home_flag'] as String?,
      awayFlag: json['away_flag'] as String?,
    );

Map<String, dynamic> _$MatchToJson(FootballMatch instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('away_score', instance.awayScore);
  writeNotNull('away_scorers', instance.awayScorers);
  writeNotNull('away_team_id', instance.awayTeamId);
  writeNotNull('finished', instance.finished);
  writeNotNull('group', instance.group);
  writeNotNull('home_score', instance.homeScore);
  writeNotNull('home_scorers', instance.homeScorers);
  writeNotNull('home_team_id', instance.homeTeamId);
  writeNotNull('id', instance.matchId);
  writeNotNull('local_date', instance.localDate);
  writeNotNull('matchday', instance.matchday);
  writeNotNull('persian_date', instance.persianDate);
  writeNotNull('stadium_id', instance.stadiumId);
  writeNotNull('time_elapsed', instance.timeElapsed);
  writeNotNull('type', instance.type);
  writeNotNull('home_team_fa', instance.homeTeamFa);
  writeNotNull('away_team_fa', instance.awayTeamFa);
  writeNotNull('home_team_en', instance.homeTeamEn);
  writeNotNull('away_team_en', instance.awayTeamEn);
  writeNotNull('home_flag', instance.homeFlag);
  writeNotNull('away_flag', instance.awayFlag);
  return val;
}
