part of backendless_sdk;

class Channel {
  String channelName = 'default';
  bool _isJoined = false;

  RTMessaging? _rt;

  Channel(this.channelName);

  get isJoined => _isJoined;

  Future<void> join() async {
    var lock = Lock();

    await lock.synchronized(() async {
      _rt ??= RTMessaging(this, channelName);
      if (!_isJoined) {
        _rt!.connect((response) {
          _isJoined = true;
          if (RTListener.clientInstance!.waitingSubscriptions.isNotEmpty) {
            _rt!.subscribeForWaiting();
          }
        });
      }
    });
  }

  Future<void> leave() async {
    var lock = Lock();

    await lock.synchronized(() async {
      if (_isJoined) {
        _isJoined = false;
        removeAllListeners();
        await _rt!.disconnect();
      }
    });
  }

  void addMessageListener(void Function(dynamic response) callback) {
    _rt!.addMessageListener(callback);
  }

  void removeMessageListeners() {
    _rt!.removeMessageListeners();
    _rt!.removeWaitingSubscriptions(
        subscriptionName: SubscriptionNames.PUB_SUB_MESSAGES.toShortString());
  }

  void addCommandListener(void Function(dynamic response) callback) {
    _rt!.addCommandListener(callback);
  }

  Future<void> sendCommand(String commandType, dynamic data) async {
    var options = <String, dynamic>{
      'channel': channelName,
      'type': commandType
    };

    options['data'] = data;

    RTMethod.sendCommand(
        SubscriptionNames.PUB_SUB_COMMANDS.toShortString(), options);
  }

  void removeCommandListeners() {
    _rt!.removeCommandListeners();
    _rt!.removeWaitingSubscriptions(
        subscriptionName: SubscriptionNames.PUB_SUB_COMMANDS.toShortString());
  }

  Future<void> addUserStatusListener(
      void Function(UserStatusResponse? response) callback,
      {void Function(String error)? onError}) async {
    await _rt!.addUserStatusListener(callback, onError: onError);
  }

  void removeUserStatusListeners() {
    _rt!.removeUserStatusListeners();
    _rt!.removeWaitingSubscriptions(
        subscriptionName: SubscriptionNames.PUB_SUB_USERS.toShortString());
  }

  void removeAllListeners() {
    removeMessageListeners();
    removeCommandListeners();
    removeUserStatusListeners();
    _rt!.removeWaitingSubscriptions();
  }
}
