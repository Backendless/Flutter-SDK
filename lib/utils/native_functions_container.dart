part of backendless_sdk;

class _NativeFunctionsContainer {
  static OnTapPushHandler? onTapPushAction;
  static late String? deviceToken;
  static StreamController streamController = StreamController.broadcast();

  static Future<String> getDeviceToken() async {
    if (deviceToken == null) {
      throw Exception('Device Token was null');
    }

    return deviceToken!;
  }

  static Future<bool> registerForRemoteNotifications() async {
    var res = await Backendless._channelNative
        .invokeMethod('registerForRemoteNotifications');
    streamController.stream.listen((event) {
      streamController.close();
    });
    return res;
  }

  static Future<dynamic> backendlessEventHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'onTapPushAction':
        {
          if (onTapPushAction != null) {
            onTapPushAction!.call();
          }
          break;
        }
      case 'setDeviceToken':
        {
          deviceToken = methodCall.arguments as String;
          streamController.add(deviceToken);
          break;
        }
      default:
        {
          throw UnimplementedError('Handler for this method unimplemented');
        }
    }
  }
}
