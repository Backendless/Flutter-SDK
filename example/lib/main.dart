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
  void initState() {
    super.initState();
    Backendless.initApp(
      applicationId: '756C19D2-DF82-9D99-FF9C-9BFD2F85DC00',
      androidApiKey: 'D3514DD9-C127-4BDA-BA06-AF0DF15EBEFB',
      iosApiKey: 'A4470C03-FC06-4009-BD47-9077033BF7F6',
    );
  }

  void _buttonPressed() async {
    // var result = await Backendless.cache.contains("mykey");
    var result = await Backendless.cache.get("mykey");
    print("Result; $result");

    DataQueryBuilder builder = DataQueryBuilder();
    builder.whereClause = 'foo=\'bar1\'';

    var resultById = await Backendless.data.of('TestTable').findById(
        '83671CD7-EEF2-4222-B950-88B0A69117E6',
        queryBuilder: builder);

    print(resultById);
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
