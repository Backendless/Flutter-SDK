import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'main.reflectable.dart';

@reflector
class ChildTest {
  String objectId;
  String ownerId;
  DateTime created;
  DateTime updated;
  String first;
  String second;
  DateTime third;
  int fourth;
  double fifth;
  bool sixth;
}

@reflector
class ClassDrivenTest {
  String objectId;
  String ownerId;
  DateTime created;
  DateTime updated;
  String first;
  String second;
  DateTime third;
  int fourth;
  double fifth;
  bool sixth;
  List<ChildTest> seventh;
}

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
        "A193657F-3E2D-4ADD-A450-5532F0BF09EC",
        "8A61E955-D8D6-CBF3-FFF8-FE53DEE02800",
        "6CBB8265-045A-C493-FF70-FD0908D51200");


    
    var rt = Backendless.data.of("Test").rt();
    rt.addCreateListener((callback) => print("Create event"));
    rt.addUpdateListener((callback) => print("Update event"));
    rt.addDeleteListener((callback) => print("Delete event"));
    rt.addBulkUpdateListener((callback) => print("BulkUpdate event"));
    rt.addBulkDeleteListener((callback) => print("BulkDelete event"));
  }

  void buttonPressed() async {
      final copyCount = await Backendless.files.getFileCount("test_folder/copy_folder");
      print(copyCount);

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
