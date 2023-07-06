part of backendless_sdk;

class PublishOptions {
  String? publisherId;
  Map<String, String> headers = {};
  static const String templateName = "template_name";
  static const String androidImmediatePush = "android_immediate_push";
  static const String iosImmediatePush = "ios_immediate_push";
  static const String inlineReply = "inline_reply";
  static const String notificationId = "notificationId";
  static const String messageId = "messageId";
  static const String messageTag = "message";
  static const String iosAlertTag = "ios-alert";
  static const String iosBadgeTag = "ios-badge";
  static const String iosSoundTag = "ios-sound";
  static const String iosTitleTag = "ios-alert-title";
  static const String iosSubtitleTag = "ios-alert-subtitle";
  static const String androidTickerTextTag = "android-ticker-text";
  static const String androidContentTitleTag = "android-content-title";
  static const String androidContentTextTag = "android-content-text";
  static const String androidActionTag = "android-action";
  static const String androidSummarySubtextTag = "android-summary-subtext";
  static const String androidContentSoundTag = "android-content-sound";
  static const String wpTypeTag = "wp-type";
  static const String wpTitleTag = "wp-title";
  static const String wpToastSubtitleTag = "wp-subtitle";
  static const String wpToastParameterTag = "wp-parameter";
  static const String wpTileBackgroundImage = "wp-backgroundImage";
  static const String wpTileCount = "wp-count";
  static const String wpTileBackTitle = "wp-backTitle";
  static const String wpTileBackBackgroundImage = "wp-backImage";
  static const String wpTileBackContent = "wp-backContent";
  static const String wpRawData = "wp-raw";
  static const String wpContentTag = "wp-content";
  static const String wpBadgeTag = "wp-badge";

  PublishOptions();

  PublishOptions.fromJson(Map json)
      : publisherId = json['publisherId'],
        headers = json['headers'].cast<String, String>();

  Map toJson() => {
        'publisherId': publisherId,
        'headers': headers,
      };

  PublishOptions.from(PublishMessageInfo info) {
    publisherId = info.publisherId;
    headers.addAll(info.headers);
  }
}
