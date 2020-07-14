// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';
import 'package:fbAppFlutterContainer/gamesInfo.dart';
import 'package:fbAppFlutterContainer/gameFrame.dart';
import 'package:fbAppFlutterContainer/gamePromos.dart';
import 'package:fbAppFlutterContainer/utils.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  final gamePromoWidth = 160.0;
  final gamePromoHeight = 65.0;
  final String localhostUrl = "http://localhost:49948/";

  ScrollController _controller;

  String _initialActiveGameId;

  GameInfo _activeGame;
  List<GameInfo> _gamesList;
  String _activeGameId;
  String _iframeSrc;

  String _legalTermsUrl;
  String _privacyTermsUrl;

  @override
  void initState() {
    super.initState();

    final Map<String, String> params = Uri.parse(html.window.location.href).queryParameters;
    print(params["param1"]);
    _initialActiveGameId = params["param1"] == null ? "" : params["param1"];

    _controller = ScrollController();

    fetchGamesInfo().then((res)=> {
        setState(() {
          if (res)
            _contentReady = true;
        })
      });
    }

  Future<bool> fetchGamesInfo() async {
    final response = await http.get(localhostUrl + "static/gamesInfo.json");

    if (response.statusCode == 200) {
      GamesInfo gamesInfo =  GamesInfo.fromJson(json.decode(response.body));
      _gamesList = gamesInfo.games;

      _activeGameId = _initialActiveGameId == "" ? gamesInfo.activeGameId : _initialActiveGameId;

      _iframeSrc = localhostUrl + "static/"+_activeGameId+".html";

      List<GameInfo> res = _gamesList.where((element) => element.gameid == _activeGameId).toList();
      if (res.length > 0)
       _activeGame = res[0];

      _legalTermsUrl = gamesInfo.legalTermsUrl;
      _privacyTermsUrl = gamesInfo.privacyTermsUrl;

      return true;
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
          child: Image.network(localhostUrl +"static/"+ _activeGame.bgImage),
        ));
  }

  Widget getBottomLinksContainer() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 30, maxHeight: 50, minWidth: 400, maxWidth: 800),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
//        width: screenWidth * 0.4,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(margin:
                EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 10,
                    right: 10),
                    child: Image.network(localhostUrl+"static/"+_activeGame.publisherLogo)
                ),
                Container(
                    width: 190,
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: FlatButton(
                        color: Color(0x55000000),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Utils.launchInBrowser(_legalTermsUrl);
                        },
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(color: Color(0xffffffff), fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ))),
                Container(
                    width: 150,
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: FlatButton(
                        color: Color(0x55000000),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Utils.launchInBrowser(_privacyTermsUrl);
                        },
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Color(0xffffffff), fontSize: 15),
                          textAlign: TextAlign.center,
                        )))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    if (!_contentReady)
      return Scaffold(
        body: Center(
          child: Text("Please wait...", style: TextStyle(fontSize: 30, color: Colors.orange[600]))
        )
      );
    else
    return Scaffold(
        body:
        Stack(
          fit: StackFit.expand,
          children: [
            getResizedBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GamePromos(localhostUrl: localhostUrl, gamesList: _gamesList),
                GameFrame(frameSrc: _iframeSrc, orientation: _activeGame.orientation ),
                getBottomLinksContainer()],
            )
          ],
        )

    );
  }


}
