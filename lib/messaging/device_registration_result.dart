part of backendless_sdk;

class DeviceRegistrationResult {
  String? _deviceToken;
  Map<String, String>? _channelRegistrations;

  DeviceRegistrationResult();

  DeviceRegistrationResult.fromJson(Map json) {
    if (json.containsKey('registrationId')) {
      var listTemp = (json['registrationId'] as String).split(',');
      var channelRegistrationsTemp = {};

      for (var originalString in listTemp) {
        int indexOfMarker = originalString.indexOf('::');
        String key =
            originalString.substring(indexOfMarker + 2, originalString.length);
        String value = originalString.substring(0, indexOfMarker);
        channelRegistrationsTemp[key] = value;
      }

      json['deviceToken'] = Messaging._deviceToken;
      json['channelRegistrations'] = Map.from(channelRegistrationsTemp);
    }

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
