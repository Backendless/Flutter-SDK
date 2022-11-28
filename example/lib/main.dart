import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() {
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
        applicationId: '756C19D2-DF82-9D99-FF9C-9BFD2F85DC00',
        androidApiKey: 'D3514DD9-C127-4BDA-BA06-AF0DF15EBEFB',
        iosApiKey: 'A4470C03-FC06-4009-BD47-9077033BF7F6',
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
          child: TextButton(
            child: const Text('Test'),
            onPressed: mainFunction,
          ),
        ),
      ),
    );
  }

  Future<void> mainFunction() async {
    var res = await Backendless.messaging
        .registerDevice(onTapPushAction: testFunction);

    if (kDebugMode) {
      print(res);
    }
  }

  Future<void> testFunction({Map? data}) async {
    print("TEST FUNCTION HERE!!!");
  }
}
