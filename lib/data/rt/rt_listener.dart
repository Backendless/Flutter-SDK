part of backendless_sdk;

class RTListener {
  static Future<RTSubscription> subscribeForObjectsChanges<T>(
      String event, String tableName, void Function(dynamic response) callback,
      {String? whereClause}) async {
    if (!RTClient.instance.socketConnected)
      await RTClient.instance.connectSocket(() {});

    var options = <String, dynamic>{'tableName': tableName, 'event': event};

    if (whereClause?.isNotEmpty ?? false) options['whereClause'] = whereClause!;

    //if (_assertEventWithCRUD(event)) {}
    var subscription = await RTClient.instance.createSubscription(
        SubscriptionNames.OBJECTS_CHANGES.toShortString(), options, callback);

    return subscription;
  }
}
