part of backendless_sdk;

class RTClient {
  IO.Socket? socket;
  bool socketCreated = false;
  bool socketConnected = false;
  bool isConnectionHandlersReady = false;
  bool needResubscribe = false;
  bool needCallDisconnect = true;

  Map<String, List<RTSubscription>> _subscriptions =
      Map<String, List<RTSubscription>>();
  Map<String, RTSubscription> subs = Map<String, RTSubscription>();

  StreamController _controller = StreamController.broadcast();

  static final _instance = RTClient._();
  static RTClient get instance => _instance;

  RTClient._();

  Future connectSocket(void connected()) async {
    if (!socketCreated) {
      String path = '/${Backendless.applicationId}';
      String host = MapEventHandler._rtUrl;

      host += path;
      socket = IO.io(host, <String, dynamic>{
        'transports': ['websocket'],
        'path': '/' + Backendless.applicationId,
        'query': <String, String>{
          'apiKey': Backendless.apiKey,
        }
      });

      if (socket != null) {
        socketCreated = true;
        this.onConnectionHandlers(connected);
      }

      socket!.on('disconnect', (data) {
        //print('disconnect: $data');
        socketConnected = false;
        if (this.needCallDisconnect) _controller.add('disconnect');
      });
      socket!.on('error', (data) {
        print('error');
        _controller.add('disconnect');
        needResubscribe = true;
      });
      socket!.on('connect_error', (data) {
        print('connect_error: $data');
        needResubscribe = true;
      });
      socket!.on('connect_timeout', (data) => print('connect_timeout: $data'));
    } else if (socketConnected == true) {
      connected.call();
    }
  }

  Future<RTSubscription> createSubscription<T>(String type,
      Map<String, dynamic> options, void Function(T response) callback) async {
    String subscriptionId = Uuid().v4();
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

    if (options.containsKey('channel') && options['channel'] != null)
      typeName = SubscriptionNames.PUB_SUB_CONNECT.toString();

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

    var subscriptionStack = this._subscriptions[typeName];
    if (subscriptionStack == null)
      subscriptionStack = List<RTSubscription>.empty(growable: true);

    subscriptionStack.add(subscription);
    this._subscriptions[typeName] = subscriptionStack;
    this.subs[subscriptionId] = subscription;

    return subscription;
  }

  void subscribe(Map<String, dynamic> data, RTSubscription subscription) {
    if (_instance.socketConnected) {
      this.socket!.emit('SUB_ON', data);
      //print('sub_on ${subscription.subscriptionId}');
    } else {
      this.connectSocket(() => socket!.emit('SUB_ON', data));
    }
  }

  void onConnectionHandlers(void connected()) {
    this.socket?.on('connect', (data) {
      if (this.needResubscribe) {
        print('connect re_sub');
        this.needCallDisconnect = false;
        this.removeSocket();
        this.connectSocket(connected);
        this.needCallDisconnect = true;
      } else {
        //print('connected');
        this.socketConnected = true;
        for (var subscriptionId in this.subs.keys) {
          var subscription = this.subs[subscriptionId];
          var type = subscription!.type;
          var options = subscription.options;
          var data = <String, dynamic>{
            'id': subscriptionId,
            'name': type,
            'options': options,
          };

          this.subscribe(data, subscription);
        }
        this.socket!.on('SUB_RES', (data) {
          subs[data['id']]!.callback?.call(data['data']);
        });
        this.needResubscribe = false;
        connected.call();
        _controller.add('connect');
      }
    });
  }

  void removeSocket() {
    this.socket!.dispose();
    this.isConnectionHandlersReady = false;
    this.socketConnected = false;
    this.socketCreated = false;
    this.needResubscribe = false;
  }

  void removeListeners(String type, String event, {String? whereClause}) =>
      stopSubscription(event, whereClause: whereClause);

  void stopSubscription(String event, {String? whereClause}) {
    try {
      var subscriptionStack = this._subscriptions[event];

      if (whereClause?.isNotEmpty ?? false) {
        for (var subscription in subscriptionStack!) {
          final options = subscription.options;
          final subscriptionWhereClause = options!['whereClause'] as String?;
          if (subscriptionWhereClause == whereClause) {
            subscription.stop();
            this._subscriptions[event]!.remove(subscription.subscriptionId);
          }
        }
      } else {
        for (var subscription in subscriptionStack!) {
          subscription.stop();
          this._subscriptions[event]!.remove(subscription.subscriptionId);
        }
      }
    } catch (ex) {
      throw ArgumentError.value(ExceptionMessage.ERROR_DURING_REMOVE_SUB);
    }
  }

  void unsubscribe(String subscriptionId) {
    if (this.subs.keys.contains(subscriptionId)) {
      this.socket?.emit('SUB_OFF', {'id': subscriptionId});
      this.subs.remove(subscriptionId);
    }
    if (this.subs.length == 0 && this.socket != null) this.removeSocket();
  }

  Stream get streamController => _controller.stream;
}
