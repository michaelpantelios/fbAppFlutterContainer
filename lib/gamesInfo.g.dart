// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamesInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamesInfo _$GamesInfoFromJson(Map<String, dynamic> json) {
  return GamesInfo(
    games: (json['games'] as List)
        ?.map((e) =>
            e == null ? null : GameInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    activeGameId: json['activeGameId'] as String,
    legalTermsUrl: json['legalTermsUrl'] as String,
    privacyTermsUrl: json['privacyTermsUrl'] as String,
  );
}

Map<String, dynamic> _$GamesInfoToJson(GamesInfo instance) => <String, dynamic>{
      'games': instance.games?.map((e) => e?.toJson())?.toList(),
      'activeGameId': instance.activeGameId,
      'legalTermsUrl': instance.legalTermsUrl,
      'privacyTermsUrl': instance.privacyTermsUrl,
    };
