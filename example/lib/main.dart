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
  static const String APP_ID = 'YOUR_APP_ID';
  static const String ANDROID_KEY = 'YOUR_ANDROID_KEY';
  static const String IOS_KEY = 'YOUR_IOS_KEY';
  static const String JS_KEY = 'YOUR_JS_KEY';

  @override
  void initState() {
    super.initState();
    Backendless.setUrl('https://api.backendless.com');
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
