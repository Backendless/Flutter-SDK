import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:backendless_sdk/utils/template_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class PushTemplateWorker {
  static bool isInitializedPlugin = false;

  static Future<void> showPushNotification(Map notification) async {
    if (!isInitializedPlugin) {
      await initializePlugin();
    }

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails('default', 'channelName');

    String title = 'Backendless Title';
    String message = 'Backendless Message';
    int badge = 1;
    String? threadId;
    int id = Random().nextInt(2147483646);
    String? templateName = notification['template_name'];

    if (notification.containsKey('data')) {
      templateName ??= notification['data']['template_name'];
    }

    if (templateName == null) {
      if (Platform.isAndroid) {
        title = notification['android-content-title'];
      }
      if (Platform.isIOS) {
        title = notification['ios-alert-title'];
      }

      message = notification['message'];
    } else {
      Map? templateFromStorage;
      if (await TemplateStorage.containsTemplate(templateName)) {
        String templateAsString =
            await TemplateStorage.getTemplate(templateName) as String;
        templateFromStorage = jsonDecode(templateAsString);
      }

      if (Platform.isIOS) {
        badge = notification['aps']['badge']!;
        threadId = notification['thread-id'];
        // String? summaryFormat = notification['summary-format'];

        message = notification['message'];
        title = notification['ios-alert-title'];
        String? subtitle = notification['aps']['alert']['subtitle'];
        iosDetails = DarwinNotificationDetails(
            badgeNumber: badge, subtitle: subtitle, threadIdentifier: threadId);
      } else if (Platform.isAndroid) {
        if (templateFromStorage != null) {
          badge = templateFromStorage['badge'];
          Color? color = Color(templateFromStorage['colorCode']);

          if (notification.containsKey('data')) {
            message = notification['data']['message'];
            title = notification['data']['android-content-title'];
          } else {
            message = notification['message'];
            title = notification['android-content-title'];
          }

          androidDetails = AndroidNotificationDetails(
            templateName,
            templateName,
            priority: Priority(templateFromStorage['priority'] - 3),
            importance: Importance(templateFromStorage['priority']),
            number: badge,
            icon: templateFromStorage['icon'],
            color: color,
          );
        }
      }
    }

    notification['flutter_notification_identifier'] = 'identity';
    String payload = jsonEncode(notification);

    var notificationDetails =
        NotificationDetails(iOS: iosDetails, android: androidDetails);

    await _flutterLocalNotificationsPlugin
        .show(id, title, message, notificationDetails, payload: payload);
  }

  static initializePlugin() {
    try {
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true,
              onDidReceiveLocalNotification:
                  (int id, String? title, String? body, String? payload) async {
                // ignore: avoid_print
                print(
                    'Notification was receive: $title\nBody: $body\nPayload: $payload');
              });

      ///TODO: add path to icon
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      final InitializationSettings initializationSettings =
          InitializationSettings(
        iOS: initializationSettingsIOS,
        android: initializationSettingsAndroid,
      );

      _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
          // ignore: avoid_print
          print('Notification Response handler called');
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      isInitializedPlugin = true;
    } catch (ex) {
      // ignore: avoid_print
      print('EXCEPTION: $ex');
    }
  }
}
