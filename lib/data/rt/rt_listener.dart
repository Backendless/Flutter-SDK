part of backendless_sdk;

class RTListener {
  static late RTClient? clientInstance;
  static bool? clientNull;
  static StreamSubscription<dynamic>? connectSub;
  static StreamSubscription<dynamic>? disconnectSub;
  static StreamSubscription<dynamic>? connectErrorSub;
  static StreamSubscription<dynamic>? reconnectSub;

  static void removeListeners(String type, String event,
          {String? whereClause}) =>
      clientInstance!.removeListeners(type, event, whereClause: whereClause);

  static void unsubscribe(String id) => clientInstance!.unsubscribe(id);

  static Future connectionHandler(void Function() callback) async {
    await removeConnectionHandler();

    connectSub = RTClient.streamController.listen((event) {
      if (event == 'connect') {
        callback.call();
      }
    });
  }

  static Future removeConnectionHandler() async {
    if (connectSub != null) {
      connectSub!.cancel();
    }

    connectSub = null;
  }

  static Future disconnectionHandler(void Function() callback) async {
    await removeDisconnectionHandler();

    disconnectSub = RTClient.streamController.listen((event) {
      if (event == 'disconnect') {
        callback.call();
      }
    });
  }

  static Future removeDisconnectionHandler() async {
    if (disconnectSub != null) {
      disconnectSub!.cancel();
    }

    disconnectSub = null;
  }

  static Future connectionErrorHandler(void Function() callback) async {
    await removeConnectionErrorHandler();

    connectErrorSub = RTClient.streamController.listen((event) {
      if (event == 'connect_error') {
        callback.call();
      }
    });
  }

  static Future removeConnectionErrorHandler() async {
    if (connectErrorSub != null) {
      connectErrorSub!.cancel();
    }

    connectErrorSub = null;
  }

  static Future reconnectHandler(void Function() callback) async {
    await removeReconnectHandler();

    reconnectSub = RTClient.streamController.listen((event) {
      if (event == 'reconnect') {
        callback.call();
      }
    });
  }

  static Future removeReconnectHandler() async {
    if (reconnectSub != null) {
      reconnectSub!.cancel();
    }

    reconnectSub = null;
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

    if (parentObjectIds?.isNotEmpty ?? false) {
      options['parentObjectIds'] = parentObjectIds!;
    }

    if (whereClause?.isNotEmpty ?? false) options['whereClause'] = whereClause!;

    var subscription = await clientInstance?.createSubscription<T>(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(), options, callback);

    return subscription;
  }
}
