part of backendless_sdk;

enum OperationType {
  CREATE,
  CREATE_BULK,
  UPDATE,
  UPDATE_BULK,
  DELETE,
  DELETE_BULK,
  FIND,
  ADD_RELATION,
  SET_RELATION,
  DELETE_RELATION
}

extension OperationTypeExt on OperationType {
  String get operationName => const {
        OperationType.CREATE: "create",
        OperationType.CREATE_BULK: "createBulk",
        OperationType.UPDATE: "update",
        OperationType.UPDATE_BULK: "updateBulk",
        OperationType.DELETE: "delete",
        OperationType.DELETE_BULK: "deleteBulk",
        OperationType.FIND: "find",
        OperationType.ADD_RELATION: "addToRelation",
        OperationType.SET_RELATION: "setRelation",
        OperationType.DELETE_RELATION: "deleteRelation",
      }[this];

  static final List<OperationType> supportCollectionEntityDescriptionType =
      List.unmodifiable([OperationType.FIND]);

  static final List<OperationType> supportListIdsResultType =
      List.unmodifiable([OperationType.CREATE_BULK]);

  static final List<OperationType> supportIntResultType = List.unmodifiable([
    OperationType.UPDATE_BULK,
    OperationType.DELETE_BULK,
    OperationType.ADD_RELATION,
    OperationType.SET_RELATION,
    OperationType.DELETE_RELATION
  ]);

  static final List<OperationType> supportDeletionResultType =
      List.unmodifiable([OperationType.DELETE]);

  static final List<OperationType> supportEntityDescriptionResultType =
      List.unmodifiable([OperationType.CREATE, OperationType.UPDATE]);
}
