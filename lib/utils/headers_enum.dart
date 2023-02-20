part of backendless_sdk;

enum HeadersEnum {
  USER_TOKEN,
  LOGGED_IN,
  SESSION_TIME_OUT,
  APP_TYPE,
  API_VERSION,
  UI_STATE
}

extension HeadersEnumExt on HeadersEnum {
  String get header => const {
        HeadersEnum.USER_TOKEN: 'user-token',
        HeadersEnum.LOGGED_IN: "logged-in",
        HeadersEnum.SESSION_TIME_OUT: "session-time-out",
        HeadersEnum.APP_TYPE: "application-type",
        HeadersEnum.API_VERSION: "api-version",
        HeadersEnum.UI_STATE: "uiState",
      }[this]!;
}
