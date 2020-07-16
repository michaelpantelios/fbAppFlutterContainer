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
    likeUrl: json['likeUrl'] as String,
  );
}

Map<String, dynamic> _$GamesInfoToJson(GamesInfo instance) => <String, dynamic>{
      'games': instance.games?.map((e) => e?.toJson())?.toList(),
      'likeUrl': instance.likeUrl,
    };
