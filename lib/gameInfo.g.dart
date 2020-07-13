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
    promoIcon: json['promoIcon'] as String,
    publisherLogo: json['publisherLogo'] as String,
  );
}

Map<String, dynamic> _$GameInfoToJson(GameInfo instance) => <String, dynamic>{
      'gameid': instance.gameid,
      'orientation': instance.orientation,
      'bgImage': instance.bgImage,
      'promoIcon': instance.promoIcon,
      'publisherLogo': instance.publisherLogo,
    };
