part of backendless_sdk;

class Command<T> {
  Type dataType;
  String type;
  T data;
  UserInfo userInfo;

  Command._(this.dataType);

  Command.string() : this._(String);

  Command.map() : this._(Map);

  Command.fromJson(Map json)
      : type = json['type'],
        data = json['data'],
        userInfo = UserInfo.fromJson(json['userInfo']);

  Map toJson() => {
        'type': type,
        'data': data,
        'userInfo': userInfo,
      };

  @override
  String toString() =>
      "RTCommand{dataType=$dataType, type='$type', data=$data, userInfo=$userInfo}";
}
