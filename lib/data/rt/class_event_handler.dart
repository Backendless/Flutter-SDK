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
  void addCreateListener(void Function(T? response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      print('classEvent: ' + (T).toString());
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.CREATED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
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

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.UPDATED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
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

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.UPSERTED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
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

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.DELETED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addBulkCreateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_CREATED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addBulkUpdateListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_UPDATED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addBulkUpsertListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_UPSERTED.toShortString(), _tableName, callback,
            whereClause: whereClause);
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addBulkDeleteListener(void Function(dynamic response) callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        await RTListener.subscribeForObjectsChanges(
            RTEventHandlers.BULK_DELETED.toShortString(), _tableName, callback,
            whereClause: whereClause);
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
        void Function(String error)? onError,
        String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        var tempObjectIds = List<String>.empty(growable: true);

        if (parents?.isNotEmpty ?? false) {
          for (var parent in parents!) {
            tempObjectIds.add(parent['objectId']);
          }
        }

        if (parentObjectIds?.isNotEmpty ?? false) {
          tempObjectIds.addAll(parentObjectIds!);
        }
        await RTListener.subscribeForRelationsChanges(
          RTEventHandlers.ADD.toShortString(),
          _tableName,
          relationColumnName,
          callback,
          parentObjectIds: tempObjectIds,
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
        void Function(String error)? onError,
        String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        var tempObjectIds = List<String>.empty(growable: true);

        if (parents?.isNotEmpty ?? false) {
          for (var parent in parents!) {
            tempObjectIds.add(parent['objectId']);
          }
        }

        if (parentObjectIds?.isNotEmpty ?? false) {
          tempObjectIds.addAll(parentObjectIds!);
        }

        await RTListener.subscribeForRelationsChanges<T>(
          RTEventHandlers.DELETE.toShortString(),
          _tableName,
          relationColumnName,
          callback,
          parentObjectIds: tempObjectIds,
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
  void addSetRelationListener(String relationColumnName, callback,
      {List<String>? parentObjectIds,
        List? parents,
        void Function(String error)? onError,
        String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        var tempObjectIds = List<String>.empty(growable: true);

        if (parents?.isNotEmpty ?? false) {
          for (var parent in parents!) {
            tempObjectIds.add(parent['objectId']);
          }
        }

        if (parentObjectIds?.isNotEmpty ?? false) {
          tempObjectIds.addAll(parentObjectIds!);
        }
        await RTListener.subscribeForRelationsChanges(
          RTEventHandlers.SET.toShortString(),
          _tableName,
          relationColumnName,
          callback,
          parentObjectIds: tempObjectIds,
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
  void removeCreateListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.CREATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeUpdateListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.UPDATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeUpsertListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.UPSERTED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeDeleteListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.DELETED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkCreateListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_CREATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkUpdateListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_UPDATED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkUpsertListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_UPSERTED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeBulkDeleteListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(),
        RTEventHandlers.BULK_DELETED.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeAddRelationListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(),
        RTEventHandlers.ADD.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeSetRelationListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(),
        RTEventHandlers.SET.toShortString(),
        whereClause: whereClause);
  }

  @override
  void removeDeleteRelationListeners({String? whereClause}) {
    RTListener.removeListeners(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(),
        RTEventHandlers.DELETE.toShortString(),
        whereClause: whereClause);
  }

  @override
  void addConnectListener(void Function() callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        RTListener.connectionHandler(callback);
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }

  @override
  void addDisconnectListener(void Function() callback,
      {void Function(String error)? onError, String? whereClause}) async {
    try {
      if (_rtUrl.isEmpty) _rtUrl = (await RTLookupService.lookup())!;

      if (_rtUrl.isNotEmpty) {
        RTListener.disconnectionHandler(callback);
      } else {
        print('empty url');
        throw ArgumentError.value(ExceptionMessage.NO_INTERNET_CONNECTION);
      }
    } catch (ex) {
      onError!.call(ex.toString());
    }
  }
}