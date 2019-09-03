part of backendless_sdk;

class BackendlessMessaging {
  static const String DEFAULT_CHANNEL_NAME = "default";
  static const MethodChannel _channel = const MethodChannel(
      'backendless/messaging', StandardMethodCodec(BackendlessMessageCodec()));
  static final Map<int, EventCallback> _joinCallbacks = <int, EventCallback>{};
  static final Map<int, EventCallback> _messageCallbacks =
      <int, EventCallback>{};
  static final Map<int, EventCallback> _commandCallbacks =
      <int, EventCallback>{};
  static final Map<int, EventCallback> _userStatusCallbacks =
      <int, EventCallback>{};
  int _channelHandle = 0;

  factory BackendlessMessaging() => _instance;
  static final BackendlessMessaging _instance =
      new BackendlessMessaging._internal();

  BackendlessMessaging._internal() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method.contains("EventResponse")) {
        Map<dynamic, dynamic> arguments = call.arguments;
        int handle = arguments["handle"];
        var response = arguments["response"];

        switch (call.method) {
          case ("Backendless.Messaging.Channel.Join.EventResponse"):
            _joinCallbacks[handle].handleResponse();
            break;
          case ("Backendless.Messaging.Channel.Message.EventResponse"):
            _messageCallbacks[handle].handleResponse(response);
            break;
          case ("Backendless.Messaging.Channel.Command.EventResponse"):
            _commandCallbacks[handle].handleResponse(response);
            break;
          case ("Backendless.Messaging.Channel.UserStatus.EventResponse"):
            _userStatusCallbacks[handle].handleResponse(response);
            break;
        }
      } else if (call.method.contains("EventFault")) {
        int handle = call.arguments["handle"];
        String fault = call.arguments["fault"];

        switch (call.method) {
          case ("Backendless.Messaging.Channel.Join.EventFault"):
            _joinCallbacks[handle].handleFault(fault);
            break;
          case ("Backendless.Messaging.Channel.Message.EventFault"):
            _messageCallbacks[handle].handleFault(fault);
            break;
          case ("Backendless.Messaging.Channel.Command.EventFault"):
            _commandCallbacks[handle].handleFault(fault);
            break;
          case ("Backendless.Messaging.Channel.UserStatus.EventFault"):
            _userStatusCallbacks[handle].handleFault(fault);
            break;
        }
      }
    });
  }

  Future<MessageStatus> cancel(String messageId) => _channel.invokeMethod(
      "Backendless.Messaging.cancel",
      <String, dynamic>{"messageId": messageId});

  Future<DeviceRegistration> getDeviceRegistration() =>
      _channel.invokeMethod("Backendless.Messaging.getDeviceRegistration");

  Future<MessageStatus> getMessageStatus(String messageId) =>
      _channel.invokeMethod("Backendless.Messaging.getMessageStatus",
          <String, dynamic>{"messageId": messageId});

  Future<MessageStatus> publish(Object message,
      {String channelName,
      PublishOptions publishOptions,
      DeliveryOptions deliveryOptions}) => _channel
        .invokeMethod("Backendless.Messaging.publish", <String, dynamic>{
      "message": message,
      "channelName": channelName,
      "publishOptions": publishOptions,
      "deliveryOptions": deliveryOptions
    });

  Future<MessageStatus> pushWithTemplate(String templateName) =>
      _channel.invokeMethod("Backendless.Messaging.pushWithTemplate",
          <String, dynamic>{"templateName": templateName});

  Future<DeviceRegistrationResult> registerDevice(
          [List<String> channels, DateTime expiration]) =>
      _channel.invokeMethod("Backendless.Messaging.registerDevice",
          <String, dynamic>{"channels": channels, "expiration": expiration});

  Future<MessageStatus> sendEmail(
          String subject, BodyParts bodyParts, List<String> recipients,
          [List<String> attachments]) =>
      _channel
          .invokeMethod("Backendless.Messaging.sendEmail", <String, dynamic>{
        "textMessage": bodyParts.textMessage,
        "htmlMessage": bodyParts.htmlMessage,
        "subject": subject,
        "recipients": recipients,
        "attachments": attachments
      });

  Future<MessageStatus> sendHTMLEmail(
          String subject, String messageBody, List<String> recipients) =>
      _channel.invokeMethod(
          "Backendless.Messaging.sendHTMLEmail", <String, dynamic>{
        "subject": subject,
        "messageBody": messageBody,
        "recipients": recipients
      });

  Future<MessageStatus> sendTextEmail(
          String subject, String messageBody, List<String> recipients) =>
      _channel.invokeMethod(
          "Backendless.Messaging.sendTextEmail", <String, dynamic>{
        "subject": subject,
        "messageBody": messageBody,
        "recipients": recipients
      });

  Future<int> unregisterDevice([List<String> channels]) =>
      _channel.invokeMethod("Backendless.Messaging.unregisterDevice",
          <String, dynamic>{"channels": channels});

  Future<MessageStatus> sendEmailFromTemplate(
          String templateName, EmailEnvelope envelope,
          [Map<String, String> templateValues]) =>
      _channel.invokeMethod(
          "Backendless.Messaging.sendEmailFromTemplate", <String, dynamic>{
        "templateName": templateName,
        "envelope": envelope,
        "templateValues": templateValues
      });

  Future<Channel> subscribe([String channelName = DEFAULT_CHANNEL_NAME]) async {
    int handle = _channelHandle++;
    return _channel.invokeMethod(
        "Backendless.Messaging.subscribe", <String, dynamic>{
      "channelName": channelName,
      "channelHandle": handle
    }).then((value) => new Channel(_channel, channelName, handle));
  }
}
