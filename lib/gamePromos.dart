import 'package:flutter/material.dart';
import 'package:fbAppFlutterContainer/utils.dart';
import  'package:fbAppFlutterContainer/gameInfo.dart';

class GamePromos extends StatefulWidget {
  GamePromos({Key key, this.gamesList, this.localhostUrl}) : super(key:key);

  List<GameInfo> gamesList;
  String localhostUrl;

  @override
  GamePromosState createState() => GamePromosState();
}

class GamePromosState extends State<GamePromos> {
  final gamePromoWidth = 160.0;
  final gamePromoHeight = 65.0;
  ScrollController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                child:  Image.network(widget.localhostUrl+"static/"+widget.gamesList[index].promoIcon),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Utils.launchInBrowser(widget.localhostUrl+"?param1="+widget.gamesList[index].gameid);
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
                    itemCount: widget.gamesList.length,
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