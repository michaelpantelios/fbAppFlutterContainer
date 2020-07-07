import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';



main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Size findBgSize(){
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double screenRatio = screenWidth / screenHeight;
//    print("screenRatio ="+screenRatio.toString());

    double bgRatio = 1.83333333333;

    double bgHeight;
    double bgWidth;

    if (screenRatio >= bgRatio){
      bgWidth = screenWidth;
      bgHeight = bgWidth / bgRatio;
    } else if (screenRatio < bgRatio && screenRatio >= 1){
      bgHeight = screenHeight;
      bgWidth = bgHeight * bgRatio;
    } else if (screenRatio < 1){
      bgHeight = screenHeight;
      bgWidth = bgHeight * bgRatio;
    }

    return new Size(bgWidth, bgHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:      Stack(
        children: [
          Container(
            width: findBgSize().width,
            height: findBgSize().height,
          child:  FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.cover,
            child: Image.asset("images/bg.png"),
          )
          )
        ],
      )
    );
  }
}
