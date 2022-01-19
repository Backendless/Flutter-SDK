part of backendless_sdk;

abstract class AbstractProperty {
  String? name;
  bool required;
  String? type;

  AbstractProperty({this.name, this.required = false, this.type});
}

class ObjectProperty extends AbstractProperty {
  String? relatedTable;
  Object? defaultValue;

  ObjectProperty();

  ObjectProperty.fromJson(Map json) {
    relatedTable = json['relatedTable'];
    defaultValue = json['defaultValue'];
    name = json['name'];
    this.required = json['required'];
    String jsonType = json['type'];
    if (jsonType is int)
      type = jsonType;
    else
      type = jsonType;
  }

  Map toJson() => {
        'relatedTable': relatedTable,
        'defaultValue': defaultValue,
        'name': name,
        'required': this.required,
        'type': type,
      };

  @override
  String toString() =>
      "ObjectProperty{name='$name', required=${this.required}, type=$type, relatedTable='$relatedTable', defaultValue=$defaultValue}";
}
