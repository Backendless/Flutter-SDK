import 'dart:async';
import 'dart:ui' show hashValues;

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/utils/utils.dart';

class BackendlessMessaging {
  static const String DEFAULT_CHANNEL_NAME = "default";
  static const MethodChannel _channel = const MethodChannel(
      'backendless/messaging', StandardMethodCodec(BackendlessMessageCodec()));
  static final Map<int, EventCallback> _joinCallbacks = <int, EventCallback>{};
  static final Map<int, EventCallback> _messageCallbacks =
      <int, EventCallback>{};
  static final Map<int, EventCallback> _commandCallbacks =
      <int, EventCallback>{};
  static final Map<int, EventCallback> _userStatusCallbacks =
      <int, EventCallback>{};
  int _channelHandle = 0;

  factory BackendlessMessaging() => _instance;
  static final BackendlessMessaging _instance =
      new BackendlessMessaging._internal();

  BackendlessMessaging._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method.contains("EventResponse")) {
        Map<dynamic, dynamic> arguments = call.arguments;
        int handle = arguments["handle"];
        var response = arguments["response"];

        switch (call.method) {
          case ("Backendless.Messaging.Channel.Join.EventResponse"):
            _joinCallbacks[handle].handleResponse();
            break;
          case ("Backendless.Messaging.Channel.Message.EventResponse"):
            _messageCallbacks[handle].handleResponse(response);
            break;
          case ("Backendless.Messaging.Channel.Command.EventResponse"):
            _commandCallbacks[handle].handleResponse(response);
            break;
          case ("Backendless.Messaging.Channel.UserStatus.EventResponse"):
            _userStatusCallbacks[handle].handleResponse(response);
            break;
        }
      } else if (call.method.contains("EventFault")) {
        int handle = call.arguments["handle"];
        String fault = call.arguments["fault"];

        switch (call.method) {
          case ("Backendless.Messaging.Channel.Join.EventFault"):
            _joinCallbacks[handle].handleFault(fault);
            break;
          case ("Backendless.Messaging.Channel.Message.EventFault"):
            _messageCallbacks[handle].handleFault(fault);
            break;
          case ("Backendless.Messaging.Channel.Command.EventFault"):
            _commandCallbacks[handle].handleFault(fault);
            break;
          case ("Backendless.Messaging.Channel.UserStatus.EventFault"):
            _userStatusCallbacks[handle].handleFault(fault);
            break;
        }
      }
    });
  }

  Future<MessageStatus> cancel(String messageId) => _channel.invokeMethod(
      "Backendless.Messaging.cancel",
      <String, dynamic>{"messageId": messageId});

  Future<DeviceRegistration> getDeviceRegistration() =>
      _channel.invokeMethod("Backendless.Messaging.getDeviceRegistration");

  Future<MessageStatus> getMessageStatus(String messageId) =>
      _channel.invokeMethod("Backendless.Messaging.getMessageStatus",
          <String, dynamic>{"messageId": messageId});

  Future<MessageStatus> publish(Object message,
      {String channelName,
      PublishOptions publishOptions,
      DeliveryOptions deliveryOptions}) {
    if (deliveryOptions != null && publishOptions == null)
      throw new ArgumentError(
          "Argument 'deliveryOptions' should be defined with argument 'publishOptions'");
    return _channel
        .invokeMethod("Backendless.Messaging.publish", <String, dynamic>{
      "message": message,
      "channelName": channelName,
      "publishOptions": publishOptions,
      "deliveryOptions": deliveryOptions
    });
  }

  Future<MessageStatus> pushWithTemplate(String templateName) =>
      _channel.invokeMethod("Backendless.Messaging.pushWithTemplate",
          <String, dynamic>{"templateName": templateName});

  Future<DeviceRegistrationResult> registerDevice(
          [List<String> channels, DateTime expiration]) =>
      _channel.invokeMethod("Backendless.Messaging.registerDevice",
          <String, dynamic>{"channels": channels, "expiration": expiration});

  Future<MessageStatus> sendEmail(
          String subject, BodyParts bodyParts, List<String> recipients,
          [List<String> attachments]) =>
      _channel
          .invokeMethod("Backendless.Messaging.sendEmail", <String, dynamic>{
        "textMessage": bodyParts.textMessage,
        "htmlMessage": bodyParts.htmlMessage,
        "subject": subject,
        "recipients": recipients,
        "attachments": attachments
      });

  Future<MessageStatus> sendHTMLEmail(
          String subject, String messageBody, List<String> recipients) =>
      _channel.invokeMethod(
          "Backendless.Messaging.sendHTMLEmail", <String, dynamic>{
        "subject": subject,
        "messageBody": messageBody,
        "recipients": recipients
      });

  Future<MessageStatus> sendTextEmail(
          String subject, String messageBody, List<String> recipients) =>
      _channel.invokeMethod(
          "Backendless.Messaging.sendTextEmail", <String, dynamic>{
        "subject": subject,
        "messageBody": messageBody,
        "recipients": recipients
      });

  Future<int> unregisterDevice([List<String> channels]) =>
      _channel.invokeMethod("Backendless.Messaging.unregisterDevice",
          <String, dynamic>{"channels": channels});

  Future<Channel> subscribe([String channelName = DEFAULT_CHANNEL_NAME]) async {
    int handle = _channelHandle++;
    return _channel.invokeMethod(
        "Backendless.Messaging.subscribe", <String, dynamic>{
      "channelName": channelName,
      "channelHandle": handle
    }).then((value) => new Channel(_channel, channelName, handle));
  }
}

class Channel {
  final MethodChannel _methodChannel;
  final String channelName;
  final int _channelHandle;

  Channel(this._methodChannel, this.channelName, this._channelHandle);

  Future<void> join() => _methodChannel.invokeMethod(
      "Backendless.Messaging.Channel.join",
      <String, dynamic>{"channelHandle": _channelHandle});

  Future<void> leave() => _methodChannel.invokeMethod(
      "Backendless.Messaging.Channel.leave",
      <String, dynamic>{"channelHandle": _channelHandle});

  Future<bool> isJoined() => _methodChannel.invokeMethod(
      "Backendless.Messaging.Channel.isJoined",
      <String, dynamic>{"channelHandle": _channelHandle});

  Future<void> addJoinListener(Function callback,
          {void onError(String error)}) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.addJoinListener", {
        "channelHandle": _channelHandle
      }).then((handle) => BackendlessMessaging._joinCallbacks[handle] =
          new EventCallback(callback, onError));

  void removeJoinListener(Function callback) {
    List<int> handles = _findCallbacks(BackendlessMessaging._joinCallbacks,
        (eventCallback) => eventCallback.handleResponse == callback);

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeJoinListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._joinCallbacks.remove(handle);
    });
  }

  Future<void> addMessageListener<T>(void callback(T response),
      {void onError(String error), String selector}) {
    if (T != String && T != PublishMessageInfo)
      throw UnimplementedError(); // Custom type message

    Map<String, dynamic> args = {
      "selector": selector,
      "messageType": T.toString()
    };
    return _methodChannel
        .invokeMethod("Backendless.Messaging.Channel.addMessageListener",
            <String, dynamic>{"channelHandle": _channelHandle}..addAll(args))
        .then((handle) => BackendlessMessaging._messageCallbacks[handle] =
            new EventCallback(callback, onError, args));
  }

  void removeMessageListeners({String selector, Function callback}) {
    List<int> handles = _findCallbacks(
        BackendlessMessaging._messageCallbacks,
        (eventCallback) => ((selector == null ||
                selector == eventCallback.args["selector"]) &&
            (callback == null || callback == eventCallback.handleResponse)));

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeMessageListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._messageCallbacks.remove(handle);
    });
  }

  void removeAllMessageListeners() {
    BackendlessMessaging._messageCallbacks.clear();
    _methodChannel.invokeMethod(
        "Backendless.Messaging.Channel.removeAllMessageListeners",
        <String, dynamic>{
          "channelHandle": _channelHandle,
        });
  }

  Future<void> addCommandListener(void callback(Command<String> response),
          {void onError(String error)}) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.addCommandListener", {
        "channelHandle": _channelHandle
      }).then((handle) => BackendlessMessaging._commandCallbacks[handle] =
          new EventCallback(callback, onError));

  void removeCommandListener(Function callback) {
    List<int> handles = _findCallbacks(BackendlessMessaging._commandCallbacks,
        (eventCallback) => eventCallback.handleResponse == callback);

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeCommandListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._commandCallbacks.remove(handle);
    });
  }

  Future<void> sendCommand(String type, Object data) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.sendCommand", <String, dynamic>{
        "channelHandle": _channelHandle,
        "type": type,
        "data": data
      });

  Future<void> addUserStatusListener(void callback(UserStatusResponse response),
          {void onError(String error)}) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.addUserStatusListener", {
        "channelHandle": _channelHandle
      }).then((handle) => BackendlessMessaging._userStatusCallbacks[handle] =
          new EventCallback(callback, onError));

  void removeUserStatusListener(Function callback) {
    List<int> handles = _findCallbacks(
        BackendlessMessaging._userStatusCallbacks,
        (eventCallback) => eventCallback.handleResponse == callback);

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeUserStatusListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._userStatusCallbacks.remove(handle);
    });
  }

  void removeUserStatusListeners() {
    BackendlessMessaging._userStatusCallbacks.clear();
    _methodChannel.invokeMethod(
        "Backendless.Messaging.Channel.removeUserStatusListeners",
        <String, dynamic>{
          "channelHandle": _channelHandle,
        });
  }

  List<int> _findCallbacks(Map<int, EventCallback> callbacks,
      bool test(EventCallback eventCallback)) {
    List<int> toRemove = [];
    callbacks.forEach((handle, callback) {
      if (test(callback)) {
        toRemove.add(handle);
      }
    });
    return toRemove;
  }
}

class MessageStatus implements Comparable<MessageStatus> {
  String messageId;
  String errorMessage;
  PublishStatusEnum status;

  MessageStatus();

  MessageStatus.fromJson(Map json) : 
    messageId = json['messageId'],
    errorMessage = json['errorMessage'],
    status = PublishStatusEnum.values[json['status']];

  Map toJson() =>
    {
      'messageId': messageId,
      'errorMessage': errorMessage,
      'status': status?.index,
    };

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is MessageStatus &&
          runtimeType == other.runtimeType &&
          this.messageId == other.messageId &&
          this.status == other.status;

  @override
  int get hashCode => hashValues(messageId, status);

  @override
  String toString() =>
      "MessageStatus{messageId='$messageId', status='$status'}";

  @override
  int compareTo(MessageStatus other) {
    if (this == other) {
      return 0;
    } else {
      int statusDiff = this.status == null
          ? (other.status == null ? 0 : -1)
          : this.status.index.compareTo(other.status.index);
      if (statusDiff != 0) {
        return statusDiff;
      } else {
        return this.messageId == null
            ? (other.messageId == null ? 0 : -1)
            : this.messageId.compareTo(other.messageId);
      }
    }
  }
}

class DeviceRegistration {
  String id = "";
  String deviceToken = "";
  String deviceId = "";
  String os;
  String osVersion;
  DateTime expiration;
  List<String> channels = new List<String>();

  DeviceRegistration();

  DeviceRegistration.fromJson(Map json) : 
    id = json['id'],
    deviceToken = json['deviceToken'],
    deviceId = json['deviceId'],
    os = json['os'],
    osVersion = json['osVersion'],
    expiration = json['expiration'],
    channels = json['channels'].cast<String>();

  Map toJson() =>
    {
      'id': id,
      'deviceToken': deviceToken,
      'deviceId': deviceId,
      'os': os,
      'osVersion': osVersion,
      'expiration': expiration,
      'channels': channels,
    };
}

/// Message class does not support passing custom classes to 'data' for now
class Message {
  String messageId;
  Map<String, String> headers;
  Object data;
  String publisherId;
  int timestamp;

  Message();

  Message.fromJson(Map json) : 
    messageId = json['messageId'],
    headers = json['headers'].cast<String, String>(),
    data = json['data'],
    publisherId = json['publisherId'],
    timestamp = json['timestamp'];

  Map toJson() =>
    {
      'messageId': messageId,
      'headers': headers,
      'data': data,
      'publisherId': publisherId,
      'timestamp': timestamp,
    };

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Message &&
          this.runtimeType == other.runtimeType &&
          this.messageId == other.messageId &&
          MapEquality().equals(this.headers, other.headers) &&
          this.data == other.data &&
          this.publisherId == other.publisherId &&
          this.timestamp == other.timestamp;

  @override
  int get hashCode =>
      hashValues(messageId, headers, data, publisherId, timestamp);

  @override
  String toString() =>
      "Message{messageId='$messageId', data=$data, headers=$headers, publisherId=$publisherId, timestamp=$timestamp}";
}

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

  PublishOptions.fromJson(Map json) : 
    publisherId = json['publisherId'],
    headers = json['headers'].cast<String, String>();

  Map toJson() =>
    {
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

  DeliveryOptions.fromJson(Map json) : 
    pushBroadcast = json['pushBroadcast'],
    pushSinglecast = json['pushSinglecast'].cast<String>(),
    segmentQuery = json['segmentQuery'],
    publishPolicy = PublishPolicyEnum.values[json['publishPolicy']],
    publishAt = json['publishAt'],
    repeatEvery = json['repeatEvery'],
    repeatExpiresAt = json['repeatExpiresAt'];

  Map toJson() =>
    {
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
  String _messageId;
  int _timestamp;
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
    _messageId = json['messageId'];
    _timestamp = json['timestamp'];
    message = json['message'];
    publisherId = json['publisherId'];
    subtopic = json['subtopic'];
    pushSinglecast = json['pushSinglecast'];
    pushBroadcast = json['pushBroadcast'];
    publishPolicy = json['publishPolicy'];
    query = json['query'];
    publishAt = json['publishAt'];
    repeatEvery = json['repeatEvery'];
    repeatExpiresAt = json['repeatExpiresAt'];
    headers = json['headers'];
  }

  Map toJson() =>
    {
      'messageId': _messageId,
      'timestamp': _timestamp,
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

  get messageId => _messageId;
  get timestamp => _timestamp;
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

class DeviceRegistrationResult {
  String _deviceToken;
  Map<String, String> _channelRegistrations;

  DeviceRegistrationResult();

  DeviceRegistrationResult.fromJson(Map json) {
    _deviceToken = json['deviceToken'];
    _channelRegistrations = json['channelRegistrations'];
  }

  Map toJson() =>
    {
      'deviceToken': _deviceToken,
      'channelRegistrations': _channelRegistrations,
    };

  get deviceToken => _deviceToken;
  get channelRegistrations => _channelRegistrations;

  @override
  String toString() =>
      "DeviceRegistrationResult{deviceToken='$deviceToken', channelRegistrations=$channelRegistrations}";
}

class Command<T> {
  Type dataType;
  String type;
  T data;
  UserInfo userInfo;

  Command._(this.dataType);

  Command.string() : this._(String);

  Command.map() : this._(Map);

  Command.fromJson(Map json) : 
    type = json['type'],
    data = json['data'],
    userInfo = json['userInfo'];

  Map toJson() =>
    {
      'type': type,
      'data': data,
      'userInfo': userInfo,
    };

  @override
  String toString() =>
      "RTCommand{dataType=$dataType, type='$type', data=$data, userInfo=$userInfo}";
}

class UserInfo {
  String connectionId;
  String userId;

  UserInfo();

  UserInfo.fromJson(Map json) : 
    connectionId = json['connectionId'],
    userId = json['userId'];

  Map toJson() =>
    {
      'connectionId': connectionId,
      'userId': userId,
    };

  @override
  String toString() =>
      "UserInfo{connectionId='$connectionId', userId='$userId'}";
}

class UserStatusResponse {
  UserStatus status;
  List<UserInfo> data;

  UserStatusResponse();

  UserStatusResponse.fromJson(Map json) {
    status = UserStatus.values[json['status']];
    data = json['data'];
  }

  Map toJson() =>
    {
      'status': status?.index,
      'data': data,
    };

  @override
  String toString() => "UserStatusResponse{status=$status, data=$data}";
}

class BodyParts {
  String textMessage;
  String htmlMessage;

  BodyParts(this.textMessage, this.htmlMessage);
}

enum PublishStatusEnum { FAILED, PUBLISHED, SCHEDULED, CANCELLED, UNKNOWN }

enum PublishPolicyEnum { PUSH, PUBSUB, BOTH }

enum UserStatus { LISTING, CONNECTED, DISCONNECTED, USERUPDATE }
