import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  String toString() =>
      "'Test' custom class:\n\tpoint: $point\n\tlineString: $lineString\n\tpolygon: $polygon";
}

void main() {
  initializeReflectable();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

@reflector
class Order {
  String orderStatus;
  DateTime deliveryDate;
  String objectId;
  double d;
}

@reflector
class Person {
  String name;
  int age;
  String objectId;
}

@reflector
class TestTable {
  String foo;
  String objectId;
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Backendless.initApp(
      "0B83DD7F-A769-898E-FF28-6EC3B93C4200",
      "D7186AEB-32A8-9C08-FF41-4F4A87A98200",
      null);
  }
  
  void buttonPressed() async {
    var uow = UnitOfWork();
    uow.create({"foo": "bar"}, "TestTable");
    uow.execute().then((uowResult) => print(uowResult));
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
            RaisedButton(child: Text("Press"), onPressed: buttonPressed),

            RaisedButton(child: Text("Test"), onPressed: (){})
          ],
        )),
      ),
    );
  }
}
