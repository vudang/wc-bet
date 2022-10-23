// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Standing _$StandingFromJson(Map<String, dynamic> json) => Standing(
      id: json['_id'] as String?,
      group: json['group'] as String?,
      teams: (json['teams'] as List<dynamic>?)
          ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StandingToJson(Standing instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('group', instance.group);
  writeNotNull('teams', instance.teams);
  return val;
}
