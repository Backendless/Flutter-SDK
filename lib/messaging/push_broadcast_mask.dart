// ignore_for_file: constant_identifier_names

part of backendless_sdk;

class PushBroadcastMask {
  static const int IOS = 1;
  static const ANDROID = 2;
  static const int WP = 4;
  static const int OSX = 8;
  static const int ALL = 15;

  static int toIntMask(String? pushBroadcast) {
    if (pushBroadcast == null) {
      return 0;
    } else {
      pushBroadcast = pushBroadcast.toUpperCase();
      List<String> tokens = pushBroadcast.split("| ");
      int maskedValue = 0;

      for (String token in tokens) {
        if ("IOS" == token) {
          maskedValue |= 1;
        } else if ("ANDROID" == token) {
          maskedValue |= 2;
        } else if ("WP" == token) {
          maskedValue |= 4;
        } else if ("OSX" == token) {
          maskedValue |= 8;
        } else if ("ALL" == token) {
          maskedValue |= 15;
        }
      }
      return maskedValue;
    }
  }
}
