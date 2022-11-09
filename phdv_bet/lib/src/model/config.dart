import 'package:json_annotation/json_annotation.dart';
import 'package:web_dashboard/src/model/team.dart';
part 'config.g.dart';

@JsonSerializable(includeIfNull: false)
class Config {
  Config({
    this.homeBannerUrl,
    this.stadiumUrl,
    this.helpUrl
  });

  @JsonKey(name: "home_banner_url")
  final String? homeBannerUrl;

  @JsonKey(name: "stadium_url")
  final String? stadiumUrl;

  @JsonKey(name: "help_url")
  final String? helpUrl;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);

}