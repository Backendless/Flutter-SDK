part of backendless_sdk;

class UserStatusResponse {
  UserStatus? status;
  List<UserInfo>? data;

  UserStatusResponse();

  UserStatusResponse.fromJson(Map json) {
    status = UserStatus.values[json['status']];
    List<UserInfo> userInfos = [];
    json['data'].forEach((json) => userInfos.add(UserInfo.fromJson(json)));
    data = userInfos;
  }

  Map toJson() {
    List<Map> userInfos = [];
    data?.forEach((userInfo) => userInfos.add(userInfo.toJson()));
    return {
      'status': status?.index,
      'data': userInfos,
    };
  }

  @override
  String toString() => "UserStatusResponse{status=$status, data=$data}";
}
