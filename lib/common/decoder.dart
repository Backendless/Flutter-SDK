part of backendless_sdk;

class Decoder {
  T? decode<T>(dynamic obj) {
    if (obj is T)
      return obj;
    else
      return reflector.deserialize<T>(obj);
  }
}
