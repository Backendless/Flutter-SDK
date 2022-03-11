part of backendless_sdk;

class DeviceRegistrationResult {
  String? _deviceToken;
  Map<String, String>? _channelRegistrations;

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
