part of backendless_sdk;

class RTClient<E> {
  socket_io.Socket? socket;
  bool socketCreated = false;
  bool socketConnected = false;
  bool isConnectionHandlersReady = false;
  bool needResubscribe = false;
  bool needCallDisconnect = true;

  final Map<String, List<RTSubscription<E>>> _subscriptions =
      <String, List<RTSubscription<E>>>{};
  Map<String, RTSubscription<E>> subs = <String, RTSubscription<E>>{};
  List<RTSubscription<E>> waitingSubscriptions =
      List<RTSubscription<E>>.empty(growable: true);
  final Map<String, RTMethodRequest> _methods = <String, RTMethodRequest>{};

  static final StreamController _controller = StreamController.broadcast();

  static final _instance = RTClient._();
  static RTClient get instance => _instance;

  RTClient._();

  Future connectSocket(void Function() connected) async {
    if (!socketCreated) {
      String path = '/${Backendless.applicationId}';
      String host = MapEventHandler._rtUrl.isEmpty
          ? ClassEventHandler._rtUrl
          : MapEventHandler._rtUrl;

      host += path;
      socket = socket_io.io(host, <String, dynamic>{
        'transports': ['websocket'],
        'path': '/${Backendless.applicationId!}',
        'query': <String, String>{
          'apiKey': Backendless.apiKey!,
        }
      });

      if (socket != null) {
        socketCreated = true;
        onConnectionHandlers(connected);
      }

      socket!.on('disconnect', (data) {
        //print('disconnect: $data');
        socketConnected = false;
        if (needCallDisconnect) _controller.add('disconnect');
      });
      socket!.on('error', (data) {
        if (kDebugMode) {
          print('error$data');
        }
        //_controller.add('disconnect');
        needResubscribe = true;
      });
      socket!.on('connect_error', (data) {
        if (kDebugMode) {
          print('connect_error: $data');
        }
        _controller.add('connect_error');
        needResubscribe = true;
      });
      socket!.on('connect_timeout', (data) {
        if (kDebugMode) {
          print('connect_timeout: $data');
        }
      });
      socket!.on('reconnect', (data) {
        if (kDebugMode) {
          print('reconnect: $data');
        }
        _controller.add('reconnect');
      });
    } else if (socketConnected == true) {
      connected.call();
    }
  }

  Future<RTSubscription> createSubscription<T>(
      String type,
      Map<String, dynamic> options,
      void Function(T? response)? callback) async {
    String subscriptionId = const Uuid().v4();
    Map<String, dynamic> data = {
      'id': subscriptionId,
      'name': type,
      'options': options
    };
    var subscription = RTSubscription<T>();
    subscription.data = data;
    subscription.subscriptionId = subscriptionId;
    subscription.type = type;
    subscription.options = options;
    subscription.ready = false;
    subscription.callback = callback;

    var typeName = SubscriptionNames.RSO_CONNECT.toString();

    if (options.containsKey('channel') && options['channel'] != null) {
      typeName = SubscriptionNames.PUB_SUB_CONNECT.toString();
    }

    if (data['name'] is String) {
      String name = data['name'];

      if (name != SubscriptionNames.RSO_CONNECT.toString() ||
          name != SubscriptionNames.PUB_SUB_CONNECT.toString()) {
        if ((data['options'] is Map<String, dynamic>) &&
            data['options']['event'] is String) {
          typeName = data['options']['event'];
        } else {
          typeName = name;
        }
      }
    }

    var subscriptionStack = _subscriptions[typeName];
    subscriptionStack ??= List.empty(growable: true);

    if (E == T || E == Map || T == Map) {
      subscriptionStack.add(subscription as RTSubscription<E>);
    } else {
      throw ArgumentError.value(ExceptionMessage.cannotCompareTypes);
    }

    _subscriptions[typeName] = subscriptionStack;

    if (E == T || E == Map || T == Map) {
      subs[subscriptionId] = subscription as RTSubscription<E>;
    } else {
      throw ArgumentError.value(ExceptionMessage.cannotCompareTypes);
    }

    return subscription;
  }

  void subscribe<T>(Map<String, dynamic> data, RTSubscription<T> subscription) {
    if (_instance.socketConnected) {
      socket!.emit('SUB_ON', data);
      //print('sub_on ${subscription.subscriptionId}');
    } else {
      connectSocket(() => socket!.emit('SUB_ON', data));
    }
  }

  void onConnectionHandlers(void Function() connected) {
    socket?.on('connect', (data) {
      if (needResubscribe) {
        if (kDebugMode) {
          print('connect re_sub');
        }
        needCallDisconnect = false;
        removeSocket();
        connectSocket(connected);
        needCallDisconnect = true;
      } else {
        //print('connected');
        socketConnected = true;
        for (var subscriptionId in subs.keys) {
          var subscription = subs[subscriptionId];
          var type = subscription!.type;
          var options = subscription.options;
          var data = <String, dynamic>{
            'id': subscriptionId,
            'name': type,
            'options': options,
          };

          subscribe(data, subscription);
        }

        socket!.on('SUB_RES', (data) {
          if (E != dynamic && E != Map) {
            subs[data['id']]!
                .callback
                ?.call(reflector.deserialize<E>(data['data']));
          } else {
            subs[data['id']]!.callback?.call(data['data']);
          }
        });
        needResubscribe = false;
        connected.call();
        _controller.add('connect');
      }
    });
  }

  void removeSocket() {
    socket!.dispose();
    isConnectionHandlersReady = false;
    socketConnected = false;
    socketCreated = false;
    needResubscribe = false;
  }

  void removeListeners(String type, String event, {String? whereClause}) =>
      stopSubscription(event, whereClause: whereClause);

  void stopSubscription(String event, {String? whereClause}) {
    try {
      var subscriptionStack = List.from(_subscriptions[event]!, growable: true);

      if (whereClause?.isNotEmpty ?? false) {
        for (var subscription in subscriptionStack) {
          final options = subscription.options;
          final subscriptionWhereClause = options!['whereClause'] as String?;
          if (subscriptionWhereClause == whereClause) {
            subscription.stop();
            _subscriptions[event]!.remove(subscription);
          }
        }
      } else {
        for (var subscription in subscriptionStack) {
          subscription.stop();
          _subscriptions[event]!.remove(subscription);
        }
      }
    } catch (ex) {
      throw ArgumentError.value(ExceptionMessage.errorDuringRemoveSub);
    }
  }

  void stopSubscriptionForChannel(Channel channel, String event) {
    var subscriptionStack = _subscriptions[event];

    if (subscriptionStack?.isNotEmpty ?? false) {
      for (var tempSub in subscriptionStack!) {
        var options = tempSub.options;

        if (options != null) {
          var channelName = options['channel'] as String?;

          if (channelName == channel.channelName) tempSub.stop();
        }
      }
    }
  }

  void unsubscribe(String subscriptionId) {
    if (subs.keys.contains(subscriptionId)) {
      socket?.emit('SUB_OFF', {'id': subscriptionId});
      subs.remove(subscriptionId);
    }

    if (subs.isEmpty && socket != null) {
      removeSocket();
    }
  }

  void sendCommand(Map<String, dynamic> data, RTMethodRequest? method) {
    if (socketConnected) {
      socket!.emit('MET_REQ', data);
    } else {
      connectSocket(() => socket!.emit('MET_REQ', data));
    }

    if (method != null) {
      _methods[method.methodId!] = method;
    }
  }

  static Stream get streamController => _controller.stream;
}
