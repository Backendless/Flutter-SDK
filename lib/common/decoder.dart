part of backendless_sdk;

class Decoder {
  T? decode<T>(dynamic obj) {
    if (obj is T)
      return obj;
    else if (obj is List<dynamic>)
      return obj.map((e) => e as Map).toList() as T;
    else
      return reflector.deserialize<T>(obj);
  }
}
