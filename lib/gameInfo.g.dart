// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameInfo _$GameInfoFromJson(Map<String, dynamic> json) {
  return GameInfo(
    gameid: json['gameid'] as String,
    orientation: json['orientation'] as String,
    bgImage: json['bgImage'] as String,
    icon: json['icon'] as String,
    publisherLogo: json['publisherLogo'] as String,
    gameUrl: json['gameUrl'] as String,
    terms: json['terms'] as String,
    policy: json['policy'] as String,
    fbNamespace: json['fbNamespace'] as String,
  );
}

Map<String, dynamic> _$GameInfoToJson(GameInfo instance) => <String, dynamic>{
      'gameid': instance.gameid,
      'bgImage': instance.bgImage,
      'orientation': instance.orientation,
      'icon': instance.icon,
      'gameUrl': instance.gameUrl,
      'fbNamespace': instance.fbNamespace,
      'publisherLogo': instance.publisherLogo,
      'terms': instance.terms,
      'policy': instance.policy,
    };
