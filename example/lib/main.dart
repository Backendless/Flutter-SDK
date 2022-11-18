import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String APP_ID = '756C19D2-DF82-9D99-FF9C-9BFD2F85DC00';
  static const String ANDROID_KEY = 'D3514DD9-C127-4BDA-BA06-AF0DF15EBEFB';
  static const String IOS_KEY = 'A4470C03-FC06-4009-BD47-9077033BF7F6';
  static const String JS_KEY = 'YOUR_JS_KEY';

  @override
  void initState() {
    super.initState();
    Backendless.initApp(
        applicationId: APP_ID,
        androidApiKey: ANDROID_KEY,
        iosApiKey: IOS_KEY,
        jsApiKey: JS_KEY);
  }

  void buttonPressed() async {
    // create a Map object. This will become a record in a database table
    Map testObject = new Map();

    // add a property to the object.
    // The property name ("foo") will become a column in the database table
    // The property value ("bar") will be stored as a value for the stored record
    testObject["foo"] = "bar";

    // Save the object in the database. The name of the database table is "TestTable".

    Backendless.data.of("TestTable").save(testObject).then((response) =>
        print("Object is saved in Backendless. Please check in the console."));

    var data = await Backendless.data.of('TestTable').find();
    print(data);
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
            ElevatedButton(child: Text("Press"), onPressed: buttonPressed)
          ],
        )),
      ),
    );
  }
}
