import 'package:backendless_sdk/backendless_sdk.dart';

@reflector
class Bus {
  String s;
  int i;
  DateTime date;

  @override
  toString() => 's: $s\ni: $i\ndate: $date';
}