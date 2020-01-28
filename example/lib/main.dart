import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'main.reflectable.dart';

@reflector
class Test {
  String foo;
  Point point;
  LineString lineString;
  Polygon polygon;

  @override
  String toString() => "'Test' custom class:\n\tpoint: $point\n\tlineString: $lineString\n\tpolygon: $polygon";
}

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
    initializeReflectable();

    Backendless.setUrl("https://api.backendless.com");
    Backendless.initApp(
      "APP-ID",
      "ANDROID-KEY",
      "IOS-KEY");
  }

  void buttonPressed() async {
    final dataStore = Backendless.data.withClass<Test>();

    final point = Point(x: 20, y:20);

    final point1 = Point(x: 30, y:30);
    final point2 = Point(x: 40, y:40);

    final ppoint1 = Point(x: -114.86082225, y:51.77113916);
    final ppoint2 = Point(x: -113.45457225, y:47.44655569);
    final ppoint3 = Point(x: -108.53269725, y:49.31427466);
    final ppoint4 = Point(x: -114.86082225, y:51.77113916);

    final lineString = LineString(points: [point1, point2]);
    final polygon = Polygon(boundary: LineString(points: [ppoint1, ppoint2, ppoint3, ppoint4]));

    final objectOfCustomClass = Test()
      ..point = point
      ..lineString = lineString
      ..polygon = polygon;

    dataStore.save(objectOfCustomClass).then((saved) {
      print("🟢 SAVED: $saved");
    });
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
