import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:fbAppFlutterContainer/gameInfo.dart';

class GameFrame extends StatefulWidget {
  GameFrame({Key key, this.gameInfo}) : super(key : key);

  final GameInfo gameInfo;

  @override
  _GameFrameState createState() => _GameFrameState();
}

class _GameFrameState extends State<GameFrame> {
  final html.IFrameElement _gameFrameElement = html.IFrameElement();
  Widget _gameFrameWidget;

  @override
  void initState() {
    super.initState();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory( 'gameIframeElement', (int viewId) => _gameFrameElement);
    _gameFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'gameIframeElement');


    _gameFrameElement.src = widget.gameInfo.gameUrl;
    _gameFrameElement.style.border = "none";
    _gameFrameElement.style.padding = "0";
  }

  @override
  Widget build(BuildContext context) {

    Size calculateIframeSize() {
      final double screenWidth = MediaQuery.of(context).size.width;
      final double screenHeight = MediaQuery.of(context).size.height;

      //considering game is 1920x1080
      double portraitGameRatio = 1080 / 1920;
      double landscapeGameRatio = 1.777;

      double iframeHeight;
      double iframeWidth;

      if (widget.gameInfo.orientation == "portrait") {
        iframeHeight = screenHeight - 180;
        iframeWidth = iframeHeight * portraitGameRatio;
      } else {
        iframeHeight = screenHeight - 180;
        iframeWidth = iframeHeight * landscapeGameRatio;
        if (iframeWidth > screenWidth){
          iframeWidth = screenWidth - 20;
          iframeHeight = iframeWidth / landscapeGameRatio;
        }
      }

      return new Size(iframeWidth, iframeHeight);
    }

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
          child: _gameFrameWidget
      ),
    );
  }
}