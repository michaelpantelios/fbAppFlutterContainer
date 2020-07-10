// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
      home: NewHomePage(),
    );
  }
}

class NewHomePage extends StatelessWidget {
  GameOrientation gameOrientation = GameOrientation.portrait;
  final IFrameElement _iframeElement = IFrameElement();
  Widget _iframeWidget;

  @override
  Widget build(BuildContext context) {
    _iframeElement.src = "https://localhost:8080//?sessionKey=0c9fd75c3f407ee5259ec8f98b13e64383a21df8e47d5844dbfbe4e1b02ede52";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(key: UniqueKey(), viewType: 'iframeElement');

    Widget getResizedBackground() {
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
            child: Image.asset("images/bg.png"),
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

      if (gameOrientation == GameOrientation.portrait) {
        iframeHeight = screenHeight - 150;
        iframeWidth = iframeHeight * portraitGameRatio;
      } else {
        iframeHeight = screenHeight - 150;
        iframeWidth = iframeHeight * landscapeGameRatio;
      }

      return new Size(iframeWidth, iframeHeight);
    }

    getIframeContainer() {
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
                            },
                          child: Text(
                            "Privacy Policy",
                            style: TextStyle(color: Color(0xffffffff), fontSize: 15),
                            textAlign: TextAlign.center,
                          )))
                ],
              )));
    }

    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            getResizedBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [GamePromos(), getIframeContainer(), getBottomLinksContainer()],
            )
          ],
        ));
  }
}

enum GameOrientation { portrait, landscape }

class GamePromos extends StatefulWidget {
  GamePromos({Key key}) : super(key: key);

  final List<Widget> _gamePromos = [
    new Image.asset('images/gamePromo1.png'),
    new Image.asset('images/gamePromo2.png'),
    new Image.asset('images/gamePromo3.png'),
    new Image.asset('images/gamePromo4.png'),
    new Image.asset('images/gamePromo5.png'),
    new Image.asset('images/gamePromo1.png'),
    new Image.asset('images/gamePromo2.png'),
    new Image.asset('images/gamePromo3.png'),
    new Image.asset('images/gamePromo4.png'),
    new Image.asset('images/gamePromo5.png')
  ];

  @override
  _GamePromosState createState() => _GamePromosState();
}

class _GamePromosState extends State<GamePromos> {
  ScrollController _controller;
  int scrollCardDimension;
  final gamePromoWidth = 160.0;
  final gamePromoHeight = 65.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
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

  @override
  Widget build(BuildContext context) {
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
}
