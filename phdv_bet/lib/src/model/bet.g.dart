// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bet _$BetFromJson(Map<String, dynamic> json) => Bet(
      amount: json['amount'] as int?,
      matchId: json['matchId'] as int?,
      choosedTeam: json['choosedTeam'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$BetToJson(Bet instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('amount', instance.amount);
  writeNotNull('matchId', instance.matchId);
  writeNotNull('choosedTeam', instance.choosedTeam);
  writeNotNull('userId', instance.userId);
  return val;
}
