import 'package:flutter/material.dart';
import 'package:fbAppFlutterContainer/utils.dart';
import  'package:fbAppFlutterContainer/gameInfo.dart';
import 'package:fbAppFlutterContainer/main.dart';

class GamePromos extends StatefulWidget {
  List<GameInfo> gamesList;

  GamePromos({Key key, this.gamesList}) : super(key:key);

  static final String fbLinkPrefix = "https://apps.facebook.com/";

  @override
  GamePromosState createState() => GamePromosState();
}

class GamePromosState extends State<GamePromos> {
  final gamePromoWidth = 154.0;
  final gamePromoHeight = 64.0;
  ScrollController _controller;
  List<GameInfo> _gamesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gamesList = widget.gamesList;
    print("GamePromos: "+_gamesList.length.toString());
    _controller = ScrollController();
  }

  _gamePromosScrollRight() {
    _controller.animateTo(_controller.offset - gamePromoWidth, curve: Curves.linear, duration: Duration(milliseconds: 250));
  }

  _gamePromosScrollLeft() {
    _controller.animateTo(_controller.offset + gamePromoWidth, curve: Curves.linear, duration: Duration(milliseconds: 250));
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
                child:  Image.network(FbAppContainer.getAssetUrl(_gamesList[index].icon)),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Utils.launchInBrowser(GamePromos.fbLinkPrefix+_gamesList[index].fbNamespace);
                },
              )
          ),
        ));
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
                _gamePromosScrollLeft();
              },
            ),
          ],
        )
      ],
    );
  }
}