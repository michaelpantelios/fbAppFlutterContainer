import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fbAppFlutterContainer/utils.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:fbAppFlutterContainer/gameInfo.dart';
import 'package:fbAppFlutterContainer/main.dart';

class Footer extends StatefulWidget {
  Footer({Key key, this.gameInfo, this.fbLikeCode}) : super(key: key);

  final GameInfo gameInfo;
  final String fbLikeCode;

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final html.IFrameElement _socialFrameElement = html.IFrameElement();
  Widget _socialFrameWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ui.platformViewRegistry.registerViewFactory(
        'socialIframeElement', (int viewId) => _socialFrameElement);
    _socialFrameWidget =
        HtmlElementView(key: UniqueKey(), viewType: 'socialIframeElement');

    _socialFrameElement.src = widget.fbLikeCode;
    _socialFrameElement.style.border = "none";
    _socialFrameElement.style.padding = "0";
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 50, maxHeight: 65, minWidth: 400, maxWidth: 800),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: Image.network(FbAppContainer.getAssetUrl(
                        widget.gameInfo.publisherLogo))),
                Container(
                    width: 190,
                    height: 65,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: FlatButton(
                        color: Color(0x55000000),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Utils.launchInBrowser(widget.gameInfo.terms);
                        },
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                              color: Color(0xffffffff), fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ))),
                Container(
                    width: 150,
                    height: 65,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: FlatButton(
                        color: Color(0x55000000),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Utils.launchInBrowser(widget.gameInfo.policy);
                        },
                        child: Text(
                          "Privacy Policy",
                          style:
                              TextStyle(color: Color(0xffffffff), fontSize: 15),
                          textAlign: TextAlign.center,
                        ))),
                Center(
                    child: Container(
                        margin: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        width: 250,
                        height: 25,
                        child: _socialFrameWidget))
              ],
            )));
  }
}
