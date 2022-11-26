// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      homeBannerUrl: json['home_banner_url'] as String?,
      stadiumUrl: json['stadium_url'] as String?,
      helpUrl: json['help_url'] as String?,
      ruleUrl: json['rule_url'] as String?,
      standingUrl: json['standing_url'] as String?,
      iosDownloadLink: json['ios_download_link'] as String?,
      winnerLock: json['winner_lock'] as bool?,
      winnerTimeEnd: json['winner_time_end'] as String?,
      androidDownloadLink: json['android_download_link'] as String?,
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
  writeNotNull('rule_url', instance.ruleUrl);
  writeNotNull('standing_url', instance.standingUrl);
  writeNotNull('android_download_link', instance.androidDownloadLink);
  writeNotNull('ios_download_link', instance.iosDownloadLink);
  writeNotNull('winner_lock', instance.winnerLock);
  writeNotNull('winner_time_end', instance.winnerTimeEnd);
  return val;
}
