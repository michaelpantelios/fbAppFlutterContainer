// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';
import 'package:fbAppFlutterContainer/gameFrame.dart';
import 'package:fbAppFlutterContainer/gamePromos.dart';
import 'package:fbAppFlutterContainer/footer.dart';
import 'package:fbAppFlutterContainer/gamesInfo.dart';

main() {
  runApp(FbAppContainer());
}

class FbAppContainer extends StatelessWidget {
  // This widget is the root of your application.

  static getAssetUrl(String path) {
    String _path;
    if (Uri.parse(html.window.location.href).toString().contains("localhost"))
      _path = "https://local.lazyland.biz:8070" + path;
    else
      _path = path;
    return _path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LazyLand FB App Flutter Container',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _contentReady = false;

  String _gameId;

  GameInfo _activeGame;
  List<GameInfo> _gamesList;
  String _fbLikeCode;

  @override
  void initState() {
    super.initState();

    final Map<String, String> params = Uri.parse(html.window.location.href).queryParameters;
    _gameId = params["gameid"];
    if (_gameId == "" || _gameId == null) _gameId = "wordfight";

    fetchGamesInfo().then((res) => {
          setState(() {
            if (res) _contentReady = true;
          })
        });
  }

  Future<bool> fetchGamesInfo() async {
    final response =
        await http.get(FbAppContainer.getAssetUrl("/fbapps/promoconfig/"));

    if (response.statusCode == 200) {
      GamesInfo gamesInfo = GamesInfo.fromJson(json.decode(response.body));
      _gamesList = gamesInfo.games.toList();

      if (_gameId != null) {
        List<GameInfo> res = _gamesList.where((element) => element.gameid == _gameId).toList();
        if (res.length > 0) {
          _activeGame = res[0];

          _fbLikeCode = gamesInfo.likeUrl;

          return true;
        }
      }
    } else {
      throw Exception('Failed to load gameInfo');
    }
    return false;
  }

  Widget getResizedBackground() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double screenRatio = screenWidth / screenHeight;

    double bgRatio = 1.83333333333;

    double bgHeight;
    double bgWidth;

    if (screenRatio >= bgRatio) {
      bgWidth = screenWidth;
      bgHeight = bgWidth / bgRatio;
    } else if (screenRatio < bgRatio && screenRatio >= 1) {
      bgHeight = screenHeight;
      bgWidth = bgHeight * bgRatio;
    } else if (screenRatio < 1) {
      bgHeight = screenHeight;
      bgWidth = bgHeight * bgRatio;
    }

    return Container(
        width: bgWidth,
        height: bgHeight,
        child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: Image.network(FbAppContainer.getAssetUrl(_activeGame.bgImage)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_contentReady)
      return Container();
    else {
//      js.context.callMethod('alertMessage', ['Flutter is calling upon JavaScript!']);
      print("must bring scaffold");
      return Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          getResizedBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GamePromos(gamesList: _gamesList),
              GameFrame(gameInfo: _activeGame),
              Footer(gameInfo: _activeGame, fbLikeCode: _fbLikeCode,)
            ],
          )
        ],
      ));
    }
  }
}
