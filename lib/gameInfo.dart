import 'package:json_annotation/json_annotation.dart';
part 'gameInfo.g.dart';

@JsonSerializable()
class GameInfo {
  final String gameid;
  final String orientation;
  final String bgImage;
  final String icon;
  final String publisherLogo;
  final String terms;
  final String policy;

  GameInfo({this.gameid, this.orientation, this.bgImage, this.icon, this.publisherLogo, this.terms, this.policy});

  factory GameInfo.fromJson(Map<String, dynamic> json) => _$GameInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameInfoToJson(this);
}
