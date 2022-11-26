part of backendless_sdk;

class PublishMessageInfo {
  String? messageId;
  int? timestamp;
  Object? message;
  String? publisherId;
  String? subtopic;
  List<String>? pushSinglecast;
  String? pushBroadcast;
  String? publishPolicy;
  String? query;
  int? publishAt;
  int? repeatEvery;
  int? repeatExpiresAt;
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