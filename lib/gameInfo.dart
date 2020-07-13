import 'package:json_annotation/json_annotation.dart';
part 'gameInfo.g.dart';

@JsonSerializable()
class GameInfo {
  final String gameid;
  final String orientation;
  final String bgImage;
  final String promoIcon;
  final String publisherLogo;

  GameInfo({this.gameid, this.orientation, this.bgImage, this.promoIcon, this.publisherLogo});

  factory GameInfo.fromJson(Map<String, dynamic> json) => _$GameInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameInfoToJson(this);
}
