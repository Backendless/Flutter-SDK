import 'dart:async';
//import 'main.reflectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initializeReflectable();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      await Backendless.initApp(
        applicationId: 'APP_ID',
        androidApiKey: 'ANDROID_API_KEY',
        iosApiKey: 'IOS_API_KEY',
      );
    } on Exception {
      if (kDebugMode) {
        print('Failed to init application.');
      }
    }
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
            children: [
              TextButton(onPressed: buttonPressed, child: const Text('Press')),
            ],
          ),
        ),
      ),
    );
  }

  void buttonPressed() async {
    // create a Map object. This will become a record in a database table
    Map testObject = {};

    // add a property to the object.
    // The property name ("foo") will become a column in the database table
    // The property value ("bar") will be stored as a value for the stored record
    testObject["foo"] = "bar";

    // Save the object in the database. The name of the database table is "TestTable".

    Backendless.data.of("TestTable").save(testObject).then((response) {
      if (kDebugMode) {
        print("Object is saved in Backendless. Please check in the console.");
      }
    });
  }
}
