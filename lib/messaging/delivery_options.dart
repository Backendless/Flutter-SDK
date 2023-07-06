part of backendless_sdk;

class DeliveryOptions {
  int? pushBroadcast;
  List<String> pushSinglecast = [];
  String? segmentQuery;
  PublishPolicyEnum? publishPolicy = PublishPolicyEnum.both;
  DateTime? publishAt;
  int? repeatEvery;
  DateTime? repeatExpiresAt;

  DeliveryOptions();

  DeliveryOptions.fromJson(Map json)
      : pushBroadcast = json['pushBroadcast'],
        pushSinglecast = json['pushSinglecast'].cast<String>(),
        segmentQuery = json['segmentQuery'],
        publishPolicy = PublishPolicyEnum.values[json['publishPolicy']],
        publishAt = json['publishAt'] is int
            ? DateTime.fromMillisecondsSinceEpoch(json['publishAt'])
            : json['publishAt'],
        repeatEvery = json['repeatEvery'],
        repeatExpiresAt = json['repeatExpiresAt'] is int
            ? DateTime.fromMillisecondsSinceEpoch(json['repeatExpiresAt'])
            : json['repeatExpiresAt'];

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
    publishPolicy = PublishPolicyEnum.both;
    pushBroadcast = PushBroadcastMask.toIntMask(info.pushBroadcast);
    segmentQuery = info.query;
    if (info.publishAt! > 0) {
      publishAt = DateTime.fromMillisecondsSinceEpoch(info.publishAt!);
    }
    if (info.repeatEvery! > 0) repeatEvery = info.repeatEvery;
    if (info.repeatExpiresAt! > 0) {
      repeatExpiresAt =
          DateTime.fromMillisecondsSinceEpoch(info.repeatExpiresAt!);
    }
    if (info.pushSinglecast != null && info.pushSinglecast!.isNotEmpty) {
      pushSinglecast = info.pushSinglecast!;
    }
    if (info.publishPolicy != null) {
      try {
        publishPolicy = stringToEnum(
            PublishPolicyEnum.values, info.publishPolicy!.toUpperCase());
      } catch (e) {
        publishPolicy = PublishPolicyEnum.both;
      }
    }
  }

  @override
  String toString() =>
      """DeliveryOptions{pushBroadcast=$pushBroadcast, pushSinglecast=$pushSinglecast, publishPolicy=$publishPolicy, 
    publishAt=$publishAt, repeatEvery=$repeatEvery, repeatExpiresAt=$repeatExpiresAt}""";
}

enum PublishPolicyEnum { push, pubsub, both }
