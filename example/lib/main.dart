import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'test_table.dart';
import 'main.reflectable.dart';

void main() {
  initializeReflectable();
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
        "4C50E3CB-D44F-2019-FF4D-ECE3F1E06B00",
        "FD99AED3-300E-8BAC-FF42-6DCBE4084F00",
        "2809016A-662D-7133-FFC0-08EC52CA6800");
  }

  void buttonPressed() {
    // save the object to the database
    Backendless.data
        .of("TestTable")
        .save({"foo": "bar"}).then((onValue) => showResult(onValue));

    // add real-time listener to "TestTable" table
    EventHandler<TestTable> eventHandler = Backendless.data.ofClass<TestTable>().rt();
    eventHandler.addCreateListener((testTable) => print("CLASS RESULT: $testTable"), onError: (error) => print("CLASS ERROR: $error"));

    EventHandler<Map> mapEventHandler = Backendless.data.of("TestTable").rt();
    mapEventHandler.addCreateListener((testTable) => print("MAP RESULT: $testTable"), onError: (error) => print("MAP ERROR: $error"));
  }

  void showResult(dynamic result) {
    setState(() => _result = result.toString());
    print(result.toString());
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
