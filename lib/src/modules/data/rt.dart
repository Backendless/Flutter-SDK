part of backendless_sdk;

class EventHandler<T> {
  static const MethodChannel _channel = const MethodChannel(
      'backendless/data', StandardMethodCodec(BackendlessMessageCodec()));
  String _tableName;

  EventHandler(this._tableName);

// Create

  void addCreateListener(void callback(T response),
      {void onError(String error), String whereClause}) {
    DataSubscription<T> subscription = new DataSubscription<T>(
        RTDataEvent.CREATED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeCreateListeners([String whereClause]) {
    _removeListeners(RTDataEvent.CREATED, whereClause);
  }

  void removeCreateListener(void callback(T response)) {
    _removeListeners(RTDataEvent.CREATED, null, callback);
  }

// Update

  void addUpdateListener(void callback(T response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription<T>(
        RTDataEvent.UPDATED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeUpdateListeners([String whereClause]) {
    _removeListeners(RTDataEvent.UPDATED, whereClause);
  }

  void removeUpdateListener(void callback(T response)) {
    _removeListeners(RTDataEvent.UPDATED, null, callback);
  }

// Delete

  void addDeleteListener(void callback(T response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription<T>(
        RTDataEvent.DELETED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeDeleteListeners([String whereClause]) {
    _removeListeners(RTDataEvent.DELETED, whereClause);
  }

  void removeDeleteListener(void callback(T response)) {
    _removeListeners(RTDataEvent.DELETED, null, callback);
  }

// Bulk Update

  void addBulkUpdateListener(void callback(BulkEvent response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription<T>(
        RTDataEvent.BULK_UPDATED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeBulkUpdateListeners([String whereClause]) {
    _removeListeners(RTDataEvent.BULK_UPDATED, whereClause);
  }

  void removeBulkUpdateListener(void callback(BulkEvent response)) {
    _removeListeners(RTDataEvent.BULK_UPDATED, null, callback);
  }

// Bulk Delete

  void addBulkDeleteListener(void callback(BulkEvent response),
      {void onError(String error), String whereClause}) {
    DataSubscription subscription = new DataSubscription<T>(
        RTDataEvent.BULK_DELETED, _tableName, callback, onError, whereClause);
    addEventListener(subscription);
  }

  void removeBulkDeleteListeners([String whereClause]) {
    _removeListeners(RTDataEvent.BULK_DELETED, whereClause);
  }

  void removeBulkDeleteListener(void callback(BulkEvent response)) {
    _removeListeners(RTDataEvent.BULK_DELETED, null, callback);
  }

  void addEventListener(DataSubscription subscription) {
    _channel.invokeMethod("Backendless.Data.RT.addListener", <String, dynamic>{
      "event": subscription.event.toString(),
      "tableName": subscription.tableName,
      "whereClause": subscription.whereClause
    }).then((handle) => BackendlessData._subscriptions[handle] = subscription);
  }

  void _removeListeners(RTDataEvent event,
      [String whereClause, Function callback]) {
    List<int> toRemove = [];
    BackendlessData._subscriptions.forEach((handle, subscription) {
      if (subscription.event == event &&
          (whereClause == null || whereClause == subscription.whereClause) &&
          (callback == null || callback == subscription._handleResponse)) {
        toRemove.add(handle);
      }
    });

    toRemove.forEach((handle) {
      _channel
          .invokeMethod("Backendless.Data.RT.removeListener", <String, dynamic>{
        "handle": handle,
        "event": event.toString(),
        "tableName": _tableName,
        "whereClause": whereClause
      });
      BackendlessData._subscriptions.remove(handle);
    });
  }
}

class BulkEvent {
  String whereClause;
  int count;

  BulkEvent();

  BulkEvent.fromJson(Map json)
      : whereClause = json['whereClause'],
        count = json['count'];

  Map toJson() => {
        'whereClause': whereClause,
        'count': count,
      };

  @override
  String toString() => "BulkEvent{whereClause='$whereClause', count=$count}";
}

class DataSubscription<T> {
  RTDataEvent event;
  String tableName;
  Function _handleResponse;
  void Function(String fault) _handleFault;
  String whereClause;

  DataSubscription(
      this.event, this.tableName, this._handleResponse, this._handleFault,
      [this.whereClause]);

  void handleResponse(dynamic response) {
    if ((T != Map) && (response is Map)) {
      _handleResponse(reflector.deserialize<T>(response));
    } else {
      _handleResponse(response);
    }
  }

  void handleFault(String fault) {
    if (_handleFault != null) _handleFault(fault);
  }
}

enum RTDataEvent {
  CREATED,
  BULK_CREATED,
  UPDATED,
  BULK_UPDATED,
  DELETED,
  BULK_DELETED
}
