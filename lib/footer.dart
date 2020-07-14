import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fbAppFlutterContainer/utils.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Footer extends StatefulWidget {
  Footer({Key key, this.publisherLogoUrl, this.legalTermsUrl, this.privacyTermsUrl}) : super(key : key);

//  final String fbLikeCode;
  final String publisherLogoUrl;
  final String legalTermsUrl;
  final String privacyTermsUrl;

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

    ui.platformViewRegistry.registerViewFactory( 'socialIframeElement', (int viewId) => _socialFrameElement);
    _socialFrameWidget = HtmlElementView(key: UniqueKey(), viewType: 'socialIframeElement');
    
//    String src = widget.fbLikeCode;
    String src = "<iframe src='https://www.facebook.com/plugins/like.php?href=https://developers.facebook.com/docs/plugins/&width=250&layout=standard&action=like&size=small&share=false&height=35&appId=838745102817861' width='250' height='40' style='border:none;overflow:hidden' scrolling='no' frameborder='0' allowTransparency='true' allow='encrypted-media'></iframe>";

    _socialFrameElement.src = "data:text/html;charset=utf-8," +
        Uri.encodeComponent(src);

    _socialFrameElement.style.border = "none";
    _socialFrameElement.style.padding = "0";

  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50, maxHeight: 65, minWidth: 400, maxWidth: 800),
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
                    child: Image.network(widget.publisherLogoUrl)
                ),
                Container(
                    width: 190,
                    height: 65,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: FlatButton(
                        color: Color(0x55000000),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Utils.launchInBrowser(widget.legalTermsUrl);
                        },
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(color: Color(0xffffffff), fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ))),
                Container(
                    width: 150,
                    height: 65,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: FlatButton(
                        color: Color(0x55000000),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Utils.launchInBrowser(widget.privacyTermsUrl);
                        },
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Color(0xffffffff), fontSize: 15),
                          textAlign: TextAlign.center,
                        ))),
                Container(
                    margin:EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 10,
                        right: 10),
                    width: 260,
                    height: 65,
                    child: _socialFrameWidget
                ),
              ],
            )));
  }
}