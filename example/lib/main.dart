import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:backendless_sdk/src/utils/utils.dart';
import 'package:backendless_sdk/src/modules/modules.dart';

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
    EmailEnvelope envelope = EmailEnvelope()
      ..to = ["email@gmail.com"].toSet()
      ..cc = ["secondemail@gmail.com"].toSet();

    Map<String, String> templateValues = {
      "app_name": "My app yoooo",
      "confirmation_url": "Here is some link",
    };

    Backendless.Messaging.sendEmailFromTemplate("MyTemplate", envelope, templateValues).then((v) => print(v));
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
