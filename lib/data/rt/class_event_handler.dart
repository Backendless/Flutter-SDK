part of backendless_sdk;

class ClassEventHandler<E> implements IEventHandler<E> {
  late String _tableName;
  static String _rtUrl = '';

  ClassEventHandler() {
    _tableName = reflector.getServerName(E)!;
  }

  static Future<void> initialize() async {
    _rtUrl = (await RTLookupService.lookup())!;
  }

  @override
  void addAddRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void Function(String error)? onError,
      String? whereClause}) {
    // TODO: implement addAddRelationListener
  }

  @override
  void addBulkCreateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addBulkCreateListener
  }

  @override
  void addBulkDeleteListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addBulkDeleteListener
  }

  @override
  void addBulkUpdateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addBulkUpdateListener
  }

  @override
  void addBulkUpsertListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addBulkUpsertListener
  }

  @override
  void addConnectListener(void Function() callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addConnectListener
  }

  @override
  void addCreateListener(void Function(E response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addCreateListener
  }

  @override
  void addDeleteListener(void Function(E response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addDeleteListener
  }

  @override
  void addDeleteRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void Function(String error)? onError,
      String? whereClause}) {
    // TODO: implement addDeleteRelationListener
  }

  @override
  void addDisconnectListener(void Function() callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addDisconnectListener
  }

  @override
  void addSetRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void Function(String error)? onError,
      String? whereClause}) {
    // TODO: implement addSetRelationListener
  }

  @override
  void addUpdateListener(void Function(E response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addUpdateListener
  }

  @override
  void addUpsertListener(void Function(E response) callback,
      {void Function(String error)? onError, String? whereClause}) {
    // TODO: implement addUpsertListener
  }

  @override
  void removeAddRelationListeners({String? whereClause}) {
    // TODO: implement removeAddRelationListeners
  }

  @override
  void removeBulkCreateListeners({String? whereClause}) {
    // TODO: implement removeBulkCreateListeners
  }

  @override
  void removeBulkDeleteListeners({String? whereClause}) {
    // TODO: implement removeBulkDeleteListeners
  }

  @override
  void removeBulkUpdateListeners({String? whereClause}) {
    // TODO: implement removeBulkUpdateListeners
  }

  @override
  void removeBulkUpsertListeners({String? whereClause}) {
    // TODO: implement removeBulkUpsertListeners
  }

  @override
  void removeCreateListeners({String? whereClause}) {
    // TODO: implement removeCreateListeners
  }

  @override
  void removeDeleteListeners({String? whereClause}) {
    // TODO: implement removeDeleteListeners
  }

  @override
  void removeDeleteRelationListeners({String? whereClause}) {
    // TODO: implement removeDeleteRelationListeners
  }

  @override
  void removeSetRelationListeners({String? whereClause}) {
    // TODO: implement removeSetRelationListeners
  }

  @override
  void removeUpdateListeners({String? whereClause}) {
    // TODO: implement removeUpdateListeners
  }

  @override
  void removeUpsertListeners({String? whereClause}) {
    // TODO: implement removeUpsertListeners
  }
}
