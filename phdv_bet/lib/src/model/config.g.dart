// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      homeBannerUrl: json['home_banner_url'] as String?,
      stadiumUrl: json['stadium_url'] as String?,
      helpUrl: json['help_url'] as String?,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('home_banner_url', instance.homeBannerUrl);
  writeNotNull('stadium_url', instance.stadiumUrl);
  writeNotNull('help_url', instance.helpUrl);
  return val;
}
