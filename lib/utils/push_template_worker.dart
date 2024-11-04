import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:ui';
import '../backendless_sdk.dart';
import '../utils/template_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
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
  static OnTapHandlerAndroid onDidReceiveNotificationResponse;
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
    int badge = 0;
    String? threadId;
    String? subtitle;
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
        badge = notification['aps']['badge'] ?? 0;
        threadId = notification['thread-id'];
        // String? summaryFormat = notification['summary-format'];

        message = notification['message'];
        title = notification['ios-alert-title'];
        subtitle = notification['aps']['alert']['subtitle'];
        List<DarwinNotificationAttachment>? iosAttachments;

        if(notification.containsKey('attachment-url') && notification['attachment-url'] != null && (notification['attachment-url'] as String).isNotEmpty) {
          final http.Response response = await http.get(Uri.parse(notification['attachment-url']));
          final dir = await getTemporaryDirectory();
          var filename = '${dir.path}/image.png';
          final file = File(filename);
          await file.writeAsBytes(response.bodyBytes);

          iosAttachments = [DarwinNotificationAttachment(filename)];
        }

        iosDetails = DarwinNotificationDetails(
            badgeNumber: badge, subtitle: subtitle, threadIdentifier: threadId, attachments: iosAttachments);
      } else if (Platform.isAndroid) {
        if (templateFromStorage != null) {
          badge = templateFromStorage['badge'] ?? 0;
          Color? color = Color(templateFromStorage['colorCode']);
          String? largeIconPath;

          if (notification.containsKey('data')) {
            message = notification['data']['message'];
            title = notification['data']['android-content-title'];
          } else {
            message = notification['message'];
            title = notification['android-content-title'];
            subtitle = notification['android-summary-subtext'];
          }

          if(notification.containsKey('android-large-icon') && notification['android-large-icon'] != null && (notification['android-large-icon'] as String).isNotEmpty) {
            final http.Response response = await http.get(Uri.parse(notification['android-large-icon']));
            final dir = await getTemporaryDirectory();
            var filename = '${dir.path}/largeIcon.png';
            final file = File(filename);
            await file.writeAsBytes(response.bodyBytes);

            largeIconPath = filename;
          }

          androidDetails = AndroidNotificationDetails(
            templateName,
            templateName,
            priority: Priority.max,
            importance: Importance.max,
            subText: subtitle,
            number: badge,
            icon: templateFromStorage['icon'],
            color: color,
            largeIcon: largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
          );
        }
      }
    }

    notification['flutter_notification_identifier'] = 'identity';
    String payload = jsonEncode(notification);

    var notificationDetails =
        NotificationDetails(iOS: iosDetails, android: androidDetails);

    await flutterLocalNotificationsPlugin
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

      if (Platform.isIOS) {
        flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse notificationResponse) {
            // ignore: avoid_print
            print('Notification Response handler called');
          },
          onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        );
      } else {
        flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
          onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        );
      }

      isInitializedPlugin = true;
    } catch (ex) {
      // ignore: avoid_print
      print('EXCEPTION: $ex');
    }
  }
}
