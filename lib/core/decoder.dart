part of backendless_sdk;

typedef ListBackendlessUser = List<BackendlessUser>?;

class Decoder {
  T? decode<T>(dynamic obj) {
    if (obj is T) {
      return obj;
    }
    if (isSubTypeOf<List<BackendlessUser>?, T>()) {
      List<BackendlessUser>? listUsers = [];
      for (var element in (obj as List)) {
        listUsers.add(decode<BackendlessUser>(element)!);
      }
      return listUsers as T;
    }
    if (isSubTypeOf<List<UserProperty>, T>()) {
      List<UserProperty> listProperties = [];
      for (var element in (obj as List)) {
        listProperties.add(decode<UserProperty>(element)!);
      }
      return listProperties as T;
    }
    if (obj is List<dynamic>) {
      if (isSubTypeOf2<String, T>()) {
        return obj.map((e) => e as String).toList() as T;
      } else if (isSubTypeOf2<int, T>()) {
        return obj.map((e) => e as int).toList() as T;
      } else if (isSubTypeOf2<double, T>()) {
        return obj.map((e) => e as double).toList() as T;
      } else if (isSubTypeOf2<bool, T>()) {
        return obj.map((e) => e as bool).toList() as T;
      }

      return obj.map((e) => e as Map).toList() as T;
    }
    if (isSubTypeOf<DateTime, T>()) {
      return reflector._deserializeDateTime(obj) as T;
    } else {
      return reflector.deserialize<T>(obj);
    }
  }
}

bool isSubTypeOf<S, T>() => S == T;

bool isSubTypeOf2<S, T>() => <S>[] is T;
