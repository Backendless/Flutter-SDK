part of backendless_sdk;

class Relation extends Selector {
  Object parentObject;
  String relationColumn;
  List<String> objectIds;
  String relationTableName;
  bool columnUnique;

  Relation( [String conditional, Object unconditional, this.parentObject, this.relationColumn,
                   this.objectIds, this.relationTableName, this.columnUnique] ) : super(conditional, unconditional);
  
  Relation.fromJson(Map json) : 
    parentObject = json['parentObject'], 
    relationColumn = json['relationColumn'], 
    objectIds = json['objectIds'], 
    relationTableName = json['relationTableName'], 
    super(json['conditional'], json['unconditional']);

@override
  String toString()
  {
    return "Relation{" +
            "parentObject=" + parentObject + '\'' +
            ", relationColumn='" + relationColumn + '\'' +
            ", conditional='" + this.conditional + '\'' +
            ", unconditional=" + this.unconditional +
            '}';
  }

  String toJson() {
    String properties = (conditional != null) ? 
      '"conditional": "$conditional"' : '"unconditional": ${jsonEncode(unconditional)}';
    return '{"parentObject" : ${jsonEncode(parentObject)}, "relationColumn": "$relationColumn",  $properties}';
  }
}