part of backendless_sdk;

class GroupColumnValue {
  GroupColumnValue(this.column, this.value);

  String? column;
  dynamic value;

  GroupColumnValue.fromJson(Map json) {
    column = json['column'];
    value = json['value'];
  }

  Map toJson() => {
        'column': column,
        'value': value,
      };
}
