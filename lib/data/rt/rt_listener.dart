part of backendless_sdk;

class RTListener {
  static Future<RTSubscription> subscribeForObjectsChanges<T>(
      String event, String tableName, void Function(T response) callback,
      {String? whereClause}) async {
    if (!RTClient.instance.socketConnected)
      await RTClient.instance.connectSocket(() {});

    var options = <String, dynamic>{'tableName': tableName, 'event': event};

    if (whereClause?.isNotEmpty ?? false) options['whereClause'] = whereClause!;

    var subscription = await RTClient.instance.createSubscription(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(), options, callback);

    return subscription;
  }

  static Future<RTSubscription> subscribeForRelationsChanges<T>(
      String event,
      String tableName,
      String relationColumnName,
      void Function(dynamic response) callback,
      {String? whereClause,
      List<String>? parentObjectIds}) async {
    if (!RTClient.instance.socketConnected)
      await RTClient.instance.connectSocket(() {});

    var options = <String, dynamic>{
      'tableName': tableName,
      'event': event,
      'relationColumnName': relationColumnName
    };

    if (parentObjectIds?.isNotEmpty ?? false)
      options['parentObjectIds'] = parentObjectIds!;

    if (whereClause?.isNotEmpty ?? false) options['whereClause'] = whereClause!;

    var subscription = await RTClient.instance.createSubscription(
        SubscriptionNames.RELATIONS_CHANGES.toShortString(), options, callback);

    return subscription;
  }
}
