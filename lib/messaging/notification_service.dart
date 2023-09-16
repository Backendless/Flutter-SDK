part of backendless_sdk;

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  Future<void> init({
    Future<void> Function(Map message)? onMessage,
    Future<void> Function(RemoteMessage message)? onBackgroundMessage,
    Future<void> Function(RemoteMessage message)? onMessageOpenedApp,
  }) async {
    // Request permission for notifications on Android
    await _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true);

    // Handle notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
      }
      if (kDebugMode) {
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }

      //var mapMessage = message.toMap();
      //PushTemplateWorker.showPushNotification(mapMessage);

      if (onMessage != null) {
        await onMessage.call(message.data);
      }

      _messageStreamController.add(message.data);
    });

    if (onBackgroundMessage == null) {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } else {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    }

    // Handle notifications when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }

      if (onMessageOpenedApp != null) {
        await onMessageOpenedApp.call(message);
      }

      _messageStreamController.add(message.data);
    });

    // Handle notifications when the app is closed
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print('App opened via a notification!');
      }
      _messageStreamController.add(initialMessage.data);
    }
  }
}
