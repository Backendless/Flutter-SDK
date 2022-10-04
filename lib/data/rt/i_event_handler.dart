part of backendless_sdk;

abstract class IEventHandler<T> {
  void addCreateListener(void Function(T? response) callback,
      {void onError(String error)?, String? whereClause});

  void addUpdateListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addUpsertListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addDeleteListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addBulkCreateListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addBulkUpdateListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addBulkUpsertListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addBulkDeleteListener(void Function(dynamic response) callback,
      {void onError(String error)?, String? whereClause});

  void addSetRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void onError(String error)?,
      String? whereClause});

  void addAddRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void onError(String error)?,
      String? whereClause});

  void addDeleteRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void onError(String error)?,
      String? whereClause});

  void addConnectListener(void Function() callback,
      {void onError(String error)?, String? whereClause});

  void addDisconnectListener(void Function() callback,
      {void onError(String error)?, String? whereClause});

  void removeCreateListeners({String? whereClause});

  void removeUpdateListeners({String? whereClause});

  void removeUpsertListeners({String? whereClause});

  void removeDeleteListeners({String? whereClause});

  void removeBulkCreateListeners({String? whereClause});

  void removeBulkUpdateListeners({String? whereClause});

  void removeBulkUpsertListeners({String? whereClause});

  void removeBulkDeleteListeners({String? whereClause});

  void removeSetRelationListeners({String? whereClause});

  void removeAddRelationListeners({String? whereClause});

  void removeDeleteRelationListeners({String? whereClause});
}
