part of backendless_sdk;

class UserStatusResponse {
  UserStatus status;
  List<UserInfo> data;

  UserStatusResponse();

  UserStatusResponse.fromJson(Map json) {
    status = UserStatus.values[json['status']];
    List<UserInfo> userInfos = List();
    json['data'].forEach((json) => userInfos.add(UserInfo.fromJson(json)));
    data = userInfos;
  }

  Map toJson() =>
    {
      'status': status?.index,
      'data': data,
    };

  @override
  String toString() => "UserStatusResponse{status=$status, data=$data}";
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

enum UserStatus { LISTING, CONNECTED, DISCONNECTED, USERUPDATE }