import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'main.reflectable.dart';
import 'car.dart'; 
import 'bus.dart';

import 'package:reflectable/reflectable.dart';

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
        "4C50E3CB-D44F-2019-FF4D-ECE3F1E06B00",
        "FD99AED3-300E-8BAC-FF42-6DCBE4084F00",
        "2809016A-662D-7133-FFC0-08EC52CA6800");
  }

  void buttonPressed() {
    Bus bus = Bus()
      ..s = "some string"
      ..i = 1337
      ..dateTime = DateTime.now();

    Car car = Car()
      ..brand = "Tesla"
      ..model = "X"
      ..price = 100000.99
      ..year = DateTime.now()
      ..isUsed = false
      ..bus = [bus];





    // Backendless.data.ofClass<Bus>().save(bus).then((savedBus) => print(savedBus));
    Backendless.data.ofClass<Car>().findLast().then((foundCar) => print(foundCar));
    // Backendless.data.ofClass<Car>().save(car).then((savedCar) => print(savedCar));
    // print(reflector.annotatedClasses.first.reflectedType);
    // print(reflector.annotatedClasses.first.dynamicReflectedType);


  }

  void dd<T>(T type) {
    print(T);

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