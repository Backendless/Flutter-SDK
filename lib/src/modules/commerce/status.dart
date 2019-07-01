part of backendless_sdk;

class GooglePlaySubscriptionStatus {
  bool autoRenewing;
  int startTimeMillis;
  String kind;
  int expiryTimeMillis;

  GooglePlaySubscriptionStatus();

  GooglePlaySubscriptionStatus.fromJson(Map json)
      : autoRenewing = json['autoRenewing'],
        startTimeMillis = json['startTimeMillis'],
        kind = json['kind'],
        expiryTimeMillis = json['expiryTimeMillis'];

  Map toJson() => {
        'autoRenewing': autoRenewing,
        'startTimeMillis': startTimeMillis,
        'kind': kind,
        'expiryTimeMillis': expiryTimeMillis,
      };
}

class GooglePlayPurchaseStatus {
  String kind;
  int purchaseTimeMillis;
  int purchaseState;
  int consumptionState;
  String developerPayload;

  GooglePlayPurchaseStatus();

  GooglePlayPurchaseStatus.fromJson(Map json)
      : kind = json['kind'],
        purchaseTimeMillis = json['purchaseTimeMillis'],
        purchaseState = json['purchaseState'],
        consumptionState = json['consumptionState'],
        developerPayload = json['developerPayload'];

  Map toJson() => {
        'kind': kind,
        'purchaseTimeMillis': purchaseTimeMillis,
        'purchaseState': purchaseState,
        'consumptionState': consumptionState,
        'developerPayload': developerPayload,
      };
}
