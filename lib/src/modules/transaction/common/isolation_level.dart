part of backendless_sdk;

enum IsolationLevelEnum {
  READ_UNCOMMITTED,
  READ_COMMITTED,
  REPEATABLE_READ,
  SERIALIZABLE
}

extension IsolationLevelExt on IsolationLevelEnum {
  int get operationId => const {
    IsolationLevelEnum.READ_UNCOMMITTED: 1,
    IsolationLevelEnum.READ_COMMITTED: 2,
    IsolationLevelEnum.REPEATABLE_READ: 4,
    IsolationLevelEnum.SERIALIZABLE: 8,
  }[this];
}