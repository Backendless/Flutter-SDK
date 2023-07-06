part of backendless_sdk;

enum HeadersEnum {
  userToken,
  loggedIn,
  sessionTimeOut,
  appType,
  apiVersion,
  uiState
}

extension HeadersEnumExt on HeadersEnum {
  String get header => const {
        HeadersEnum.userToken: 'user-token',
        HeadersEnum.loggedIn: "logged-in",
        HeadersEnum.sessionTimeOut: "session-time-out",
        HeadersEnum.appType: "application-type",
        HeadersEnum.apiVersion: "api-version",
        HeadersEnum.uiState: "uiState",
      }[this]!;
}
