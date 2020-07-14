@JS()

library backendless_messaging_web;

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../js_util.dart';

class MessagingCallHandler {
  MethodChannel _channel;

  MessagingCallHandler(this._channel);

  Future<dynamic> handleMethodCall(MethodCall call) {
    switch (call.method) {    
      case "Backendless.Messaging.cancel":
        return promiseToFuture(
          cancel(call.arguments['messageId'])
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.getMessageStatus":
        return promiseToFuture(
          getMessageStatus(call.arguments['messageId'])
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.publish":
      PublishOptions publishOptions = call.arguments['publishOptions'];
      DeliveryOptions deliveryOptions = call.arguments['deliveryOptions'];
        return promiseToFuture(
          publish(call.arguments['channelName'],
          call.arguments['message'],
          convertToJs(publishOptions?.toJson()),
          convertToJs(deliveryOptions?.toJson()))
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.pushWithTemplate":
        return promiseToFuture(
          pushWithTemplate(call.arguments['templateName'])
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.sendEmail":
        return promiseToFuture(
          sendEmail(
            call.arguments['subject'],
             convertToJs({'textmessage': call.arguments['textMessage'], 'htmlmessage': call.arguments['htmlMessage']}),
            convertToJs(call.arguments['recipients']),
            convertToJs(call.arguments['attachments'])
            )
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.sendHTMLEmail":
        return promiseToFuture(
          sendEmail(
            call.arguments['subject'],
            convertToJs({'htmlmessage': call.arguments['messageBody']}), 
            convertToJs(call.arguments['recipients']),
            null)
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.sendTextEmail":
        return promiseToFuture(
          sendEmail(
            call.arguments['subject'],
            convertToJs({'textmessage': call.arguments['messageBody']}), 
            convertToJs(call.arguments['recipients']),
            null)
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      case "Backendless.Messaging.sendEmailFromTemplate":
        EmailEnvelope emailEnvelope = call.arguments['envelope'];
        final emailEnvelopeMap = {
          'addresses': emailEnvelope.to,
          'ccAddresses': emailEnvelope.cc,
          'bccAddresses': emailEnvelope.bcc,
        };
        return promiseToFuture(
          
          sendEmailFromTemplate(
            call.arguments['templateName'],
            EmailEnvelopeJs(  convertToJs(emailEnvelopeMap)   ),
            convertToJs(call.arguments['templateValues']),
            )
        ).then((value) => MessageStatus.fromJson(jsToMap(value)));
      
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "Backendless plugin for web doesn't implement "
              "the method '${call.method}'");
    }
  }
}

@JS('Backendless.Messaging.cancel')
external dynamic cancel(String messageId);

@JS('Backendless.Messaging.getMessageStatus')
external dynamic getMessageStatus(String messageId);

@JS('Backendless.Messaging.publish')
external dynamic publish(String channelName, dynamic message, dynamic publishOptions, dynamic deliveryOptions);

@JS('Backendless.Messaging.pushWithTemplate')
external dynamic pushWithTemplate(String templateName);

@JS('Backendless.Messaging.sendEmail')
external dynamic sendEmail(String subject, dynamic bodyParts, dynamic recipients, dynamic attachments);

@JS('Backendless.Messaging.sendEmailFromTemplate')
external dynamic sendEmailFromTemplate(String templateName, dynamic envelope, dynamic templateValues);

@JS('Backendless.Messaging.EmailEnvelope')
class EmailEnvelopeJs {
  external factory EmailEnvelopeJs(dynamic data);
}