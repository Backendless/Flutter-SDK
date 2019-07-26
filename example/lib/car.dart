import 'package:backendless_sdk/backendless_sdk.dart';

import 'bus.dart';

@reflector
class Car {
  String brand;
  String model;
  double price;
  DateTime year;
  bool isUsed;
  int date;
  BackendlessUser user;
  List bus;

  @override
  toString() => 'brand: $brand\nmodel: $model\nprice: $price\nyear: $year\nisUsed:$isUsed\nuser: $user\nbus: $bus';
}