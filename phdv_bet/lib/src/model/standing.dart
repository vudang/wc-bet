import 'package:json_annotation/json_annotation.dart';
import 'package:web_dashboard/src/model/team.dart';
part 'standing.g.dart';

@JsonSerializable(includeIfNull: false)
class Standing {
  Standing({
    this.id,
    this.group,
    this.teams,
  });

  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "group")
  final String? group;

  @JsonKey(name: "teams")
  final List<Team>? teams;


  factory Standing.fromJson(Map<String, dynamic> json) => _$StandingFromJson(json);
  Map<String, dynamic> toJson() => _$StandingToJson(this);

}