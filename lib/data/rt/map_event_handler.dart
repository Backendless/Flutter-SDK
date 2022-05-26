part of backendless_sdk;

class MapEventHandler<T> implements IEventHandler<T> {
  String _tableName;
  static String _rtUrl = '';

  MapEventHandler(this._tableName);

  static Future<void> initialize() async {
    _rtUrl = (await RTLookupService.lookup())!;
  }

  @override
  void addCreateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
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
  void addUpdateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
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
  void addUpsertListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
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
  void addDeleteListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
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
  void addBulkCreateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_CREATED.toShortString(), _tableName, callback,
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
  void addBulkUpdateListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_UPDATED.toShortString(), _tableName, callback,
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
  void addBulkUpsertListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_UPSERTED.toShortString(), _tableName, callback,
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
  void addBulkDeleteListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_DELETED.toShortString(), _tableName, callback,
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
  void addSetRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void onError(String error)?,
      String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        var _parentObjectIds = List.empty(growable: true);

        if (parents?.isNotEmpty ?? false)
          for (var parent in parents!) _parentObjectIds.add(parent['objectId']);

        await RTListener.subscribeForRelationsChanges(
          RTEventHandlers.SET.toShortString(),
          _tableName,
          relationColumnName,
          callback,
          parentObjectIds: parentObjectIds,
        );
      } else {
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
      void onError(String error)?,
      String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        var _parentObjectIds = List.empty(growable: true);

        if (parents?.isNotEmpty ?? false)
          for (var parent in parents!) _parentObjectIds.add(parent['objectId']);

        await RTListener.subscribeForRelationsChanges(
          RTEventHandlers.ADD.toShortString(),
          _tableName,
          relationColumnName,
          callback,
          parentObjectIds: parentObjectIds,
        );
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addDeleteRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
      List? parents,
      void onError(String error)?,
      String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        var _parentObjectIds = List.empty(growable: true);

        if (parents?.isNotEmpty ?? false)
          for (var parent in parents!) _parentObjectIds.add(parent['objectId']);

        await RTListener.subscribeForRelationsChanges(
          RTEventHandlers.DELETE.toShortString(),
          _tableName,
          relationColumnName,
          callback,
          parentObjectIds: parentObjectIds,
        );
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addConnectListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        RTClient.instance.streamController.listen((event) {
          if (event == 'connect') {
            callback.call();
          }
        });
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addDisconnectListener(callback,
      {void onError(String error)?, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty)
        RTClient.instance.streamController.listen((event) {
          if (event == 'disconnect') {
            callback.call();
          }
        });
      else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void removeBulkCreateListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_CREATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkDeleteListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_DELETED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkUpdateListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_UPDATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkUpsertListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_UPSERTED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeCreateListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.CREATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeDeleteListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.DELETED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeUpdateListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.UPDATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeUpsertListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.UPSERTED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeSetRelationListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(),
        RTEventHandlers.SET.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeAddRelationListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(),
        RTEventHandlers.ADD.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeDeleteRelationListeners({String? whereClause}) {
    RTClient.instance.removeListeners(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(),
        RTEventHandlers.DELETE.toShortString(),
        whereClause: whereClause);
  }
}
