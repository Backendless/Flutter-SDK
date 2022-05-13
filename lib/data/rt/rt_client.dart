part of backendless_sdk;

class RTClient {
  RTClient._();

  static final _instance = RTClient._();
  static RTClient get instance => _instance;

  Map<String, List<RTSubscription>> _subscriptions =
      Map<String, List<RTSubscription>>();
  Map<String, RTSubscription> subs = Map<String, RTSubscription>();
  IO.Socket? socket;
  //Future<RTLookupService> _lookupService = RTLookupService.create();
  bool socketCreated = false;
  bool socketConnected = false;
  bool isConnectionHandlersReady = false;
  bool needResubscribe = false;

  StreamController _controller = StreamController.broadcast();

  Future connectSocket(void connected()) async {
    if (!socketCreated) {
      String path = '/${Backendless.applicationId}';
      String host = EventHandler._rtUrl;

      if (host != null) {
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
        /*socket!.onConnect((socketRes) {
          print('Connected');
          print(socketRes);
          //if (!socketConnected) _controller.add(socketConnected);
          socketConnected = true;
        });*/

        socket!.on('disconnect', (data) {
          print('disconnect: $data');
          socketConnected = false;
          _controller.add('disconnect');
        });
        socket!.on('error', (data) {
          _controller.add('disconnect');
        });
        socket!.on('connect_error', (data) => print('connect_error: $data'));
        socket!
            .on('connect_timeout', (data) => print('connect_timeout: $data'));
        //socket!.on('SUB_RES', (data) => print('sub_res: $data'));
        //socket!.on('SUB_ON', (data) => print('ON SOCKET'));
        //socket!.emit('SUB_ON', (data) => print('EMIT SOCKET'));
      }
    } else if (socketConnected == true) {
      connected.call();
    }
  }

  Future<RTSubscription> createSubscription<T>(
      String type,
      Map<String, dynamic> options,
      void Function(dynamic response) callback) async {
    String subscriptionId = Uuid().v4();
    Map<String, dynamic> data = {
      'id': subscriptionId,
      'name': type,
      'options': options
    };
    var subscription = RTSubscription();
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
    /*if (socketConnected)
      subscribe(data, subscription);
    else
      await connectSocket(() => subscribe(data, subscription));
    */

    return subscription;
  }

  void subscribe(Map<String, dynamic> data, RTSubscription subscription) {
    if (_instance.socketConnected) {
      this.socket!.emit('SUB_ON', data);
    } else {
      this.connectSocket(() => socket!.emit('SUB_ON', data));
    }
  }

  void onConnectionHandlers(void connected()) {
    if (!this.isConnectionHandlersReady) {
      this.isConnectionHandlersReady = true;
      this.socket?.on('connect', (data) {
        print('connected');
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
          subs[data['id']]!.callback?.call(data);
        });
        this.needResubscribe = false;
        connected.call();
      });
    }
  }

  void onResult() {
    this.socket!.on('SUB_RES', (data) {
      var resultData;
      if (data is Map) {
        resultData = data;
        String subscriptionId = data['id'];
        RTSubscription subscription = this.subs[subscriptionId]!;
        if (data['data'] != null) {}
      }
    });
  }

  Stream get streamController => _controller.stream;
}
