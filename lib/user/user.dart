part of backendless_sdk;

class BackendlessUser {
  Map<String, dynamic> _properties = <String, dynamic>{};
  static const String passwordKey = "password";
  static const String emailKey = "email";
  static const String idKey = "objectId";

  BackendlessUser();

  BackendlessUser.fromJson(Map json) {
    _properties = json.cast<String, dynamic>();
  }

  Map toJson() => _properties;

  get properties => Map.from(_properties);

  void setProperties(Map<String, dynamic> other) => _properties
    ..clear()
    ..addAll(other);

  void putProperties(Map<String, dynamic> other) => _properties.addAll(other);

  dynamic getProperty(String key) => _properties[key];

  void setProperty(String key, dynamic value) => _properties[key] = value;

  String? getObjectId() => getUserId();

  String? getUserId() => getProperty(idKey);

  set password(String password) => setProperty(passwordKey, password);

  String get password => getProperty(passwordKey);

  set email(String email) => setProperty(emailKey, email);

  String get email => getProperty(emailKey);

  void clearProperties() => _properties.clear();

  dynamic removeProperty(String key) => _properties.remove(key);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is BackendlessUser &&
          runtimeType == other.runtimeType &&
          const MapEquality().equals(_properties, other._properties);

  @override
  int get hashCode => const MapEquality().hash(_properties);

  @override
  String toString() => "BackendlessUser{${_properties.toString()}}";
}
