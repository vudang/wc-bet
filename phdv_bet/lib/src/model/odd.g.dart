// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odd.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Odd _$OddFromJson(Map<String, dynamic> json) => Odd(
      amount: json['amount'] as int?,
      fullMatch: json['fullMatch'] == null
          ? null
          : FullMatch.fromJson(json['fullMatch'] as Map<String, dynamic>),
      matchId: json['matchId'] as int?,
      teamAway: json['teamAway'] as String?,
      teamHome: json['teamHome'] as String?,
      isLock: json['lock'] as bool?,
      date: json['date'] as String?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$OddToJson(Odd instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('amount', instance.amount);
  writeNotNull('fullMatch', instance.fullMatch);
  writeNotNull('matchId', instance.matchId);
  writeNotNull('teamAway', instance.teamAway);
  writeNotNull('teamHome', instance.teamHome);
  writeNotNull('lock', instance.isLock);
  writeNotNull('date', instance.date);
  writeNotNull('time', instance.time);
  return val;
}

FullMatch _$FullMatchFromJson(Map<String, dynamic> json) => FullMatch(
      asianHandicap: (json['asianHandicap'] as List<dynamic>?)
          ?.map((e) => AsianHandicap.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FullMatchToJson(FullMatch instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('asianHandicap', instance.asianHandicap);
  return val;
}

AsianHandicap _$AsianHandicapFromJson(Map<String, dynamic> json) =>
    AsianHandicap(
      away: json['away'] as String?,
      home: json['home'] as String?,
      label: json['label'] as String?,
      prefix: json['prefix'] as String?,
    );

Map<String, dynamic> _$AsianHandicapToJson(AsianHandicap instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('away', instance.away);
  writeNotNull('home', instance.home);
  writeNotNull('label', instance.label);
  writeNotNull('prefix', instance.prefix);
  return val;
}
