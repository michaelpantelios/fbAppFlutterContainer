import 'package:json_annotation/json_annotation.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';
part 'gamesInfo.g.dart';

@JsonSerializable(explicitToJson: true)
class GamesInfo {
  List<GameInfo> games;
  String likeUrl;

  GamesInfo({this.games, this.likeUrl});

  factory GamesInfo.fromJson(Map<String, dynamic> json) => _$GamesInfoFromJson(json);
}