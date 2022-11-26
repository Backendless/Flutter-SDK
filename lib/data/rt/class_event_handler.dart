part of backendless_sdk;

class ClassEventHandler<T> implements IEventHandler<T> {
  late String _tableName;
  static String _rtUrl = '';

  ClassEventHandler() {
    _tableName = reflector.getServerName(T)!;
  }

  static Future<void> initialize() async {
    _rtUrl = (await RTLookupService.lookup())!;
  }

  @override
  void addConnectListener(void Function() callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        RTListener.connectionHandler(callback);
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addCreateListener(void Function(T? response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      print('classEvent: ' + (T).toString());
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.CREATED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addUpdateListener(void Function(T? response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      print('classEvent: ' + (T).toString());
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.UPDATED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addUpsertListener(void Function(T? response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      print('classEvent: ' + (T).toString());
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.UPSERTED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addDeleteListener(void Function(T? response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      print('classEvent: ' + (T).toString());
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.DELETED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
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
