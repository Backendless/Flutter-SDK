import 'package:backendless_sdk/backendless_sdk.dart';

@Reflector()
class TestTable {
  @MapToProperty("customFoo")
  String foo;
  @Ttt()
  String bar;

  @override
  toString() => "TestTable: {foo: $foo, bar: $bar}";
}

class Ttt {
  const Ttt();
}