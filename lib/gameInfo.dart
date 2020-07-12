class GameInfo {
  final String gameName;
  final String gameOrientation;
  final String gameUrl;
  final String gameBg;
  var gamePromos;

  GameInfo({this.gameName, this.gameOrientation, this.gameUrl, this.gamePromos, this.gameBg});

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      gameName: json['gameName'],
      gameOrientation: json['gameOrientation'],
      gameUrl: json['gameUrl'],
      gameBg: json['gameBg'],
      gamePromos: json['gamePromos']
    );
  }
}
