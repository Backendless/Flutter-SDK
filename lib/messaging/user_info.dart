part of backendless_sdk;

class UserInfo {
  String? connectionId;
  String? userId;

  UserInfo();

  UserInfo.fromJson(Map json)
      : connectionId = json['connectionId'],
        userId = json['userId'];

  Map toJson() => {
        'connectionId': connectionId,
        'userId': userId,
      };

  @override
  String toString() =>
      "UserInfo{connectionId='$connectionId', userId='$userId'}";
}
