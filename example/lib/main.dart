import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  const String APP_ID = 'APP_ID';
  const String ANDROID_KEY = 'ANDROID_API_KEY';
  const String IOS_KEY = 'IOS_API_KEY';
  const String JS_KEY = 'JS_KEY';

  WidgetsFlutterBinding.ensureInitialized();

  Backendless.initApp(
      applicationId: APP_ID,
      androidApiKey: ANDROID_KEY,
      iosApiKey: IOS_KEY,
      jsApiKey: JS_KEY);

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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

    var res = await Backendless.data.of("TestTable").find();
    print(res);
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
            ElevatedButton(
              child: Text("Press"),
              onPressed: buttonPressed,
            ),
          ],
        )),
      ),
    );
  }
}
