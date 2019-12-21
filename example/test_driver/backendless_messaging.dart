import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

class TestMessaging {
  static void start() {
    group("", () {
      final messaging = Backendless.messaging;
      String publishedMessageId;
      String delayedMessageId;
      String email = "andrew.bodnar@backendless.consulting";
      String subject = "Test Subject";

      String htmlMessage = """
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>title</title>
  </head>
  <body>BODY</body>
</html>
      """;
      String textMessage = "Test Text";

      test("Publish Without Delay", () async {
        final messageStatus = await messaging.publish(textMessage);
        publishedMessageId = messageStatus.messageId;

        expect(messageStatus, isNotNull);
        expect(messageStatus.messageId, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      // Server need time to publish message
      // That's why we need delay to get correct status
      test("Get Message Status", () async {
        final messageFuture = Future.delayed(Duration(seconds: 3),
            () => messaging.getMessageStatus(publishedMessageId));
        final messageStatus = await messageFuture;

        expect(messageStatus, isNotNull);
        expect(messageStatus.messageId, publishedMessageId);
        expect(messageStatus.status, PublishStatusEnum.PUBLISHED);
      });

      test("Publish With Delay", () async {
        final dateToPublish = DateTime.now().add(Duration(minutes: 10));
        final deliveryOptions = DeliveryOptions()..publishAt = dateToPublish;
        final messageStatus = await messaging.publish(textMessage,
            deliveryOptions: deliveryOptions);
        delayedMessageId = messageStatus.messageId;

        expect(messageStatus, isNotNull);
        expect(messageStatus.messageId, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      test("Cancel", () async {
        final messageStatus = await messaging.cancel(delayedMessageId);

        expect(messageStatus, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.CANCELLED);
        expect(messageStatus.messageId, delayedMessageId);
      });

      test("Push With Template", () async {
        final messageStatus = await messaging.pushWithTemplate("TestTemplate");

        expect(messageStatus, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      test("Send Email", () async {
        final bodyParts = BodyParts(textMessage, htmlMessage);
        final messageStatus =
            await messaging.sendEmail(subject, bodyParts, [email]);

        expect(messageStatus, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      test("Send Text Email", () async {
        final messageStatus =
            await messaging.sendTextEmail(subject, textMessage, [email]);

        expect(messageStatus, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      test("Send HTML Email", () async {
        final messageStatus =
            await messaging.sendHTMLEmail(subject, htmlMessage, [email]);

        expect(messageStatus, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      test("Send Email From Template", () async {
        final envelope = EmailEnvelope()
          ..to = Set.from([email])
          ..cc = Set.from([email])
          ..bcc = Set.from([email]);

        final messageStatus =
            await messaging.sendEmailFromTemplate("TestTemplate", envelope);

        expect(messageStatus, isNotNull);
        expect(messageStatus.status, PublishStatusEnum.SCHEDULED);
      });

      test("Subscribe", () async {
        final channelName = "test_channel";
        final channel = await messaging.subscribe(channelName);

        expect(channel, isNotNull);
        expect(channel.channelName, channelName);
      });
    });
  }
}
