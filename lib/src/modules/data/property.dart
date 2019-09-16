part of backendless_sdk;

abstract class AbstractProperty {
  String name;
  bool required;
  DataTypeEnum type;

  AbstractProperty({this.name, this.required = false, this.type});
}

class ObjectProperty extends AbstractProperty {
  String relatedTable;
  Object defaultValue;

  ObjectProperty();

  ObjectProperty.fromJson(Map json) {
    relatedTable = json['relatedTable'];
    defaultValue = json['defaultValue'];
    name = json['name'];
    this.required = json['required'];
    type = DataTypeEnum.values[json['type']];
  }

  Map toJson() => {
        'relatedTable': relatedTable,
        'defaultValue': defaultValue,
        'name': name,
        'required': this.required,
        'type': type?.index,
      };

  @override
  String toString() =>
      "ObjectProperty{name='$name', required=${this.required}, type=$type, relatedTable='$relatedTable', defaultValue=$defaultValue}";
}

enum DataTypeEnum {
  UNKNOWN,
  INT,
  STRING,
  BOOLEAN,
  DATETIME,
  DOUBLE,
  RELATION,
  COLLECTION,
  RELATION_LIST,
  STRING_ID,
  TEXT
}
