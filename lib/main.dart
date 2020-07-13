// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';
import 'package:fbAppFlutterContainer/gamesInfo.dart';

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

  final List<Widget> _gamePromos = [];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _contentReady = false;
  final gamePromoWidth = 160.0;
  final gamePromoHeight = 65.0;
  final String localhostUrl = "http://localhost:63124/";

  ScrollController _controller;
  final IFrameElement _iframeElement = IFrameElement();
  Widget _iframeWidget;

  GameInfo _activeGame;
  List<GameInfo> _gamesList;

  String _legalTermsUrl;
  String _privacyTermsUrl;

  @override
  void initState() {
    super.initState();
    print("initState");
    _controller = ScrollController();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(key: UniqueKey(), viewType: 'iframeElement');

  fetchGamesInfo().then((res)=> {

      setState(() {
        if (res)
          _contentReady = true;
      })
    });
  }

  Future<bool> fetchGamesInfo() async {
    print("fetchGamesInfo : "+localhostUrl + "static/gamesInfo.json");
    final response = await http.get(localhostUrl + "static/gamesInfo.json");

    if (response.statusCode == 200) {
      print("statusCode ="+response.statusCode.toString());
      // If the server did return a 200 OK response,
      // then parse the JSON.
      GamesInfo gamesInfo =  GamesInfo.fromJson(json.decode(response.body));
      print("gamesInfo.activeGameId = "+gamesInfo.activeGameId);
      _gamesList = gamesInfo.games;

      String activeGameId = gamesInfo.activeGameId;

      List<GameInfo> res = _gamesList.where((element) => element.gameid == activeGameId).toList();
      if (res.length > 0)
       _activeGame = res[0];

      print("activeGameId = "+_activeGame.bgImage);

      _legalTermsUrl = gamesInfo.legalTermsUrl;
      _privacyTermsUrl = gamesInfo.privacyTermsUrl;

      return true;
    } else {
      print("statusCode ="+response.statusCode.toString());
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load gameInfo');
    }
    return false;
  }


  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }


  Widget getResizedBackground() {
    print("getResizedBackground");
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double screenRatio = screenWidth / screenHeight;
    //    print("screenRatio ="+screenRatio.toString());

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

    print("bg: "+_activeGame.bgImage);

    return Container(
        width: bgWidth,
        height: bgHeight,
        child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: Image.network(localhostUrl +"static/"+ _activeGame.bgImage),
        ));
  }


  Widget GamePromoItem(BuildContext context, int index) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Container(
              width: gamePromoWidth,
              height: gamePromoHeight,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  new BoxShadow(color: Color(0x55000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child:
              FlatButton(
                child:  Image.network(localhostUrl+"static/"+_gamesList[index].promoIcon),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _launchInBrowser(localhostUrl+"static/"+_gamesList[index].gameid+".html");
                },
              )
          ),
        ));
  }

  getGamePromos() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: screenWidth,
            height: 80,
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.fill,
              child: Image.asset("images/gamePromosBg.png"),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              iconSize: 65,
              color: Colors.white,
              onPressed: () {
                print("go left");
                _gamePromosScrollRight();
              },
            ),
            ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: gamePromoWidth, maxWidth: screenWidth * 0.5, minHeight: 20, maxHeight: gamePromoHeight + 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: _gamesList.length,
                    scrollDirection: Axis.horizontal,
                    itemExtent: gamePromoWidth,
                    itemBuilder: GamePromoItem)),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              iconSize: 65,
              color: Colors.white,
              onPressed: () {
                print("go right");
                _gamePromosScrollLeft();
              },
            ),
          ],
        )
      ],
    );
  }

  _gamePromosScrollRight() {
    _controller.animateTo(_controller.offset - gamePromoWidth, curve: Curves.linear, duration: Duration(milliseconds: 250));
  }

  _gamePromosScrollLeft() {
    _controller.animateTo(_controller.offset + gamePromoWidth, curve: Curves.linear, duration: Duration(milliseconds: 250));
  }

  Size calculateIframeSize() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //considering game is 1920x1080
    double portraitGameRatio = 1080 / 1920;
    double landscapeGameRatio = 1.777;

    double iframeHeight;
    double iframeWidth;

    if (_activeGame.orientation == "portrait") {
      iframeHeight = screenHeight - 150;
      iframeWidth = iframeHeight * portraitGameRatio;
    } else {
      iframeHeight = screenHeight - 150;
      iframeWidth = iframeHeight * landscapeGameRatio;
    }

    return new Size(iframeWidth, iframeHeight);
  }

  getIframeContainer() {
    _iframeElement.src = localhostUrl+"static/"+_activeGame.gameid+".html";
    return Center(
      child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            boxShadow: [
              new BoxShadow(color: Color(0xaa000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2),
            ],
          ),
          height: calculateIframeSize().height,
          width: calculateIframeSize().width,
          child: _iframeWidget
      ),
    );
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
                          print("Terms & Conditions");
                          _launchInBrowser(_legalTermsUrl);
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
                          print("Privacy Policy");
                          _launchInBrowser(_privacyTermsUrl);
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
                getGamePromos(),
                getIframeContainer(),
                getBottomLinksContainer()],
            )
          ],
        )

    );
  }


}
