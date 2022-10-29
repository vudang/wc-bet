import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class User {
  User({
    this.userId,
    this.amount,
    this.availableAmount,
    this.displayName, 
    this.email,
    this.photoUrl
  });

  @JsonKey(name: "localId")
  final String? userId;

  @JsonKey(name: "amount")
  final int? amount;

  @JsonKey(name: "availableAmount")
  final int? availableAmount;

  @JsonKey(name: "displayName")
  final String? displayName;

  @JsonKey(name: "email")
  final String? email;
  
  @JsonKey(name: "photoUrl")
  final String? photoUrl;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}