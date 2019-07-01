part of backendless_sdk;

class UserProperty extends AbstractProperty {
  bool identity;

  UserProperty();

  UserProperty.fromJson(Map json) {
    name = json['name'];
    this.required = json['required'];
    type = DateTypeEnum.values[json['type']];
    identity = json['identity'];
  }

  Map toJson() => {
        'name': name,
        'required': this.required,
        'type': type?.index,
        'identity': identity,
      };
}
