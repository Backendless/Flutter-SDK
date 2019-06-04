import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:backendless_sdk/src/modules/modules.dart';
import 'package:backendless_sdk/src/utils/utils.dart';

class BackendlessMessageCodec extends StandardMessageCodec {
  const BackendlessMessageCodec();

  static const int _kDateTime = 128;
  static const int _kGeoPoint = 129;
  static const int _kDataQueryBuilder = 130;
  static const int _kLoadRelationsQueryBuilder = 131;
  static const int _kObjectProperty = 132;
  static const int _kGooglePlaySubscriptionStatus = 133;
  static const int _kGooglePlayPurchaseStatus = 134;
  static const int _kFileInfo = 135;
  static const int _kGeoCategory = 136;
  static const int _kGeoQuery = 137;
  static const int _kGeoCluster = 138;
  static const int _kSearchMatchesResult = 139;
  static const int _kMessageStatus = 140;
  static const int _kDeviceRegistration = 141;
  static const int _kMessage = 142;
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

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is DateTime) {
      buffer.putUint8(_kDateTime);
      writeValue(buffer, value.millisecondsSinceEpoch);
    } else if (value is GeoPoint && !(value is GeoCluster)) {
      buffer.putUint8(_kGeoPoint);
      writeValue(buffer, value.toJson());
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
    } else if (value is GeoCategory) {
      buffer.putUint8(_kGeoCategory);
      writeValue(buffer, value.toJson());
    } else if (value is BackendlessGeoQuery) {
      buffer.putUint8(_kGeoQuery);
      writeValue(buffer, value.toJson());
    } else if (value is GeoCluster) {
      buffer.putUint8(_kGeoCluster);
      writeValue(buffer, value.toJson());
    } else if (value is SearchMatchesResult) {
      buffer.putUint8(_kSearchMatchesResult);
      writeValue(buffer, value.toJson());
    } else if (value is MessageStatus) {
      buffer.putUint8(_kMessageStatus);
      writeValue(buffer, value.toJson());
    } else if (value is DeviceRegistration) {
      buffer.putUint8(_kDeviceRegistration);
      writeValue(buffer, value.toJson());
    } else if (value is Message) {
      buffer.putUint8(_kMessage);
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
    } else if (value is BackendlessUser) {
      buffer.putUint8(_kBackendlessUser);
      writeValue(buffer, value.toJson());
    } else if (value is UserProperty) {
      buffer.putUint8(_kUserProperty);
      writeValue(buffer, value.toJson());
    } else if (value is BulkEvent) {
      buffer.putUint8(_kBulkEvent);
      writeValue(buffer, value.toJson());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case _kDateTime:
        return DateTime.fromMillisecondsSinceEpoch(buffer.getInt64());
      case _kGeoPoint:
        return GeoPoint.fromJson(readValue(buffer));
      case _kObjectProperty:
        return ObjectProperty.fromJson(readValue(buffer));
      case _kGooglePlaySubscriptionStatus:
        return GooglePlaySubscriptionStatus.fromJson(readValue(buffer));
      case _kGooglePlayPurchaseStatus:
        return GooglePlayPurchaseStatus.fromJson(readValue(buffer));
      case _kFileInfo:
        return FileInfo.fromJson(readValue(buffer));
      case _kGeoCategory:
        return GeoCategory.fromJson(readValue(buffer));
      case _kGeoQuery:
        return BackendlessGeoQuery.fromJson(readValue(buffer));
      case _kGeoCluster:
        return GeoCluster.fromJson(readValue(buffer));
      case _kSearchMatchesResult:
        return SearchMatchesResult.fromJson(readValue(buffer));
      case _kMessageStatus:
        return MessageStatus.fromJson(readValue(buffer));
      case _kDeviceRegistration:
        return DeviceRegistration.fromJson(readValue(buffer));
      case _kMessage:
        return Message.fromJson(readValue(buffer));
      case _kPublishOptions:
        return PublishOptions.fromJson(readValue(buffer));
      case _kDeliveryOptions:
        return DeliveryOptions.fromJson(readValue(buffer));
      case _kPublishMessageInfo:
        return PublishMessageInfo.fromJson(readValue(buffer));
      case _kDeviceRegistrationResult:
        return DeviceRegistrationResult.fromJson(readValue(buffer));
      case _kCommand:
        return Command.fromJson(readValue(buffer));
      case _kUserInfo:
        return UserInfo.fromJson(readValue(buffer));
      case _kUserStatusResponse:
        return UserStatusResponse.fromJson(readValue(buffer));
      case _kReconnectAttempt:
        return ReconnectAttempt.fromJson(readValue(buffer));
      case _kBackendlessUser:
        return BackendlessUser.fromJson(readValue(buffer));
      case _kUserProperty:
        return UserProperty.fromJson(readValue(buffer));
      case _kBulkEvent:
        return BulkEvent.fromJson(readValue(buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}