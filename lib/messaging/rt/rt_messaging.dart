// ignore_for_file: avoid_shadowing_type_parameters

part of backendless_sdk;

class RTMessaging<T> extends RTListener {
  final Channel _channel;
  final String _channelName;
  String? _subscriptionId;

  RTMessaging(this._channel, this._channelName);

  Future<void> connect(void Function(T? response) callback) async {
    Map<String, dynamic> options = {'channel': _channelName};

    if (RTListener.clientNull ?? true) {
      RTListener.clientInstance = RTClient._();
      RTListener.clientNull = false;
    }

    var subscription = await RTListener.clientInstance!.createSubscription<T>(
        SubscriptionNames.PUB_SUB_CONNECT.toShortString(), options, callback);

    _subscriptionId = subscription.subscriptionId;
    subscription.subscribe();
  }

  Future<void> disconnect() async {
    RTListener.clientInstance!.unsubscribe(_subscriptionId!);
    removeWaitingSubscriptions(
        subscriptionName: null, subscriptionSelector: null);
  }

  Future<void> addJoinListener(void Function() callback) async {
    var subscription = RTSubscription();
    subscription.subscriptionId = const Uuid().v4();
    subscription.options = {'channel': _channelName};
    subscription.callback = callback as void Function(dynamic response)?;

    ///
  }

  void addMessageListener(void Function(dynamic response) callback) async {
    if (RTListener.clientInstance!.socketConnected && _channel.isJoined) {
      var options = <String, dynamic>{'channel': _channelName};
      var subscription = await RTListener.clientInstance!
          .createSubscription<Map>(
              SubscriptionNames.PUB_SUB_MESSAGES.toShortString(),
              options,
              callback);
      subscription.subscribe();
    } else {
      await addWaitingSubscription(
        SubscriptionNames.PUB_SUB_MESSAGES.toShortString(),
        callback,
      );
    }
  }

  void addCommandListener(void Function(dynamic response) callback) async {
    if (RTListener.clientInstance!.socketConnected && _channel.isJoined) {
      var options = <String, dynamic>{'channel': _channelName};
      var subscription =
          await RTListener.clientInstance!.createSubscription<Map>(
        SubscriptionNames.PUB_SUB_COMMANDS.toShortString(),
        options,
        callback,
      );
      subscription.subscribe();
    } else {
      await addWaitingSubscription(
        SubscriptionNames.PUB_SUB_COMMANDS.toShortString(),
        callback,
      );
    }
  }

  Future<void> addUserStatusListener(
      void Function(UserStatusResponse? response) callback,
      {void Function(String error)? onError}) async {
    if (RTListener.clientInstance!.socketConnected && _channel.isJoined) {
      var options = <String, dynamic>{'channel': _channelName};
      var subscription = await RTListener.clientInstance!
          .createSubscription<UserStatusResponse>(
              SubscriptionNames.PUB_SUB_USERS.toShortString(),
              options,
              callback);

      subscription.subscribe();
    } else {
      await addWaitingSubscription(
          SubscriptionNames.PUB_SUB_USERS.toShortString(), callback);
    }
  }

  Future<void> addWaitingSubscription<T>(
      String event, void Function(T? response) callback,
      {String? selector}) async {
    RTSubscription waitingSubscription;
    var options = <String, dynamic>{'event': event, 'channel': _channelName};

    if (selector != null) {
      options['selector'] = selector;
    }

    waitingSubscription = await RTListener.clientInstance!
        .createSubscription<T>(event, options, callback);

    RTListener.clientInstance!.waitingSubscriptions.add(waitingSubscription);
    //return waitingSubscription;
  }

  void subscribeForWaiting() async {
    //var indexesToRemove = List<int>.empty(growable: true);
    var tempSubscriptions =
        List.from(RTListener.clientInstance!.waitingSubscriptions);

    try {
      for (var waitingSubscription in tempSubscriptions) {
        var data = waitingSubscription.data;
        var name = data!['name'] as String;
        var options = waitingSubscription.options;

        if (name == SubscriptionNames.PUB_SUB_MESSAGES.toShortString() ||
            name == SubscriptionNames.PUB_SUB_COMMANDS.toShortString() ||
            name == SubscriptionNames.PUB_SUB_USERS.toShortString() ||
            options!['channel'] as String == _channelName) {
          waitingSubscription.subscribe();

          ///TODO ADD DELETE FROM WAITING SUB
        }
      }
      RTListener.clientInstance!.waitingSubscriptions.clear();
    } catch (ex) {
      if (kDebugMode) {
        print('EXCEPTION IN SUBSCRIBE FOR WAITING SUBSCRIPTIONS');
      }
    }
  }

  Future<void> removeWaitingSubscriptions<T>(
      {String? subscriptionName, String? subscriptionSelector}) async {
    var indexesToRemove = List<int>.empty(growable: true);

    RTListener.clientInstance!.waitingSubscriptions
        .forEachIndexed((index, waitingSubscription) {
      var data = waitingSubscription.data;

      if (data == null) {
        throw BackendlessException(
            'cannot remove subscription. rt_messaging {105 str}');
      }

      String? name = data['name'];

      if ((subscriptionName != null && name == subscriptionName) ||
          subscriptionName == null &&
              (name == SubscriptionNames.PUB_SUB_MESSAGES.toShortString() ||
                  name == SubscriptionNames.PUB_SUB_COMMANDS.toShortString() ||
                  name == SubscriptionNames.PUB_SUB_USERS.toShortString())) {
        var opt = waitingSubscription.options;
        String? channelName = opt!['channel'] as String?;
        if (channelName == _channelName) {
          if (subscriptionSelector == null) {
            indexesToRemove.add(index);
          } else if ((opt['selector'] as String?) == subscriptionSelector) {
            ///TODO: remove with selector
          }
        }
      }
    });
    for (var element in indexesToRemove) {
      RTListener.clientInstance!.waitingSubscriptions.removeAt(element);
    }
  }

  void removeMessageListeners() {
    RTListener.clientInstance!.stopSubscriptionForChannel(
        _channel, SubscriptionNames.PUB_SUB_MESSAGES.toShortString());
  }

  void removeCommandListeners() {
    RTListener.clientInstance!.stopSubscriptionForChannel(
        _channel, SubscriptionNames.PUB_SUB_COMMANDS.toShortString());
  }

  void removeUserStatusListeners() {
    RTListener.clientInstance!.stopSubscriptionForChannel(
        _channel, SubscriptionNames.PUB_SUB_USERS.toShortString());
  }
}
