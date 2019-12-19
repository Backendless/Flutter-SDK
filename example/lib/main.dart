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
        "1E0573AC-46CC-7244-FFAB-A55AD3D05B00",
        "8A61E955-D8D6-CBF3-FFF8-FE53DEE02800",
        "6CBB8265-045A-C493-FF70-FD0908D51200");
  }

  void buttonPressed() async {
    final dataStore = Backendless.data.withClass<ClassDrivenTest>();

    final toSave = ClassDrivenTest()
      ..first = "aaaa"
      ..third = DateTime.now()
      ..fourth = 42;

    final listToSave = List.filled(10, toSave);

    await dataStore.create(listToSave);

    final loaded = await dataStore.find();
    print(loaded);
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
