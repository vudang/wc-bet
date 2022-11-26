// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: json['id'] as String?,
      teamId: json['team_id'] as String?,
      nameEn: json['name_en'] as String?,
      flag: json['flag'] as String?,
      groups: json['groups'] as String?,
      pts: json['pts'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$TeamToJson(Team instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('active', instance.active);
  writeNotNull('name_en', instance.nameEn);
  writeNotNull('flag', instance.flag);
  writeNotNull('groups', instance.groups);
  writeNotNull('id', instance.id);
  writeNotNull('team_id', instance.teamId);
  writeNotNull('pts', instance.pts);
  return val;
}
