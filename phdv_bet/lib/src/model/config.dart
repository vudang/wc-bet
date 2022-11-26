import 'package:json_annotation/json_annotation.dart';
import 'package:web_dashboard/src/model/team.dart';
part 'config.g.dart';

@JsonSerializable(includeIfNull: false)
class Config {
  Config(
      {this.homeBannerUrl,
      this.stadiumUrl,
      this.helpUrl,
      this.ruleUrl,
      this.standingUrl,
      this.iosDownloadLink,
      this.winnerLock,
      this.winnerTimeEnd,
      this.androidDownloadLink});

  @JsonKey(name: "home_banner_url")
  final String? homeBannerUrl;

  @JsonKey(name: "stadium_url")
  final String? stadiumUrl;

  @JsonKey(name: "help_url")
  final String? helpUrl;

  @JsonKey(name: "rule_url")
  final String? ruleUrl;

  @JsonKey(name: "standing_url")
  final String? standingUrl;

  @JsonKey(name: "android_download_link")
  final String? androidDownloadLink;

  @JsonKey(name: "ios_download_link")
  final String? iosDownloadLink;

  @JsonKey(name: "winner_lock")
  final bool? winnerLock;

  @JsonKey(name: "winner_time_end")
  final String? winnerTimeEnd;
  

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
