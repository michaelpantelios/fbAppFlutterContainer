// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';

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
  ScrollController _controller;
  int scrollCardDimension;
  String _gameOrientation;
  final IFrameElement _iframeElement = IFrameElement();
  Widget _iframeWidget;
  Future<GameInfo> _gameInfo;
  final gamePromoWidth = 160.0;
  final gamePromoHeight = 65.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _gameInfo = fetchGameInfo();

//    _iframeElement.src = "https://localhost:8080//?sessionKey=0c9fd75c3f407ee5259ec8f98b13e64383a21df8e47d5844dbfbe4e1b02ede52";

   // _iframeElement.src = "http://localhost:33243/static/test.html";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(key: UniqueKey(), viewType: 'iframeElement');
  }

  Future<GameInfo> fetchGameInfo() async {
    final response = await http.get("http://localhost:33243/static/gameInfo.json");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GameInfo.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load gameInfo');
    }
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

  Widget getGamePromoItem(BuildContext context, int index) {
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
              child: widget._gamePromos[index]),
        ));
  }

  _gamePromosScrollRight() {
    _controller.animateTo(_controller.offset - gamePromoWidth, curve: Curves.linear, duration: Duration(milliseconds: 250));
  }

  _gamePromosScrollLeft() {
    _controller.animateTo(_controller.offset + gamePromoWidth, curve: Curves.linear, duration: Duration(milliseconds: 250));
  }

  Widget getResizedBackground(String bgUrl) {
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
    return Container(
        width: bgWidth,
        height: bgHeight,
        child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: Image.network(bgUrl),
        ));
  }

  Size calculateIframeSize() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //considering game is 1920x1080
    double portraitGameRatio = 1080 / 1920;
    double landscapeGameRatio = 1.777;

    double iframeHeight;
    double iframeWidth;

    if (_gameOrientation == "portrait") {
      iframeHeight = screenHeight - 150;
      iframeWidth = iframeHeight * portraitGameRatio;
    } else {
      iframeHeight = screenHeight - 150;
      iframeWidth = iframeHeight * landscapeGameRatio;
    }

    return new Size(iframeWidth, iframeHeight);
  }

  getIframeContainer(String iframeSrc, String gameOrientation) {
    _gameOrientation = gameOrientation;
    _iframeElement.src = iframeSrc;
    return Center(
      child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.red,
            boxShadow: [
              new BoxShadow(color: Color(0xaa000000), offset: new Offset(0.0, 0.0), blurRadius: 5, spreadRadius: 2),
            ],
          ),
          height: calculateIframeSize().height,
          width: calculateIframeSize().width,
          child: _iframeWidget),
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
                Container(margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10), child: Image.asset("images/ll_logo.png")),
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
                          _launchInBrowser("http://www.google.gr");
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
                          _launchInBrowser("http://www.google.gr");
                        },
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Color(0xffffffff), fontSize: 15),
                          textAlign: TextAlign.center,
                        )))
              ],
            )));
  }

  getGamePromos(var gamePromos) {
    final double screenWidth = MediaQuery.of(context).size.width;
    for (int i=0; i<gamePromos.length; i++){
     widget._gamePromos.add( new Image.network(gamePromos[i]));
    }

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
                    itemCount: widget._gamePromos.length,
                    scrollDirection: Axis.horizontal,
                    itemExtent: gamePromoWidth,
                    itemBuilder: getGamePromoItem)),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        FutureBuilder<GameInfo>(
          future: _gameInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("->"+snapshot.data.gameName);
              return Stack(
                fit: StackFit.expand,
                children: [
                  getResizedBackground(snapshot.data.gameBg),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getGamePromos(snapshot.data.gamePromos),
                      getIframeContainer(snapshot.data.gameUrl, snapshot.data.gameOrientation),
                      getBottomLinksContainer()],
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        )

    );
  }


}
