import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

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
  static const String APP_ID = "YOUR_APP_ID";
  static const String ANDROID_KEY = "YOUR_ANDROID_KEY";
  static const String IOS_KEY = "YOUR_IOS_KEY";

  @override
  void initState() {
    super.initState();
    Backendless.initApp(APP_ID, ANDROID_KEY, IOS_KEY);
  }

  void buttonPressed() {
    // create a Map object. This will become a record in a database table
    Map testObject = new Map();

    // add a property to the object.
    // The property name ("foo") will become a column in the database table
    // The property value ("bar") will be stored as a value for the stored record
    testObject["foo"] = "bar";

    // Save the object in the database. The name of the database table is "TestTable".
    Backendless.data.of("TestTable").save(testObject).then((response) =>
        print("Object is saved in Backendless. Please check in the console."));
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
            RaisedButton(child: Text("Press"), onPressed: buttonPressed)
          ],
        )),
      ),
    );
  }
}
