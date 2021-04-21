@JS()

library backendless_messaging_web;

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../js_util.dart';

class MessagingCallHandler {
  MethodChannel _channel;
  Map<int, ChannelJs> channels = Map();
  Map<int, Function> messageCallbacks = Map();
  int _nextMessageHandle = 0;

  MessagingCallHandler(this._channel);

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {
      case "Backendless.Messaging.cancel":
        return promiseToFuture(cancel(call.arguments['messageId'])).then(
            (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.getMessageStatus":
        return promiseToFuture(getMessageStatus(call.arguments['messageId']))
            .then(
                (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.publish":
        PublishOptions? publishOptions = call.arguments['publishOptions'];
        DeliveryOptions? deliveryOptions = call.arguments['deliveryOptions'];
        return promiseToFuture(publish(
                call.arguments['channelName'],
                call.arguments['message'],
                convertToJs(publishOptions?.toJson() as Map),
                convertToJs(deliveryOptions?.toJson() as Map)))
            .then(
                (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.pushWithTemplate":
        return promiseToFuture(pushWithTemplate(call.arguments['templateName'],
                convertToJs(call.arguments['templateValues'])))
            .then(
                (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.sendEmail":
        return promiseToFuture(sendEmail(
                call.arguments['subject'],
                convertToJs({
                  'textmessage': call.arguments['textMessage'],
                  'htmlmessage': call.arguments['htmlMessage']
                }),
                convertToJs(call.arguments['recipients']),
                convertToJs(call.arguments['attachments'])))
            .then(
                (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.sendHTMLEmail":
        return promiseToFuture(sendEmail(
                call.arguments['subject'],
                convertToJs({'htmlmessage': call.arguments['messageBody']}),
                convertToJs(call.arguments['recipients']),
                null))
            .then(
                (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.sendTextEmail":
        return promiseToFuture(sendEmail(
                call.arguments['subject'],
                convertToJs({'textmessage': call.arguments['messageBody']}),
                convertToJs(call.arguments['recipients']),
                null))
            .then(
                (value) => MessageStatus.fromJson(convertFromJs(value) as Map));
      case "Backendless.Messaging.sendEmailFromTemplate":
        EmailEnvelope emailEnvelope = call.arguments['envelope'];
        final emailEnvelopeMap = {
          'addresses': emailEnvelope.to,
          'ccAddresses': emailEnvelope.cc,
          'bccAddresses': emailEnvelope.bcc,
        };
        return promiseToFuture(sendEmailFromTemplate(
          call.arguments['templateName'],
          EmailEnvelopeJs(convertToJs(emailEnvelopeMap)),
          convertToJs(call.arguments['templateValues']),
        )).then((value) => MessageStatus.fromJson(convertFromJs(value) as Map));

      case "Backendless.Messaging.subscribe":
        ChannelJs channel = subscribe(call.arguments['channelName']);
        channels[call.arguments['channelHandle']] = channel;
        return Future(() => null);
      case "Backendless.Messaging.Channel.addMessageListener":
        return Future(() => addMessageListener(call));
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "Backendless plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  int addMessageListener(MethodCall call) {
    int channelHandle = call.arguments["channelHandle"];
    String selector = call.arguments["selector"];
    String messageType = call.arguments["messageType"];

    int messageHandle = _nextMessageHandle++;

    ChannelJs channel = channels[channelHandle]!;

    Function callback = getCallback("Message", messageHandle, messageType);
    channel.addMessageListener(selector, allowInterop(callback));
    messageCallbacks[messageHandle] = callback;
    return messageHandle;
  }

  Function getCallback(String method, int handle, String messageType) {
    return (jsResponse) {
      Map response = convertFromJs(jsResponse) as Map;
      Map args = {"handle": handle};
      switch (messageType) {
        case 'String':
          args["response"] = response['message'];
          break;
        case 'PublishMessageInfo':
          args["response"] = PublishMessageInfo.fromJson(response);
          break;
        case 'Map':
          args["response"] = response;
          break;
      }
      _channel.invokeMethod(
          "Backendless.Messaging.Channel.$method.EventResponse", args);
    };
  }
}

@JS('Backendless.Messaging.cancel')
external dynamic cancel(String messageId);

@JS('Backendless.Messaging.getMessageStatus')
external dynamic getMessageStatus(String messageId);

@JS('Backendless.Messaging.publish')
external dynamic publish(String channelName, dynamic message,
    dynamic publishOptions, dynamic deliveryOptions);

@JS('Backendless.Messaging.pushWithTemplate')
external dynamic pushWithTemplate(String templateName, dynamic templateValues);

@JS('Backendless.Messaging.sendEmail')
external dynamic sendEmail(
    String subject, dynamic bodyParts, dynamic recipients, dynamic attachments);

@JS('Backendless.Messaging.sendEmailFromTemplate')
external dynamic sendEmailFromTemplate(
    String templateName, dynamic envelope, dynamic templateValues);

@JS('Backendless.Messaging.subscribe')
external ChannelJs subscribe(String channelName);

@JS('Backendless.Messaging.EmailEnvelope')
class EmailEnvelopeJs {
  external factory EmailEnvelopeJs(dynamic data);
}

@JS('Backendless.Messaging.Channel')
class ChannelJs {
  external factory ChannelJs(options, app);

  @JS()
  external dynamic addMessageListener(selector, callback);
}
