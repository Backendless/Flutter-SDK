part of backendless_sdk;

typedef ListBackendlessUser = List<BackendlessUser>?;

class Decoder {
  T? decode<T>(dynamic obj) {
    if (obj is T) return obj;
    if (isSubTypeOf<List<BackendlessUser>?, T>()) {
      List<BackendlessUser>? listUsers = [];
      (obj as List).forEach((element) {
        listUsers.add(decode<BackendlessUser>(element)!);
      });
      return listUsers as T;
    }
    if (isSubTypeOf<List<UserProperty>, T>()) {
      List<UserProperty> listProperties = [];
      (obj as List).forEach((element) {
        listProperties.add(decode<UserProperty>(element)!);
      });
      return listProperties as T;
    }
    if (obj is List<dynamic>) return obj.map((e) => e as Map).toList() as T;
    if (isSubTypeOf<DateTime, T>()) {
      return reflector._deserializeDateTime(obj) as T;
    } else {
      return reflector.deserialize<T>(obj);
    }
  }
}

bool isSubTypeOf<S, T>() => S == T;
