import 'package:test/test.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/services.dart';

class TestClassesSending {
  static void start() {
    group('Classes Sending Tests', () {
      final testChannel = MethodChannel(
          'backendless/test', StandardMethodCodec(BackendlessMessageCodec()));

      final sendValue = (dynamic value) => testChannel
          .invokeMethod("Backendless.test", <String, dynamic>{"value": value});

      test("DateTime", () async {
        final timestamp = 1569883362000;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

        DateTime receivedValue = await sendValue(date);

        expect(receivedValue, date);
      });

      test("DataQueryBuilder", () async {
        final queryBuilder = DataQueryBuilder()
          ..groupBy = ["test_first", "test_second"]
          ..offset = 10
          ..pageSize = 42
          ..properties = ["test_property"]
          ..related = ["test_related_first", "test_related_second"]
          ..relationsDepth = 42
          // TODO: add this field when Android implementation will be ready
          // ..relationsPageSize = 21
          ..sortBy = ["test_sort_by"]
          ..whereClause = "testing where_clause";

        DataQueryBuilder receivedValue = await sendValue(queryBuilder);

        expect(receivedValue.toJson(), queryBuilder.toJson());
      });

      test("LoadRelationsQueryBuilder", () async {
        final queryBuilder = LoadRelationsQueryBuilder.of("relationName");
        queryBuilder
          ..offset = 10
          ..pageSize = 42
          ..properties = ["test_first", "test_second"]
          ..sortBy = ["test_sort"];

        LoadRelationsQueryBuilder receivedValue = await sendValue(queryBuilder);

        expect(receivedValue.toJson(), queryBuilder.toJson());
      });

      test("ObjectProperty", () async {
        final property = ObjectProperty()
          ..defaultValue = "test_value"
          ..name = "test_name"
          ..relatedTable = "test_related_table"
          ..required = true
          ..type = DataTypeEnum.COLLECTION;

        ObjectProperty receivedValue = await sendValue(property);

        expect(receivedValue.toJson(), property.toJson());
      });

      test("FileInfo", () async {
        final info = FileInfo()
          ..createdOn = 42
          ..name = "test_name"
          ..publicUrl = "test_public_url://url.net"
          ..size = 4242
          ..url = "test_url://url.net";

        FileInfo receivedValue = await sendValue(info);

        expect(receivedValue.toJson(), info.toJson());
      });

      test("MessageStatus", () async {
        final status = MessageStatus()
          ..errorMessage = "test_error_message"
          ..messageId = "TEST_MESSAGE_ID"
          ..status = PublishStatusEnum.FAILED;

        MessageStatus receivedValue = await sendValue(status);

        expect(receivedValue.toJson(), status.toJson());
      });

      test("DeviceRegistration", () async {
        final registration = DeviceRegistration()
          ..channels = ["test_channel_1", "test_channel_2", "test_channel_3"]
          ..deviceId = "TEST_DEVICE_ID"
          ..deviceToken = "TEST_TOKEN"
          ..expiration = DateTime.now()
          ..id = "TEST_ID"
          ..os = "TEST_OS"
          ..osVersion = 10;

        DeviceRegistration receivedValue = await sendValue(registration);

        expect(receivedValue.channels, registration.channels);
        expect(receivedValue.deviceId, registration.deviceId);
        expect(receivedValue.deviceToken, registration.deviceToken);
        expect(receivedValue.expiration.millisecondsSinceEpoch,
            registration.expiration.millisecondsSinceEpoch);
        expect(receivedValue.id, registration.id);
        expect(receivedValue.os, registration.os);
        expect(receivedValue.osVersion, registration.osVersion);
      });

      test("PublishOptions", () async {
        final options = PublishOptions()
          ..headers = {"test_key": "test_value", "test_2": "42"}
          ..publisherId = "TEST_PUBLISHER_ID";

        PublishOptions receivedValue = await sendValue(options);

        expect(receivedValue.toJson(), options.toJson());
      });

      test("DeliveryOptions", () async {
        final options = DeliveryOptions()
          ..publishAt = DateTime.now()
          ..publishPolicy = PublishPolicyEnum.BOTH
          ..pushBroadcast = 42
          ..pushSinglecast = ["test_first", "test_2"]
          ..repeatEvery = 21
          ..repeatExpiresAt = DateTime.now().add(Duration(minutes: 42))
          ..segmentQuery = "test_segment_query";

        DeliveryOptions receivedValue = await sendValue(options);

        expect(receivedValue.publishAt.millisecondsSinceEpoch,
            options.publishAt.millisecondsSinceEpoch);
        expect(receivedValue.publishPolicy, options.publishPolicy);
        expect(receivedValue.pushBroadcast, options.pushBroadcast);
        expect(receivedValue.pushSinglecast, options.pushSinglecast);
        expect(receivedValue.repeatEvery, options.repeatEvery);
        expect(receivedValue.repeatExpiresAt.millisecondsSinceEpoch,
            options.repeatExpiresAt.millisecondsSinceEpoch);
        expect(receivedValue.segmentQuery, options.segmentQuery);
      });

      test("PublishMessageInfo", () async {
        final info = PublishMessageInfo()
          ..headers = {"test_key": "test_value", "test_second": "222"}
          ..message = 42.42
          ..publishAt = 1111
          ..publisherId = "TEST_PUBLISHER_ID"
          ..publishPolicy = "TEST_STRING"
          ..pushBroadcast = "TEST_BROADCAST"
          ..pushSinglecast = ["test_singlecast"]
          ..query = "test_query"
          ..repeatEvery = 42
          ..repeatExpiresAt = 3643
          ..subtopic = "test_subtopic"
          ..timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round()
          ..messageId = "TEST_MESSAGE_ID";

        PublishMessageInfo receivedValue = await sendValue(info);

        expect(receivedValue.toJson(), info.toJson());
      });

      test("DeviceRegistrationResult", () async {
        final jsonResult = {
          'deviceToken': "TEST_TOKEN",
          'channelRegistrations': {"test_channel": "test_token"},
        };
        final registrationResult =
            DeviceRegistrationResult.fromJson(jsonResult);

        DeviceRegistrationResult receivedValue =
            await sendValue(registrationResult);

        expect(receivedValue.toJson(), registrationResult.toJson());
      });

      // Includes UserInfo,
      // so we don't write separate test for that class
      test("Command", () async {
        final userInfo = UserInfo()
          ..connectionId = "test_connection_id"
          ..userId = "test_user_id";
        final commandString = Command.string()
          ..data = "test_string"
          ..type = "test_type"
          ..userInfo = userInfo;
        final commandMap = Command.map()
          ..data = {"test_key": "test_value", "test_2": 42}
          ..type = "test_map_type"
          ..userInfo = userInfo;

        Command<dynamic> receivedCommandString = await sendValue(commandString);

        expect(receivedCommandString.toJson(), commandString.toJson());

        Command<dynamic> receivedCommandMap = await sendValue(commandMap);

        expect(receivedCommandMap.toJson(), commandMap.toJson());
      });

      test("UserStatusResponse", () async {
        final userInfoFirst = UserInfo()
          ..connectionId = "1"
          ..userId = "111";
        final userInfoSecond = UserInfo()
          ..connectionId = "222"
          ..userId = "222222";
        final response = UserStatusResponse()
          ..data = [userInfoFirst, userInfoSecond]
          ..status = UserStatus.CONNECTED;

        UserStatusResponse receivedValue = await sendValue(response);

        expect(receivedValue.toJson(), response.toJson());
      });

      test("ReconnectAttempt", () async {
        final json = {
          'timeout': 21,
          'attempt': 42,
        };
        final attempt = ReconnectAttempt.fromJson(json);

        ReconnectAttempt receivedValue = await sendValue(attempt);

        expect(receivedValue.toJson(), attempt.toJson());
      });

      test("BackendlessUser", () async {
        final user = BackendlessUser()
          ..email = "test_email@test.test"
          ..password = "test_password"
          ..setProperty("prop_1", "value")
          ..setProperty("prop_two", 42);

        BackendlessUser receivedValue = await sendValue(user);

        expect(user.email, receivedValue.email);
        expect(user.password, receivedValue.password);
        expect(user.properties["prop_1"], receivedValue.properties["prop_1"]);
        expect(
            user.properties["prop_two"], receivedValue.properties["prop_two"]);
      });

      test("UserProperty", () async {
        final property = UserProperty()
          ..identity = false
          ..name = "test_name"
          ..required = true
          ..type = DataTypeEnum.DOUBLE;

        UserProperty receivedValue = await sendValue(property);

        expect(receivedValue.toJson(), property.toJson());
      });

      test("BulkEvent", () async {
        final event = BulkEvent()
          ..count = 42
          ..whereClause = "test_where_clause";

        BulkEvent receivedValue = await sendValue(event);

        expect(receivedValue.toJson(), event.toJson());
      });

      test("EmailEnvelope", () async {
        final envelope = EmailEnvelope()
          ..bcc = Set<String>.from(["first", "test_2", "3"])
          ..cc = Set<String>.from(["111", "222_test", "3_TEST"])
          ..query = "test_query"
          ..to = Set<String>.from(
              ["a_test@aa.co", "222_test@mmm.ug", "3_TEST@uu.aa"]);

        EmailEnvelope receivedValue = await sendValue(envelope);

        expect(receivedValue.toJson(), envelope.toJson());
      });
      test("Point", () async {
        final point = Point()
          ..latitude = 42.42
          ..longitude = 1.01;

        Point receivedValue = await sendValue(point);
        expect(receivedValue.asWKT(), point.asWKT());
      });
      test("LineString", () async {
        final lineString = LineString();
        List<Point> points = [
          Point(x: 1.0, y: 2.0),
          Point(x: 42.42, y: 21.21),
          Point(x: -10.5, y: -100),
        ];
        lineString.points = points;

        LineString receivedValue = await sendValue(lineString);
        expect(receivedValue.asWKT(), lineString.asWKT());
      });
      test("Polygon", () async {
        final polygon = Geometry.fromWKT<Polygon>(
            "POLYGON((0.5 0.5,5 0,5 5,0 5,0.5 0.5), (1.5 1,4 3,4 1,1.5 1))");

        Polygon receivedValue = await sendValue(polygon);
        expect(receivedValue.asWKT(), polygon.asWKT());
      });
    });
  }
}
