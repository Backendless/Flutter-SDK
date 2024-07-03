part of '../../../backendless_sdk.dart';

class Relation extends Selector {
  Object? parentObject;
  String? relationColumn;
  List<String>? objectIds;
  String? relationTableName;
  bool? columnUnique;

  Relation(
      [super.conditional,
      super.unconditional,
      this.parentObject,
      this.relationColumn,
      this.objectIds,
      this.relationTableName,
      this.columnUnique]);

  Relation.fromJson(Map json)
      : parentObject = json['parentObject'],
        relationColumn = json['relationColumn'],
        objectIds = json['objectIds'],
        relationTableName = json['relationTableName'],
        super(json['conditional'], json['unconditional']);

  @override
  String toString() {
    return "Relation{parentObject=$parentObject, relationColumn=$relationColumn, conditional=$conditional, unconditional=$unconditional}";
  }

  Map toJson() => {
        "conditional": conditional,
        "unconditional": unconditional,
        "parentObject": parentObject,
        "relationColumn": relationColumn,
      };
}
