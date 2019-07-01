import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Result';

  @override
  void initState() {
    super.initState();
    Backendless.setUrl("https://apitest.backendless.com");
    Backendless.initApp(
        "B4988CE4-4805-1DEA-FFBA-36349CA71E00",
        "C5F6C390-E963-5D7B-FF5C-0F702B6E6B00",
        "3A11CEE8-9EC2-F5AD-FF43-BF82D4937A00");
  }

  void buttonPressed() {
    Backendless.Data.of("tableName").find(DataQueryBuilder());
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
