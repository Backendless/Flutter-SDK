part of backendless_sdk;

class Channel {
  final MethodChannel _methodChannel;
  final String channelName;
  final int _channelHandle;

  Channel(this._methodChannel, this.channelName, this._channelHandle);

  Future<void> join() => _methodChannel.invokeMethod(
      "Backendless.Messaging.Channel.join",
      <String, dynamic>{"channelHandle": _channelHandle});

  Future<void> leave() => _methodChannel.invokeMethod(
      "Backendless.Messaging.Channel.leave",
      <String, dynamic>{"channelHandle": _channelHandle});

  Future<bool> isJoined() => _methodChannel.invokeMethod(
      "Backendless.Messaging.Channel.isJoined",
      <String, dynamic>{"channelHandle": _channelHandle});

  Future<void> addJoinListener(Function callback,
          {void onError(String error)}) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.addJoinListener", {
        "channelHandle": _channelHandle
      }).then((handle) => BackendlessMessaging._joinCallbacks[handle] =
          new EventCallback(callback, onError));

  void removeJoinListener(Function callback) {
    List<int> handles = _findCallbacks(BackendlessMessaging._joinCallbacks,
        (eventCallback) => eventCallback.handleResponse == callback);

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeJoinListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._joinCallbacks.remove(handle);
    });
  }

  Future<void> addMessageListener<T>(void callback(T response),
      {void onError(String error), String selector}) {
    if (T != String && T != PublishMessageInfo)
      throw UnimplementedError(); // Custom type message

    Map<String, dynamic> args = {
      "selector": selector,
      "messageType": T.toString()
    };
    return _methodChannel
        .invokeMethod("Backendless.Messaging.Channel.addMessageListener",
            <String, dynamic>{"channelHandle": _channelHandle}..addAll(args))
        .then((handle) => BackendlessMessaging._messageCallbacks[handle] =
            new EventCallback(callback, onError, args));
  }

  void removeMessageListeners({String selector, Function callback}) {
    List<int> handles = _findCallbacks(
        BackendlessMessaging._messageCallbacks,
        (eventCallback) => ((selector == null ||
                selector == eventCallback.args["selector"]) &&
            (callback == null || callback == eventCallback.handleResponse)));

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeMessageListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._messageCallbacks.remove(handle);
    });
  }

  void removeAllMessageListeners() {
    BackendlessMessaging._messageCallbacks.clear();
    _methodChannel.invokeMethod(
        "Backendless.Messaging.Channel.removeAllMessageListeners",
        <String, dynamic>{
          "channelHandle": _channelHandle,
        });
  }

  Future<void> addCommandListener(void callback(Command<String> response),
          {void onError(String error)}) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.addCommandListener", {
        "channelHandle": _channelHandle
      }).then((handle) => BackendlessMessaging._commandCallbacks[handle] =
          new EventCallback(callback, onError));

  void removeCommandListener(Function callback) {
    List<int> handles = _findCallbacks(BackendlessMessaging._commandCallbacks,
        (eventCallback) => eventCallback.handleResponse == callback);

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeCommandListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._commandCallbacks.remove(handle);
    });
  }

  Future<void> sendCommand(String type, Object data) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.sendCommand", <String, dynamic>{
        "channelHandle": _channelHandle,
        "type": type,
        "data": data
      });

  Future<void> addUserStatusListener(void callback(UserStatusResponse response),
          {void onError(String error)}) =>
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.addUserStatusListener", {
        "channelHandle": _channelHandle
      }).then((handle) => BackendlessMessaging._userStatusCallbacks[handle] =
          new EventCallback(callback, onError));

  void removeUserStatusListener(Function callback) {
    List<int> handles = _findCallbacks(
        BackendlessMessaging._userStatusCallbacks,
        (eventCallback) => eventCallback.handleResponse == callback);

    handles.forEach((handle) {
      _methodChannel.invokeMethod(
          "Backendless.Messaging.Channel.removeUserStatusListener",
          <String, dynamic>{"channelHandle": _channelHandle, 'handle': handle});
      BackendlessMessaging._userStatusCallbacks.remove(handle);
    });
  }

  void removeUserStatusListeners() {
    BackendlessMessaging._userStatusCallbacks.clear();
    _methodChannel.invokeMethod(
        "Backendless.Messaging.Channel.removeUserStatusListeners",
        <String, dynamic>{
          "channelHandle": _channelHandle,
        });
  }

  List<int> _findCallbacks(Map<int, EventCallback> callbacks,
      bool test(EventCallback eventCallback)) {
    List<int> toRemove = [];
    callbacks.forEach((handle, callback) {
      if (test(callback)) {
        toRemove.add(handle);
      }
    });
    return toRemove;
  }
}
