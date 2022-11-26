// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'winner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Winner _$WinnerFromJson(Map<String, dynamic> json) => Winner(
      amount: json['amount'] as int?,
      teamId: json['chooseTeam'] as int?,
      userId: json['userId'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WinnerToJson(Winner instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('amount', instance.amount);
  writeNotNull('chooseTeam', instance.teamId);
  writeNotNull('userId', instance.userId);
  writeNotNull('date', instance.date?.toIso8601String());
  return val;
}
