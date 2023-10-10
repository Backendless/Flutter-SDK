part of backendless_sdk;

class _NativeFunctionsContainer {
  static OnTapHandlerIOS? onTapPushAction;
  static String? deviceToken;
  static StreamController streamController = StreamController.broadcast();
  static MessageHandler? messageHandler;

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
      case 'onMessage':
        {
          if (messageHandler != null) {
            messageHandler!.call(methodCall.arguments as Map);
          }
          break;
        }
      case 'onTapPushAction':
        {
          if (onTapPushAction != null) {
            await onTapPushAction!.call(data: methodCall.arguments as Map?);
          }
          break;
        }
      case 'setDeviceToken':
        {
          deviceToken = methodCall.arguments as String;
          streamController.add(deviceToken);
          break;
        }
      case 'showNotificationWithTemplate':
        {
          var t = methodCall.arguments;
          // ignore:avoid_print
          print(t);

          PushTemplateWorker.showPushNotification(t);
          break;
        }
      default:
        {
          throw UnimplementedError('Handler for this method unimplemented');
        }
    }
  }
}
