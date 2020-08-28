part of backendless_sdk;

class BackendlessUser {
  Map<String, dynamic> _properties = new Map<String, dynamic>();
  static const String PASSWORD_KEY = "password";
  static const String EMAIL_KEY = "email";
  static const String ID_KEY = "objectId";

  BackendlessUser();

  BackendlessUser.fromJson(Map json) {
    if (json.containsKey('properties'))
      _properties = json['properties'].cast<String, dynamic>();
    else
      _properties = json.cast<String, dynamic>();
  }

  Map toJson() => {"properties": _properties};

  get properties => Map.from(_properties);

  void setProperties(Map<String, dynamic> other) => _properties
    ..clear()
    ..addAll(other);

  void putProperties(Map<String, dynamic> other) => _properties.addAll(other);

  dynamic getProperty(String key) => _properties[key];

  void setProperty(String key, dynamic value) => _properties[key] = value;

  String getObjectId() => getUserId();

  String getUserId() => getProperty(ID_KEY);

  set password(String password) => setProperty(PASSWORD_KEY, password);

  String get password => getProperty(PASSWORD_KEY);

  set email(String email) => setProperty(EMAIL_KEY, email);

  String get email => getProperty(EMAIL_KEY);

  void clearProperties() => _properties.clear();

  dynamic removeProperty(String key) => _properties.remove(key);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is BackendlessUser &&
          runtimeType == other.runtimeType &&
          MapEquality().equals(_properties, other._properties);

  @override
  int get hashCode => MapEquality().hash(_properties);

  @override
  String toString() => "BackendlessUser{${_properties.toString()}}";
}
