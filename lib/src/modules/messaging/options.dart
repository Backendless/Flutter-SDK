part of backendless_sdk;

class PublishOptions {
  String publisherId;
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
    if (info.headers != null) {
      this.headers.addAll(info.headers);
    }
  }
}

class DeliveryOptions {
  int pushBroadcast;
  List<String> pushSinglecast = new List();
  String segmentQuery;
  PublishPolicyEnum publishPolicy = PublishPolicyEnum.BOTH;
  DateTime publishAt;
  int repeatEvery;
  DateTime repeatExpiresAt;

  DeliveryOptions();

  DeliveryOptions.fromJson(Map json)
      : pushBroadcast = json['pushBroadcast'],
        pushSinglecast = json['pushSinglecast'].cast<String>(),
        segmentQuery = json['segmentQuery'],
        publishPolicy = PublishPolicyEnum.values[json['publishPolicy']],
        publishAt = json['publishAt'] is int ? DateTime.fromMillisecondsSinceEpoch(json['publishAt']) : json['publishAt'],
        repeatEvery = json['repeatEvery'],
        repeatExpiresAt = json['repeatExpiresAt'] is int ? DateTime.fromMillisecondsSinceEpoch(json['repeatExpiresAt']) : json['repeatExpiresAt'];

  Map toJson() => {
        'pushBroadcast': pushBroadcast,
        'pushSinglecast': pushSinglecast,
        'segmentQuery': segmentQuery,
        'publishPolicy': publishPolicy?.index,
        'publishAt': publishAt,
        'repeatEvery': repeatEvery,
        'repeatExpiresAt': repeatExpiresAt,
      };

  DeliveryOptions.from(PublishMessageInfo info) {
    this.publishPolicy = PublishPolicyEnum.BOTH;
    this.pushBroadcast = PushBroadcastMask.toIntMask(info.pushBroadcast);
    this.segmentQuery = info.query;
    if (info.publishAt > 0)
      this.publishAt = new DateTime.fromMillisecondsSinceEpoch(info.publishAt);
    if (info.repeatEvery > 0) this.repeatEvery = info.repeatEvery;
    if (info.repeatExpiresAt > 0)
      this.repeatExpiresAt =
          new DateTime.fromMillisecondsSinceEpoch(info.repeatExpiresAt);
    if (info.pushSinglecast != null && info.pushSinglecast.length > 0)
      this.pushSinglecast = info.pushSinglecast;
    if (info.publishPolicy != null) {
      try {
        this.publishPolicy = stringToEnum(
            PublishPolicyEnum.values, info.publishPolicy.toUpperCase());
      } catch (e) {
        this.publishPolicy = PublishPolicyEnum.BOTH;
      }
    }
  }

  @override
  String toString() =>
      """DeliveryOptions{pushBroadcast=$pushBroadcast, pushSinglecast=$pushSinglecast, publishPolicy=$publishPolicy, 
    publishAt=$publishAt, repeatEvery=$repeatEvery, repeatExpiresAt=$repeatExpiresAt}""";
}

class PublishMessageInfo {
  String messageId;
  int timestamp;
  Object message;
  String publisherId;
  String subtopic;
  List<String> pushSinglecast;
  String pushBroadcast;
  String publishPolicy;
  String query;
  int publishAt;
  int repeatEvery;
  int repeatExpiresAt;
  Map<String, String> headers = new Map();

  PublishMessageInfo();

  PublishMessageInfo.fromJson(Map json) {
    messageId = json['messageId'];
    timestamp = json['timestamp'];
    message = json['message'];
    publisherId = json['publisherId'];
    subtopic = json['subtopic'];
    pushSinglecast = json['pushSinglecast']?.cast<String>();
    pushBroadcast = json['pushBroadcast'];
    publishPolicy = json['publishPolicy'];
    query = json['query'];
    publishAt = json['publishAt'];
    repeatEvery = json['repeatEvery'];
    repeatExpiresAt = json['repeatExpiresAt'];
    headers = json['headers'].cast<String, String>();
  }

  Map toJson() => {
        'messageId': messageId,
        'timestamp': timestamp,
        'message': message,
        'publisherId': publisherId,
        'subtopic': subtopic,
        'pushSinglecast': pushSinglecast,
        'pushBroadcast': pushBroadcast,
        'publishPolicy': publishPolicy,
        'query': query,
        'publishAt': publishAt,
        'repeatEvery': repeatEvery,
        'repeatExpiresAt': repeatExpiresAt,
        'headers': headers,
      };
}

class PushBroadcastMask {
  static const int IOS = 1;
  static const int ANDROID = 2;
  static const int WP = 4;
  static const int OSX = 8;
  static const int ALL = 15;

  static int toIntMask(String pushBroadcast) {
    if (pushBroadcast == null) {
      return 0;
    } else {
      pushBroadcast = pushBroadcast.toUpperCase();
      List<String> tokens = pushBroadcast.split("| ");
      int maskedValue = 0;

      for (String token in tokens) {
        if ("IOS" == token) {
          maskedValue |= 1;
        } else if ("ANDROID" == token) {
          maskedValue |= 2;
        } else if ("WP" == token) {
          maskedValue |= 4;
        } else if ("OSX" == token) {
          maskedValue |= 8;
        } else if ("ALL" == token) {
          maskedValue |= 15;
        }
      }
      return maskedValue;
    }
  }
}

enum PublishPolicyEnum { PUSH, PUBSUB, BOTH }
