import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'main.reflectable.dart';

@reflector
class Test {
  String foo;
  Point point;
  LineString lineString;
  Polygon polygon;

  @override
  String toString() =>
      "'Test' custom class:\n\tpoint: $point\n\tlineString: $lineString\n\tpolygon: $polygon";
}

void main() {
  initializeReflectable();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

@reflector
class Order {
  String orderStatus;
  DateTime deliveryDate;
  String objectId;
  double d;
}

@reflector
class Person {
  String name;
  int age;
  String objectId;
}

@reflector
class TestTable {
  String foo;
  String objectId;
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Backendless.initApp(
      "0B83DD7F-A769-898E-FF28-6EC3B93C4200",
      "D7186AEB-32A8-9C08-FF41-4F4A87A98200",
      null);
  }
  
  void buttonPressed() async {
    final unitOfWork = UnitOfWork();

// compose query builder
final queryBuilder = DataQueryBuilder();

// set the query condition
queryBuilder.whereClause = "foo = 'bar2'";

// we need only one object, this will help to speed it up
queryBuilder.pageSize = 1;

// add the find operation to the transaction
final findResult = unitOfWork.find("TestTable", queryBuilder);

// get a reference to the first object (order) from the result
final orderObjectRef = findResult.resolveTo(resultIndex: 0);

// compose a map of changes - notice the objectId is not needed there
Map changes ={
 "foo": "OPRESULT bar",
};

// add the update operation to the transaction
unitOfWork.update(changes, orderObjectRef);

// run the transaction
unitOfWork.execute().then((result) => print("transaction complete - $result"));
  }

  void test() async {
    final unitOfWork = UnitOfWork();

    Map testTable = {"foo": "bar_from_transaction"};

    unitOfWork.create(testTable, "TestTable");

    String json = jsonEncode(testTable);
    print("Json encode: $json");
  }

  void setRelationTest() async {
    final unitOfWork = UnitOfWork();
    
    final iPad = {
    "objectId": "EE3BF4B5-DB88-1425-FF89-CC11B7707500"
    };

    final iPhone = {
    "objectId": "0CF23E36-FCC0-4E04-FF3E-8B67E6E27200"
    };

    final gifts = [iPad, iPhone];

    final personObject = {
    "objectId": "E7AD83E0-1B4E-D250-FF46-61BFAB18D700"
    };

    final parentTableName = "Person";

    final relationColumnName = "wishlist";

    unitOfWork.setRelation(
      personObject,
      relationColumnName,
      gifts,
      parentTableName
    );
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
            RaisedButton(child: Text("Press"), onPressed: buttonPressed),

            RaisedButton(child: Text("Test"), onPressed: test)
          ],
        )),
      ),
    );
  }
}
