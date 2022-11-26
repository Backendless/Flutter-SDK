part of backendless_sdk;

class _NativeFunctionsContainer {
  static Future<String?> getDeviceToken() async {
    var res = await Backendless._channelToNative.invokeMethod('getDeviceToken');
    return res;
  }
}
