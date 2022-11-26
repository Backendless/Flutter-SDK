part of backendless_sdk;

class DeliveryOptions {
  int? pushBroadcast;
  List<String> pushSinglecast = [];
  String? segmentQuery;
  PublishPolicyEnum? publishPolicy = PublishPolicyEnum.BOTH;
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
    this.publishPolicy = PublishPolicyEnum.BOTH;
    this.pushBroadcast = PushBroadcastMask.toIntMask(info.pushBroadcast);
    this.segmentQuery = info.query;
    if (info.publishAt! > 0)
      this.publishAt = new DateTime.fromMillisecondsSinceEpoch(info.publishAt!);
    if (info.repeatEvery! > 0) this.repeatEvery = info.repeatEvery;
    if (info.repeatExpiresAt! > 0)
      this.repeatExpiresAt =
          new DateTime.fromMillisecondsSinceEpoch(info.repeatExpiresAt!);
    if (info.pushSinglecast != null && info.pushSinglecast!.length > 0)
      this.pushSinglecast = info.pushSinglecast!;
    if (info.publishPolicy != null) {
      try {
        this.publishPolicy = stringToEnum(
            PublishPolicyEnum.values, info.publishPolicy!.toUpperCase());
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

enum PublishPolicyEnum { PUSH, PUBSUB, BOTH }
