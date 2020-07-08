import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fbAppFlutterContainer/gamePromosScrollPhysics.dart';
import 'dart:math';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ScrollController();
  ScrollPhysics _physics;
  int scrollCardDimension;


  Widget getGamePromoItem(BuildContext context, int index){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: widget._gamePromos[index]
    );
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.haveDimensions && _physics == null) {
        setState(() {
          var dimension = _controller.position.maxScrollExtent / widget._gamePromos.length - 1;

//          double dimension = 165.0;

          print(" _controller.position.maxScrollExtent = "+ _controller.position.maxScrollExtent.toString());
          scrollCardDimension = dimension.round();
          print("scrollCardDimension = " + scrollCardDimension.toString());
          _physics = GamePromosScrollPhysics(itemDimension: dimension);
        });
      }
    });
  }


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

  getGamePromosNum(){
    final double screenWidth = MediaQuery.of(context).size.width;
    int num = min((screenWidth * 0.5 / 165).round(), 5);
    print("num = "+num.toString());
    return num;
  }

  Widget getGamePromosContainer() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: screenWidth,
            height: 100,
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.fill,
              child: Image.asset("images/gamePromosBg.png"),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 15,
                  bottom: 5,
                  left: screenWidth * 0.2,
                  right: screenWidth * 0.2),
              child: Text(
                "Περισσότερα Παιχνίδια",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: screenWidth,
                  minHeight:20,
                  maxHeight:65
              ),
//              child: Padding(
//                padding: EdgeInsets.only(
//                    top: 5,
//                    bottom: 5,
//                    left: screenWidth * 0.2,
//                    right: screenWidth * 0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [//
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left),
                        iconSize: 65,
                        color: Colors.white,
                        onPressed: () {
                          print("go left");
                          _controller.animateTo(offset, duration: null, curve: null);
                          print("position: "+_controller.position.toString());
                        },
                      ),
                      ListView.builder(
                             shrinkWrap: true,
                             controller: _controller,
//                             physics: _physics,
                             padding: EdgeInsets.symmetric(horizontal: 10),
                             itemCount: getGamePromosNum(),
                             scrollDirection: Axis.horizontal,
                             itemBuilder: getGamePromoItem
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        iconSize: 65,
                        color: Colors.white,
                        onPressed: () {
                          print("go right");
                          _controller.animateTo(offset, duration: null, curve: null);
//                          print("controller: "+_controller.offset.toString());
                          print("position: "+_controller.position.toString());

                        },
                      ),
                    ],
                  )
//              )
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [getResizedBackground(), getGamePromosContainer()],
    ));
  }
}
