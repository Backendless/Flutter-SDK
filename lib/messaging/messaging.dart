part of backendless_sdk;

typedef void MessageHandler(RemoteMessage message);

class Messaging {
  static const String DEFAULT_CHANNEL_NAME = 'default';
  bool initialized = false;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<MessageStatus?> pushWithTemplate(String templateName,
      {Map<String, dynamic>? templateValues}) async {
    Map<String, dynamic>? parameters = templateValues;
    if (parameters == null) parameters = Map<String, dynamic>();

    return await Invoker.post('/messaging/push/$templateName', parameters);
  }

  Future<MessageStatus?> publish<T>(T message,
      {String channelName = 'default',
      PublishOptions? publishOptions,
      DeliveryOptions? deliveryOptions}) async {
    var messageToPublish = reflector.isCustomClass(message)
        ? reflector.serialize(message)
        : message;

    Map<String, dynamic> parameters = {'message': messageToPublish};

    if (publishOptions?.headers != null)
      parameters['headers'] = publishOptions!.headers;

    if (publishOptions?.publisherId != null)
      parameters['publisherId'] = publishOptions!.publisherId;

    if (deliveryOptions?.publishAt != null)
      parameters['publishAt'] = deliveryOptions!.publishAt;

    if (deliveryOptions?.repeatEvery != null)
      parameters['repeatEvery'] = deliveryOptions!.repeatEvery;

    if (deliveryOptions?.repeatExpiresAt != null)
      parameters['repeatExpiresAt'] = deliveryOptions!.repeatExpiresAt;

    if (deliveryOptions?.publishPolicy != null)
      parameters['publishPolicy'] = deliveryOptions!.publishPolicy;

    if (deliveryOptions?.pushBroadcast != null)
      parameters['pushBroadcast'] = deliveryOptions!.pushBroadcast;

    if (deliveryOptions?.pushSinglecast != null)
      parameters['pushSinglecast'] = deliveryOptions!.pushSinglecast;

    if (deliveryOptions?.segmentQuery != null)
      parameters['segmentQuery'] = deliveryOptions!.segmentQuery;

    return Invoker.post('/messaging/$channelName', parameters);
  }

  Future<MessageStatus?> cancelScheduledMessage(String messageId) async {
    return await Invoker.delete('/messaging/$messageId');
  }

  Future<MessageStatus?> getMessageStatus(String messageId) async {
    return await Invoker.get('/messaging/$messageId');
  }

  Future<DeviceRegistrationResult?> registerDevice(
      {List<String>? channels = const ['default'],
      DateTime? expiration,
      MessageHandler? onMessage}) async {
    await Firebase.initializeApp();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessaging.getToken();
    Map<String, String> deviceInfo = await _getDeviceDetails();

    Map<String, dynamic> parameters = {
      'deviceToken': deviceToken,
      'deviceId': deviceInfo['identifier'],
      'osVersion': deviceInfo['deviceVersion'],
      'os': deviceInfo['deviceName'],
    };

    FirebaseMessaging.onMessage.listen((event) async {
      onMessage!.call(event);
    });

    initialized = true;
    return await Invoker.post('/messaging/registrations', parameters);
  }

  Future<DeviceRegistration?> getDeviceRegistration() async {
    Map<String, String> deviceInfo = await _getDeviceDetails();
    String? deviceId = deviceInfo['identifier'];

    return await Invoker.get('/messaging/registrations/$deviceId');
  }

  Future<bool> unregisterDevice() async {
    Map<String, String> deviceInfo = await _getDeviceDetails();
    String? deviceId = deviceInfo['identifier'];

    return await Invoker.delete('/messaging/registrations/$deviceId');
  }

  Future<MessageStatus?> sendEmail(
      String subject, BodyParts bodyParts, List<String> recipients,
      {List<String>? attachments}) async {
    Map<String, dynamic> parameters = {
      'subject': subject,
      'to': recipients,
    };
    Map<String, String> bodypartsValue = {};

    if (bodyParts.textMessage.isNotEmpty)
      bodypartsValue['textmessage'] = bodyParts.textMessage;
    if (bodyParts.htmlMessage.isNotEmpty)
      bodypartsValue['htmlmessage'] = bodyParts.htmlMessage;

    parameters['bodyparts'] = bodypartsValue;

    if (attachments?.isNotEmpty ?? false)
      parameters['attachments'] = attachments;

    return await Invoker.post('/messaging/email', parameters);
  }

  Future<MessageStatus?> sendEmailFromTemplate(
      String templateName, EmailEnvelope envelope,
      {Map? templateValues}) async {
    Map<String, dynamic> parameters = {
      'templateName': templateName,
      'addressed': envelope.to,
      'cc-addresses': envelope.cc,
      'bcc-addresses': envelope.bcc,
      'criteria': envelope.query,
    };

    if (templateValues?.isNotEmpty ?? false)
      parameters['template-values'] = templateValues;

    return await Invoker.post('/emailtemplate/send', parameters);
  }

  ///TODO: Add subscribe method
  Channel subscribe({String? channelName}) {
    if (channelName == null) channelName = 'default';

    return Channel(channelName);
  }

  Future<Map<String, String>> _getDeviceDetails() async {
    String deviceName = '';
    String deviceVersion = '';
    String identifier = '';
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (io.Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (io.Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return {
      'deviceName': deviceName,
      'deviceVersion': deviceVersion,
      'identifier': identifier
    };
  }
}
