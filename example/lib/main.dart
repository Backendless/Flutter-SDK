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

    Backendless.initApp(
        "4C50E3CB-D44F-2019-FF4D-ECE3F1E06B00",
        "FD99AED3-300E-8BAC-FF42-6DCBE4084F00",
        "2809016A-662D-7133-FFC0-08EC52CA6800");
  }

  void buttonPressed() {
    Backendless.getHeaders().then((headers) {
      print(headers);
      Backendless.setHeader(HeadersEnum.API_VERSION, "mavalue").then((onValue) {
        Backendless.getHeaders().then((headers) {
          print(headers);
          Backendless.removeHeader(HeadersEnum.APP_TYPE_NAME).then((onValue) {
            Backendless.getHeaders().then((headers) {
              print(headers);
            });
          });
        });
      });
    });
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
