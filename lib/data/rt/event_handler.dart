part of backendless_sdk;

class EventHandler<T> implements IEventHandler<T> {
  String _tableName;
  static String _rtUrl = '';

  EventHandler(this._tableName);

  @override
  void addCreateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.CREATED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addUpdateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.UPDATED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addUpsertListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.UPSERTED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addDeleteListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.DELETED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addBulkCreateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.BULK_CREATED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addBulkUpdateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.BULK_UPDATED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addBulkUpsertListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.BULK_UPSERTED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addBulkDeleteListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      await RTListener.subscribeForObjectsChanges(
          RTEventHandlers.BULK_DELETED.toShortString(), _tableName, callback,
          whereClause: whereClause);
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addConnectListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      RTClient.instance.connectSocket(() => callback.call());
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
  }

  @override
  void addDisconnectListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

    if (_rtUrl.isNotEmpty)
      RTClient.instance.streamController.listen((event) => callback.call());
    else {
      print('empty url');
      throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
    }
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
  void removeUpdateListeners({String? whereClause}) {
    // TODO: implement removeUpdateListeners
  }

  @override
  void removeUpsertListeners({String? whereClause}) {
    // TODO: implement removeUpsertListeners
  }
}
