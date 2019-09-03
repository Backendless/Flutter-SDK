import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

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
        "1E0573AC-46CC-7244-FFAB-A55AD3D05B00",
        "8A61E955-D8D6-CBF3-FFF8-FE53DEE02800",
        "6CBB8265-045A-C493-FF70-FD0908D51200");
  }

  void buttonPressed() {
    Backendless.userService.login("email2@email.com", "password", true)
      .then( (beUser) {
        print(beUser.properties);

        Backendless.userService.logout()
          .then( (_) {
            print("~~~> Did logout");
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
