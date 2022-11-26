part of backendless_sdk;

class Channel {
  String channelName = 'default';
  bool _isJoined = false;

  RTMessaging? _rt;

  Channel(this.channelName);

  get isJoined => _isJoined;

  Future<void> join() async {
    var lock = new Lock();

    await lock.synchronized(() async {
      if (this._rt == null) {
        _rt = RTMessaging(this, this.channelName);
      }
      if (!_isJoined) {
        this._rt!.connect((response) {
          this._isJoined = true;
          if (RTListener.clientInstance!.waitingSubscriptions.isNotEmpty) {
            this._rt!.subscribeForWaiting();
          }
        });
      }
    });
  }

  Future<void> leave() async {
    var lock = new Lock();

    await lock.synchronized(() async {
      if (_isJoined) {
        _isJoined = false;
        removeAllListeners();
        await this._rt!.disconnect();
      }
    });
  }

  void addMessageListener(void Function(dynamic response) callback) {
    this._rt!.addMessageListener(callback);
  }

  void removeMessageListeners() {
    this._rt!.removeMessageListeners();
    this._rt!.removeWaitingSubscriptions(
        subscriptionName: SubscriptionNames.PUB_SUB_MESSAGES.toShortString());
  }

  void addCommandListener(void Function(dynamic response) callback) {
    this._rt!.addCommandListener(callback);
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
    this._rt!.removeCommandListeners();
    this._rt!.removeWaitingSubscriptions(
        subscriptionName: SubscriptionNames.PUB_SUB_COMMANDS.toShortString());
  }

  Future<void> addUserStatusListener(
      void Function(UserStatusResponse? response) callback,
      {void onError(String error)?}) async {
    await this._rt!.addUserStatusListener(callback, onError: onError);
  }

  void removeUserStatusListeners() {
    this._rt!.removeUserStatusListeners();
    this._rt!.removeWaitingSubscriptions(
        subscriptionName: SubscriptionNames.PUB_SUB_USERS.toShortString());
  }

  void removeAllListeners() {
    removeMessageListeners();
    removeCommandListeners();
    removeUserStatusListeners();
    this._rt!.removeWaitingSubscriptions();
  }
}
