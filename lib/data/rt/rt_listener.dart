part of backendless_sdk;

class RTListener {
  static late RTClient? clientInstance;
  static bool? clientNull;

  static void removeListeners(String type, String event,
          {String? whereClause}) =>
      clientInstance!.removeListeners(type, event, whereClause: whereClause);

  static void unsubscribe(String id) => clientInstance!.unsubscribe(id);

  static Future connectionHandler(void Function() callback) async {
    /*if (RTListener.clientNull ?? true) {
      clientInstance = RTClient<T>._();
      RTListener.clientNull = false;
    }*/

    if (RTListener.clientNull ?? true) {
      throw ArgumentError.value(ExceptionMessage.NO_ONE_SUB);
    } else {
      clientInstance!.streamController.listen((event) {
        if (event == 'connect') {
          callback.call();
        }
      });
    }
  }

  static Future disconnectionHandler(void Function() callback) async {
    if (RTListener.clientNull ?? true) {
      throw ArgumentError.value(ExceptionMessage.NO_ONE_SUB);
    } else {
      clientInstance!.streamController.listen((event) {
        if (event == 'disconnect') {
          callback.call();
        }
      });
    }
  }

  static Future<RTSubscription?> subscribeForObjectsChanges<T>(
      String event, String tableName, void Function(T? response) callback,
      {String? whereClause}) async {
    if (RTListener.clientNull ?? true) {
      clientInstance = RTClient<T>._();
      RTListener.clientNull = false;
    }

    if (!clientInstance!.socketConnected) {
      await clientInstance?.connectSocket(() {});
    }

    var options = <String, dynamic>{'tableName': tableName, 'event': event};

    if (whereClause?.isNotEmpty ?? false) options['whereClause'] = whereClause!;

    var subscription = await clientInstance?.createSubscription<T>(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(), options, callback);

    return subscription;
  }

  static Future<RTSubscription?> subscribeForRelationsChanges<T>(
      String event,
      String tableName,
      String relationColumnName,
      void Function(T? response) callback,
      {String? whereClause,
      List<String>? parentObjectIds}) async {
    if (RTListener.clientNull ?? true) {
      clientInstance = RTClient<T>._();
      RTListener.clientNull = false;
    }

    if (!clientInstance!.socketConnected) {
      await clientInstance?.connectSocket(() {});
    }

    var options = <String, dynamic>{
      'tableName': tableName,
      'event': event,
      'relationColumnName': relationColumnName
    };

    if (parentObjectIds?.isNotEmpty ?? false)
      options['parentObjectIds'] = parentObjectIds!;

    if (whereClause?.isNotEmpty ?? false) options['whereClause'] = whereClause!;

    var subscription = await clientInstance?.createSubscription<T>(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(), options, callback);

    return subscription;
  }
}
