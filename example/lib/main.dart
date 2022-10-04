import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'main.reflectable.dart';

void main() {
  initializeReflectable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Backendless.initApp(
      applicationId: '756C19D2-DF82-9D99-FF9C-9BFD2F85DC00',
      androidApiKey: 'D3514DD9-C127-4BDA-BA06-AF0DF15EBEFB',
      iosApiKey: 'A4470C03-FC06-4009-BD47-9077033BF7F6',
    );
  }

  void _buttonPressed() async {
    /*if (await Backendless.userService.getCurrentUser(false) == null) {
      await Backendless.userService.login('hdhdhd@gmail.com', '123234', true);
    }
    */

    // BackendlessUser user = BackendlessUser();
    // user.email = 'hdhdhd2@gmail.com';
    // user.password = '123234';
    // user.setProperty('name', 'UserUpdated');
    // user.setProperty('objectId', '15677AD7-7124-45CC-8189-403AE0437D3F');
    // //await Backendless.userService.login(user.email, user.password, true);
    // Map map = Map();
    // map['foo'] = 'Update object';
    // map['objectId'] = '6E0E7E2A-1F66-4217-BD34-E2C323FCF372';
    // LoadRelationsQueryBuilder lRQB = LoadRelationsQueryBuilder.ofMap('userRel');
    //
    // var result = await Backendless.messaging.registerDevice(onMessage: onPush);
    await Backendless.userService.logout();

    TestTable tt = TestTable();
    tt.foo = 'TT';

    //var res = await Backendless.data.withClass<TestTable>().find();

    //print(res);
    //await Backendless.data.of("TestTable").find();

    //var ev = await Backendless.data.withClass<TestTable>().rt();
    var ev = await Backendless.data.of('TestTable').rt();
    //
    // ev.addSetRelationListener('testRel', (resp) {
    //   print('set relation $resp');
    //   ev.removeSetRelationListeners();
    // });
    //
    // ev.addConnectListener(() => print('connected listener has been called'));
    //
    // ev.addAddRelationListener('testRel', (resp) {
    //   print('add relation $resp');
    //   ev.removeAddRelationListeners();
    // });

    var mev = await Backendless.messaging.subscribe();

    mev.join();
    mev.addMessageListener((response) {
      print('SOME MESS');
      print(response);

      mev.removeMessageListeners();
    });

    /*ev.addCreateListener((response) {
      print('create $response');
    }, onError: (error) {
      print('error $error');
    });

    ev.addUpdateListener((response) => print('update $response'));

    ev.addUpsertListener((response) => print('upsert $response'));

    ev.addDeleteListener(
      (response) => print('delete $response'),
    );*/
  }

  void onPush(RemoteMessage message) async {
    print('new message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'Backendless',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buttonPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

@reflector
class TestTable {
  String? objectId;
  String? foo;
  BackendlessUser? userRel;
}
