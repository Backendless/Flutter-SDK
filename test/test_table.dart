import 'package:json_annotation/json_annotation.dart';

part 'test_table.g.dart';

@JsonSerializable()
class TestTable {
    String foo;

    TestTable({String foo});

    factory TestTable.fromJson(Map<String, dynamic> json) => _$TestTableFromJson(json);

    Map<String, dynamic> toJson() => _$TestTableToJson(this);
}