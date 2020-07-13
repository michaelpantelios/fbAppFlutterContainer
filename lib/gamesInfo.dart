import 'package:json_annotation/json_annotation.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';
part 'gamesInfo.g.dart';

@JsonSerializable(explicitToJson: true)
class GamesInfo {
  List<GameInfo> games;
  String activeGameId;
  String legalTermsUrl;
  String privacyTermsUrl;

  GamesInfo({this.games, this.activeGameId, this.legalTermsUrl, this.privacyTermsUrl});

  factory GamesInfo.fromJson(Map<String, dynamic> json) => _$GamesInfoFromJson(json);
}