part of backendless_sdk;

abstract class IEventHandler<T> {
  void addCreateListener(void Function(T? response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addUpdateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addUpsertListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addDeleteListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addBulkCreateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addBulkUpdateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addBulkUpsertListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addBulkDeleteListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause});

  void addSetRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void Function(String error)? onError,
      String? whereClause});

  void addAddRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void Function(String error)? onError,
      String? whereClause});

  void addDeleteRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void Function(String error)? onError,
      String? whereClause});

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
