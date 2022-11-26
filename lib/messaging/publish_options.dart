part of backendless_sdk;

class PublishOptions {
  String? publisherId;
  Map<String, String> headers = new Map();
  static const String TEMPLATE_NAME = "template_name";
  static const String ANDROID_IMMEDIATE_PUSH = "android_immediate_push";
  static const String IOS_IMMEDIATE_PUSH = "ios_immediate_push";
  static const String INLINE_REPLY = "inline_reply";
  static const String NOTIFICATION_ID = "notificationId";
  static const String MESSAGE_ID = "messageId";
  static const String MESSAGE_TAG = "message";
  static const String IOS_ALERT_TAG = "ios-alert";
  static const String IOS_BADGE_TAG = "ios-badge";
  static const String IOS_SOUND_TAG = "ios-sound";
  static const String IOS_TITLE_TAG = "ios-alert-title";
  static const String IOS_SUBTITLE_TAG = "ios-alert-subtitle";
  static const String ANDROID_TICKER_TEXT_TAG = "android-ticker-text";
  static const String ANDROID_CONTENT_TITLE_TAG = "android-content-title";
  static const String ANDROID_CONTENT_TEXT_TAG = "android-content-text";
  static const String ANDROID_ACTION_TAG = "android-action";
  static const String ANDROID_SUMMARY_SUBTEXT_TAG = "android-summary-subtext";
  static const String ANDROID_CONTENT_SOUND_TAG = "android-content-sound";
  static const String WP_TYPE_TAG = "wp-type";
  static const String WP_TITLE_TAG = "wp-title";
  static const String WP_TOAST_SUBTITLE_TAG = "wp-subtitle";
  static const String WP_TOAST_PARAMETER_TAG = "wp-parameter";
  static const String WP_TILE_BACKGROUND_IMAGE = "wp-backgroundImage";
  static const String WP_TILE_COUNT = "wp-count";
  static const String WP_TILE_BACK_TITLE = "wp-backTitle";
  static const String WP_TILE_BACK_BACKGROUND_IMAGE = "wp-backImage";
  static const String WP_TILE_BACK_CONTENT = "wp-backContent";
  static const String WP_RAW_DATA = "wp-raw";
  static const String WP_CONTENT_TAG = "wp-content";
  static const String WP_BADGE_TAG = "wp-badge";

  PublishOptions();

  PublishOptions.fromJson(Map json)
      : publisherId = json['publisherId'],
        headers = json['headers'].cast<String, String>();

  Map toJson() => {
    'publisherId': publisherId,
    'headers': headers,
  };

  PublishOptions.from(PublishMessageInfo info) {
    this.publisherId = info.publisherId;
    this.headers.addAll(info.headers);
  }
}