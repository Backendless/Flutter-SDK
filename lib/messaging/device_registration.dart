part of backendless_sdk;

class DeviceRegistration {
  String? id = "";
  String? deviceToken = "";
  String? deviceId = "";
  String? os;
  String? _osVersion;
  DateTime? expiration;
  List<String>? channels = <String>[];

  DeviceRegistration();

  set osVersion(String? value) => _osVersion = value.toString();

  String? get osVersion => _osVersion;

  DeviceRegistration.fromJson(Map json)
      : id = json['id'],
        deviceToken = json['deviceToken'],
        deviceId = json['deviceId'],
        os = json['os'],
        _osVersion = json['osVersion'],
        expiration = json['expiration'] is int
            ? DateTime.fromMillisecondsSinceEpoch(json['expiration'])
            : json['expiration'],
        channels = json['channels'].cast<String>();

  Map toJson() => {
        'id': id,
        'deviceToken': deviceToken,
        'deviceId': deviceId,
        'os': os,
        'osVersion': _osVersion,
        'expiration': expiration,
        'channels': channels,
      };
}
