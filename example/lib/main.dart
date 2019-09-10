import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'test_table.dart';

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

    Backendless.initApp(
        "67993429-C72B-72C7-FFDF-FEA2A54FFD00",
        "F609FF3E-588E-0CCC-FFBB-EB44CFC78600",
        "849D5B40-C3CD-E3E2-FF37-AEB0CC452700");
  }

  void buttonPressed() {
    Backendless.messaging.registerDevice(null, null, _onMessage).then((response) => print("Device has been registered!"));
  }

  void _onMessage(Map<String, dynamic> message) {
    print(message);
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
