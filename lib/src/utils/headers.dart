part of backendless_sdk;

enum HeadersEnum {
  USER_TOKEN_KEY,
  LOGGED_IN_KEY,
  SESSION_TIME_OUT_KEY,
  APP_TYPE_NAME,
  API_VERSION,
  UI_STATE
}

extension HeadersEnumExt on HeadersEnum {
  String? get header => const {
        HeadersEnum.USER_TOKEN_KEY: "user-token",
        HeadersEnum.LOGGED_IN_KEY: "logged-in",
        HeadersEnum.SESSION_TIME_OUT_KEY: "session-time-out",
        HeadersEnum.APP_TYPE_NAME: "application-type",
        HeadersEnum.API_VERSION: "api-version",
        HeadersEnum.UI_STATE: "uiState",
      }[this];
}
