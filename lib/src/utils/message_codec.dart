part of backendless_sdk;

class BackendlessMessageCodec extends StandardMessageCodec {
  const BackendlessMessageCodec();

  static const int _kDateTime = 128;
  static const int _kDataQueryBuilder = 130;
  static const int _kLoadRelationsQueryBuilder = 131;
  static const int _kObjectProperty = 132;
  static const int _kGooglePlaySubscriptionStatus = 133;
  static const int _kGooglePlayPurchaseStatus = 134;
  static const int _kFileInfo = 135;
  static const int _kMessageStatus = 140;
  static const int _kDeviceRegistration = 141;
  static const int _kPublishOptions = 143;
  static const int _kDeliveryOptions = 144;
  static const int _kPublishMessageInfo = 145;
  static const int _kDeviceRegistrationResult = 146;
  static const int _kCommand = 147;
  static const int _kUserInfo = 148;
  static const int _kUserStatusResponse = 149;
  static const int _kReconnectAttempt = 150;
  static const int _kBackendlessUser = 151;
  static const int _kUserProperty = 152;
  static const int _kBulkEvent = 153;
  static const int _kEmailEnvelope = 154;
  static const int _kPoint = 155;
  static const int _kLineString = 156;
  static const int _kPolygon = 157;
  static const int _kRelationStatus = 158;
  static const int _kBackendlessFault = 159;
  static const int _kBackendlessException = 160;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is DateTime) {
      buffer.putUint8(_kDateTime);
      writeValue(buffer, value.millisecondsSinceEpoch);
    } else if (value is DataQueryBuilder) {
      buffer.putUint8(_kDataQueryBuilder);
      writeValue(buffer, value.toJson());
    } else if (value is LoadRelationsQueryBuilder) {
      buffer.putUint8(_kLoadRelationsQueryBuilder);
      writeValue(buffer, value.toJson());
    } else if (value is ObjectProperty) {
      buffer.putUint8(_kObjectProperty);
      writeValue(buffer, value.toJson());
    } else if (value is GooglePlaySubscriptionStatus) {
      buffer.putUint8(_kGooglePlaySubscriptionStatus);
      writeValue(buffer, value.toJson());
    } else if (value is GooglePlayPurchaseStatus) {
      buffer.putUint8(_kGooglePlayPurchaseStatus);
      writeValue(buffer, value.toJson());
    } else if (value is FileInfo) {
      buffer.putUint8(_kFileInfo);
      writeValue(buffer, value.toJson());
    } else if (value is MessageStatus) {
      buffer.putUint8(_kMessageStatus);
      writeValue(buffer, value.toJson());
    } else if (value is DeviceRegistration) {
      buffer.putUint8(_kDeviceRegistration);
      writeValue(buffer, value.toJson());
    } else if (value is PublishOptions) {
      buffer.putUint8(_kPublishOptions);
      writeValue(buffer, value.toJson());
    } else if (value is DeliveryOptions) {
      buffer.putUint8(_kDeliveryOptions);
      writeValue(buffer, value.toJson());
    } else if (value is PublishMessageInfo) {
      buffer.putUint8(_kPublishMessageInfo);
      writeValue(buffer, value.toJson());
    } else if (value is DeviceRegistrationResult) {
      buffer.putUint8(_kDeviceRegistrationResult);
      writeValue(buffer, value.toJson());
    } else if (value is Command) {
      buffer.putUint8(_kCommand);
      writeValue(buffer, value.toJson());
    } else if (value is UserInfo) {
      buffer.putUint8(_kUserInfo);
      writeValue(buffer, value.toJson());
    } else if (value is UserStatusResponse) {
      buffer.putUint8(_kUserStatusResponse);
      writeValue(buffer, value.toJson());
    } else if (value is ReconnectAttempt) {
      buffer.putUint8(_kReconnectAttempt);
      writeValue(buffer, value.toJson());
    } else if (value is BackendlessUser) {
      buffer.putUint8(_kBackendlessUser);
      writeValue(buffer, value.toJson());
    } else if (value is UserProperty) {
      buffer.putUint8(_kUserProperty);
      writeValue(buffer, value.toJson());
    } else if (value is BulkEvent) {
      buffer.putUint8(_kBulkEvent);
      writeValue(buffer, value.toJson());
    } else if (value is EmailEnvelope) {
      buffer.putUint8(_kEmailEnvelope);
      writeValue(buffer, value.toJson());
    } else if (value is Point) {
      buffer.putUint8(_kPoint);
      writeValue(buffer, value.asWKT());
    } else if (value is LineString) {
      buffer.putUint8(_kLineString);
      writeValue(buffer, value.asWKT());
    } else if (value is Polygon) {
      buffer.putUint8(_kPolygon);
      writeValue(buffer, value.asWKT());
    } else if (value is RelationStatus) {
      buffer.putUint8(_kRelationStatus);
      writeValue(buffer, value.toJson());
    } else if (value is Set) {
      writeValue(buffer, value.toList());
    } else if (value is BackendlessFault) {
      buffer.putUint8(_kBackendlessFault);
      writeValue(buffer, value.toJson());
    } else if (value is BackendlessException) {
      buffer.putUint8(_kBackendlessException);
      writeValue(buffer, value.toJson());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case _kDateTime:
        return DateTime.fromMillisecondsSinceEpoch(readValue(buffer) as int);
      case _kDataQueryBuilder:
        return DataQueryBuilder.fromJson(readValue(buffer) as Map);
      case _kLoadRelationsQueryBuilder:
        return LoadRelationsQueryBuilder.fromJson(readValue(buffer) as Map);
      case _kObjectProperty:
        return ObjectProperty.fromJson(readValue(buffer) as Map);
      case _kGooglePlaySubscriptionStatus:
        return GooglePlaySubscriptionStatus.fromJson(readValue(buffer) as Map);
      case _kGooglePlayPurchaseStatus:
        return GooglePlayPurchaseStatus.fromJson(readValue(buffer) as Map);
      case _kFileInfo:
        return FileInfo.fromJson(readValue(buffer) as Map);
      case _kMessageStatus:
        return MessageStatus.fromJson(readValue(buffer) as Map);
      case _kDeviceRegistration:
        return DeviceRegistration.fromJson(readValue(buffer) as Map);
      case _kPublishOptions:
        return PublishOptions.fromJson(readValue(buffer) as Map);
      case _kDeliveryOptions:
        return DeliveryOptions.fromJson(readValue(buffer) as Map);
      case _kPublishMessageInfo:
        return PublishMessageInfo.fromJson(readValue(buffer) as Map);
      case _kDeviceRegistrationResult:
        return DeviceRegistrationResult.fromJson(readValue(buffer) as Map);
      case _kCommand:
        return Command.fromJson(readValue(buffer) as Map);
      case _kUserInfo:
        return UserInfo.fromJson(readValue(buffer) as Map);
      case _kUserStatusResponse:
        return UserStatusResponse.fromJson(readValue(buffer) as Map);
      case _kReconnectAttempt:
        return ReconnectAttempt.fromJson(readValue(buffer) as Map);
      case _kBackendlessUser:
        return BackendlessUser.fromJson(readValue(buffer) as Map);
      case _kUserProperty:
        return UserProperty.fromJson(readValue(buffer) as Map);
      case _kBulkEvent:
        return BulkEvent.fromJson(readValue(buffer) as Map);
      case _kEmailEnvelope:
        return EmailEnvelope.fromJson(readValue(buffer) as Map);
      case _kPoint:
        return Geometry.fromWKT(readValue(buffer) as String);
      case _kLineString:
        return Geometry.fromWKT(readValue(buffer) as String);
      case _kPolygon:
        return Geometry.fromWKT(readValue(buffer) as String);
      case _kRelationStatus:
        return RelationStatus.fromJson(readValue(buffer) as Map);
      case _kBackendlessFault:
        return BackendlessFault.fromJson(readValue(buffer) as Map);
      case _kBackendlessException:
        return BackendlessException.fromJson(readValue(buffer) as Map);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
