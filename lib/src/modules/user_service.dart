import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/modules/data.dart';
import 'package:backendless_sdk/src/utils/message_codec.dart';

class BackendlessUserService {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/user_service',
      StandardMethodCodec(BackendlessMessageCodec()));

  factory BackendlessUserService() => _instance;
  static final BackendlessUserService _instance =
      new BackendlessUserService._internal();
  BackendlessUserService._internal();

  Future<void> assignRole(String identity, String roleName) => _channel
          .invokeMethod("Backendless.UserService.assignRole", <String, dynamic>{
        "identity": identity,
        "roleName": roleName,
      });

  Future<BackendlessUser> currentUser() =>
      _channel.invokeMethod("Backendless.UserService.currentUser");

  Future<List<UserProperty>> describeUserClass() async =>
      (await _channel.invokeMethod("Backendless.UserService.describeUserClass"))
          .cast<UserProperty>();

  Future<BackendlessUser> findById(String id) => _channel.invokeMethod(
      "Backendless.UserService.findById", <String, dynamic>{"id": id});

  Future<List<String>> getUserRoles() async =>
      (await _channel.invokeMethod("Backendless.UserService.getUserRoles"))
          .cast<String>();

  Future<bool> isValidLogin() =>
      _channel.invokeMethod("Backendless.UserService.isValidLogin");

  Future<String> loggedInUser() =>
      _channel.invokeMethod("Backendless.UserService.loggedInUser");

  Future<BackendlessUser> login(String login, String password,
          [bool stayLoggedIn]) =>
      _channel.invokeMethod("Backendless.UserService.login", <String, dynamic>{
        "login": login,
        "password": password,
        "stayLoggedIn": stayLoggedIn
      });

  Future<void> logout() =>
      _channel.invokeMethod("Backendless.UserService.logout");

  Future<BackendlessUser> register(BackendlessUser user) =>
      _channel.invokeMethod(
          "Backendless.UserService.register", <String, dynamic>{"user": user});

  Future<void> resendEmailConfirmation(String email) => _channel.invokeMethod(
      "Backendless.UserService.resendEmailConfirmation",
      <String, dynamic>{"email": email});

  Future<void> restorePassword(String identity) => _channel.invokeMethod(
      "Backendless.UserService.restorePassword",
      <String, dynamic>{"identity": identity});

  Future<void> setCurrentUser(BackendlessUser user) => _channel.invokeMethod(
      "Backendless.UserService.setCurrentUser",
      <String, dynamic>{"user": user});

  Future<void> unassignRole(String identity, String roleName) =>
      _channel.invokeMethod(
          "Backendless.UserService.unassignRole", <String, dynamic>{
        "identity": identity,
        "roleName": roleName,
      });

  Future<BackendlessUser> update(BackendlessUser user) => _channel.invokeMethod(
      "Backendless.UserService.update", <String, dynamic>{"user": user});
}

class BackendlessUser {
  Map<String, dynamic> _properties = new Map<String, Object>();
  static const String PASSWORD_KEY = "password";
  static const String EMAIL_KEY = "email";
  static const String ID_KEY = "objectId";

  BackendlessUser();

  BackendlessUser.fromJson(Map json) : 
    _properties = json;

  Map toJson() => _properties;

  get properties => Map.from(_properties);

  void setProperties(Map other) => _properties
    ..clear()
    ..addAll(other);

  void putProperties(Map other) => _properties.addAll(other);

  dynamic getProperty(String key) => _properties[key];

  void setProperty(String key, dynamic value) => _properties[key] = value;

  String getObjectId() => getUserId();

  String getUserId() => getProperty(ID_KEY);

  void setPassword(String password) => setProperty(PASSWORD_KEY, password);

  String getPassword() => getProperty(PASSWORD_KEY);

  void setEmail(String email) => setProperty(EMAIL_KEY, email);

  String getEmail() => getProperty(EMAIL_KEY);

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
  String toString() => "BackendlessUser{${_properties.toString()}";
}

class UserProperty extends AbstractProperty {
  bool identity;

  UserProperty();

  UserProperty.fromJson(Map json) {
    name = json['name'];
    required = json['required'];
    type = json['type'];
    identity = json['identity'];
  }

  Map toJson() =>
    {
      'name': name,
      'required': required,
      'type': type,
      'identity': identity,
    };
}
