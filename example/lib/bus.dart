import 'package:backendless_sdk/backendless_sdk.dart';

@reflector
class Bus {
  String s;
  int i;
  DateTime dateTime;

  @override
  toString() => 's: $s\ni: $i\ndate: $dateTime';
}