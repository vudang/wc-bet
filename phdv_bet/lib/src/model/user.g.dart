// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['localId'] as String?,
      amount: json['amount'] as int?,
      availableAmount: json['availableAmount'] as int?,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('localId', instance.userId);
  writeNotNull('amount', instance.amount);
  writeNotNull('availableAmount', instance.availableAmount);
  writeNotNull('displayName', instance.displayName);
  writeNotNull('email', instance.email);
  writeNotNull('photoUrl', instance.photoUrl);
  writeNotNull('active', instance.active);
  return val;
}
