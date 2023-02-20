import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

import 'main.reflectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token = 'Text';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      // Backendless.url = 'https://stage-api.backendless.com';
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
          child: Column(
            children: [
              TextButton(
                  onPressed: testFunction2, child: const Text('Get Token')),
              TextButton(
                onPressed: mainFunction,
                // setState(() {});
                child: const Text('Login'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(token == null ? 'null' : token!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mainFunction() async {
    // var res = await Backendless.messaging.registerDevice(
    //     onTapPushAction: testFunction, onMessage: testFunction2);
    /*
    var rt = await Backendless.data.withClass<TestTable>().rt();
    rt.addBulkCreateListener((response) {
      print('rt: $response');
    });

    rt.addConnectListener(() {
      print('Connected');
    }, onError: (String mes) {
      print('Error: $mes');
    });

    rt.addDisconnectListener(() {
      print('Disconnect');
    });

    if (kDebugMode) {
      //print(res);
    }*/
    token = await Backendless.userService.getUserToken();
    var user = await Backendless.userService
        .login('hdhdhd@gmail.com', '123234', stayLoggedIn: true);

    /*await Backendless.userService.setCurrentUser(tmpUser);
    await Backendless.userService.setUserToken("fake-token-2");*/

    token = await Backendless.userService.getUserToken();

    final valid = await Backendless.userService.isValidLogin();
    print("is valid login: ");
    print(valid);
    //
    // try {
    //   var r =
    //       await Backendless.customService.invoke('Variables', 'getItems', null);
    // } catch (ex) {
    //   await Backendless.userService.logout();
    //   var tokenAfterLogin = await Backendless.userService.getUserToken();
    //
    //   var r = await Backendless.customService
    //       .invoke('Variables', 'getItems', 'value');
    //   print(r);
    // }
    // // custom service request
    //
    // await Backendless.userService.logout();
    // var tokenAfterLogin = await Backendless.userService.getUserToken();
    // if (tokenAfterLogin != null)
    //   print("tokenAfterLogin is now: " + tokenAfterLogin);
    // else
    //   print("tokenAfterLogin is null");
  }

  Future<void> testFunction2() async {
    token = await Backendless.userService.getUserToken();
    setState(() {});
  }

  Future<void> testFunction({Map? data}) async {
    print("TEST FUNCTION HERE!!!");
  }
}

@reflector
class TestTable {
  String? foo;
  String? nameTimeColumn;
}

@reflector
class Person {
  final String noZeroField;
  int? age;
  String? name;
  Point? p1;

  Person(this.noZeroField);
}
