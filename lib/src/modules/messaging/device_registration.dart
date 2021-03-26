part of backendless_sdk;

class DeviceRegistration {
  String id = "";
  String deviceToken = "";
  String deviceId = "";
  String os;
  String _osVersion;
  DateTime expiration;
  List<String> channels = <String>[];

  DeviceRegistration();

  set osVersion(int value) => _osVersion = value.toString();

  get osVersion => _osVersion;

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

class DeviceRegistrationResult {
  String _deviceToken;
  Map<String, String> _channelRegistrations;

  DeviceRegistrationResult();

  DeviceRegistrationResult.fromJson(Map json) {
    _deviceToken = json['deviceToken'];
    _channelRegistrations =
        json['channelRegistrations']?.cast<String, String>();
  }

  Map toJson() => {
        'deviceToken': _deviceToken,
        'channelRegistrations': _channelRegistrations,
      };

  get deviceToken => _deviceToken;
  get channelRegistrations => _channelRegistrations;

  @override
  String toString() =>
      "DeviceRegistrationResult{deviceToken='$deviceToken', channelRegistrations=$channelRegistrations}";
}
