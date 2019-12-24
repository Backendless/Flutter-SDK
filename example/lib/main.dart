import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Result';

  @override
  void initState() {
    super.initState();

    Backendless.initApp(
        "APPLICATION-ID",
        "ANDROID-API-KEY",
        "IOS-API-KEY");
  }

  void buttonPressed() {
    final pointWKT = "POINT (30 10)";
    final lineWKT = "LINESTRING (30 10, 10 30, 40 40)";
    final polygonWKT = "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))";

    final point = Geometry.fromWKT(pointWKT);
    print("Point: $point");

    // final lineString = Geometry.fromWKT(lineWKT);
    // print("LineString: $lineString");

    // final polygon = Geometry.fromWKT(polygonWKT);


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_result'),
            RaisedButton(child: Text("Press"), onPressed: buttonPressed)
          ],
        )),
      ),
    );
  }
}
