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
      buffer.putInt64(value.millisecondsSinceEpoch);
    } else if (value is GeoPoint) {
      _writeGeoPoint(buffer, value);
    } else if (value is DataQueryBuilder) {
      _writeDataQueryBuilder(buffer, value);
    } else if (value is LoadRelationsQueryBuilder) {
      _writeLoadRelationsQueryBuilder(buffer, value);
    } else if (value is ObjectProperty) {
      _writeObjectProperty(buffer, value);
    } else if (value is GooglePlaySubscriptionStatus) {
      _writeGooglePlaySubscriptionStatus(buffer, value);
    } else if (value is GooglePlayPurchaseStatus) {
      _writeGooglePlayPurchaseStatus(buffer, value);
    } else if (value is FileInfo) {
      _writeFileInfo(buffer, value);
    } else if (value is GeoCategory) {
      _writeGeoCategory(buffer, value);
    } else if (value is BackendlessGeoQuery) {
      _writeBackendlessGeoQuery(buffer, value);
    } else if (value is GeoCluster) {
      _writeGeoCluster(buffer, value);
    } else if (value is SearchMatchesResult) {
      _writeSearchMatchesResult(buffer, value);
    } else if (value is MessageStatus) {
      _writeMessageStatus(buffer, value);
    } else if (value is DeviceRegistration) {
      _writeDeviceRegistration(buffer, value);
    } else if (value is Message) {
      _writeMessage(buffer, value);
    } else if (value is PublishOptions) {
      _writePublishOptions(buffer, value);
    } else if (value is DeliveryOptions) {
      _writeDeliveryOptions(buffer, value);
    } else if (value is Command) {
      _writeCommand(buffer, value);
    } else if (value is UserInfo) {
      _writeUserInfo(buffer, value);
    } else if (value is BackendlessUser) {
      _writeBackendlessUser(buffer, value);
    } else if (value is UserProperty) {
      _writeUserProperty(buffer, value);
    } else if (value is BulkEvent) {
      _writeBulkEvent(buffer, value);
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
        return GeoPoint.of(
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String>(),
            readValue(buffer)?.cast<String, Object>(),
            readValue(buffer));
      case _kObjectProperty:
        return new ObjectProperty(
            relatedTable: readValue(buffer),
            defaultValue: readValue(buffer),
            name: readValue(buffer),
            required: readValue(buffer),
            type: DateTypeEnum.values[readValue(buffer)]);
      case _kGooglePlaySubscriptionStatus:
        return new GooglePlaySubscriptionStatus(
            autoRenewing: readValue(buffer),
            startTimeMillis: readValue(buffer),
            kind: readValue(buffer),
            expiryTimeMillis: readValue(buffer));
      case _kGooglePlayPurchaseStatus:
        return new GooglePlayPurchaseStatus(
            kind: readValue(buffer),
            purchaseTimeMillis: readValue(buffer),
            purchaseState: readValue(buffer),
            consumptionState: readValue(buffer),
            developerPayload: readValue(buffer));
      case _kFileInfo:
        return new FileInfo(
            name: readValue(buffer),
            createdOn: readValue(buffer),
            publicUrl: readValue(buffer),
            url: readValue(buffer),
            size: readValue(buffer));
      case _kGeoCategory:
        return new GeoCategory(
            id: readValue(buffer),
            name: readValue(buffer),
            size: readValue(buffer));
      case _kGeoQuery:
        return new BackendlessGeoQuery.of(
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String>(),
            readValue(buffer)?.cast<String, Object>(),
            readValue(buffer)?.cast<String, String>(),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String>(),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            Units.values[readValue(buffer)],
            readValue(buffer),
            readValue(buffer));
      case _kGeoCluster:
        return GeoCluster.of(
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String>(),
            readValue(buffer)?.cast<String, Object>(),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer));
      case _kSearchMatchesResult:
        return new SearchMatchesResult(readValue(buffer), readValue(buffer));
      case _kMessageStatus:
        return new MessageStatus(readValue(buffer), readValue(buffer),
            PublishStatusEnum.values[readValue(buffer)]);
      case _kDeviceRegistration:
        return new DeviceRegistration(
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String>());
      case _kMessage:
        return new Message(
            readValue(buffer),
            readValue(buffer)?.cast<String, String>(),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer));
      case _kPublishOptions:
        return new PublishOptions(readValue(buffer), readValue(buffer),
            readValue(buffer)?.cast<String, String>());
      case _kDeliveryOptions:
        return new DeliveryOptions.of(
            readValue(buffer),
            readValue(buffer)?.cast<String>(),
            readValue(buffer),
            PublishPolicyEnum.values[readValue(buffer)],
            readValue(buffer),
            readValue(buffer),
            readValue(buffer));
      case _kPublishMessageInfo:
        return new PublishMessageInfo.of(
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String>(),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer),
            readValue(buffer)?.cast<String, String>());
      case _kDeviceRegistrationResult:
        return new DeviceRegistrationResult(
            readValue(buffer), readValue(buffer)?.cast<String, String>());
      case _kCommand:
        String dataType = readValue(buffer);
        if (dataType == "String")
          return Command.string()
            ..type = readValue(buffer)
            ..data = readValue(buffer)
            ..userInfo = readValue(buffer);
        else if (dataType == "Map")
          return Command.map()
            ..type = readValue(buffer)
            ..data = readValue(buffer)
            ..userInfo = readValue(buffer);
        throw new UnimplementedError();
      case _kUserInfo:
        return new UserInfo(readValue(buffer), readValue(buffer));
      case _kUserStatusResponse:
        return new UserStatusResponse(UserStatus.values[readValue(buffer)],
            readValue(buffer)?.cast<UserInfo>());
      case _kReconnectAttempt:
        return new ReconnectAttempt(readValue(buffer), readValue(buffer));
      case _kBackendlessUser:
        return new BackendlessUser()
          ..setProperties(readValue(buffer)?.cast<String, dynamic>());
      case _kUserProperty:
        return new UserProperty(readValue(buffer), readValue(buffer),
            DateTypeEnum.values[readValue(buffer)], readValue(buffer));
      case _kBulkEvent:
        return new BulkEvent(readValue(buffer), readValue(buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  _writeGeoPoint(WriteBuffer buffer, GeoPoint value) {
    buffer.putUint8(_kGeoPoint);
    writeValue(buffer, value.objectId);
    writeValue(buffer, value.latitude);
    writeValue(buffer, value.longitude);
    writeValue(buffer, List.of(value.categories));
    writeValue(buffer, value.metadata);
    writeValue(buffer, value.distance);
  }

  _writeDataQueryBuilder(WriteBuffer buffer, DataQueryBuilder value) {
    buffer.putUint8(_kDataQueryBuilder);
    writeValue(buffer, value.properties);
    writeValue(buffer, value.whereClause);
    writeValue(buffer, value.groupByList);
    writeValue(buffer, value.havingClause);
    buffer.putInt32(value.pageSize);
    buffer.putInt32(value.offset);
    writeValue(buffer, value.sortByList);
    writeValue(buffer, value.relatedList);
    buffer.putInt32(value.relationsDepth);
  }

  _writeLoadRelationsQueryBuilder(
      WriteBuffer buffer, LoadRelationsQueryBuilder value) {
    buffer.putUint8(_kLoadRelationsQueryBuilder);
    writeValue(buffer, value.relationName);
    buffer.putInt32(value.pageSize);
    buffer.putInt32(value.offset);
  }

  _writeObjectProperty(WriteBuffer buffer, ObjectProperty value) {
    buffer.putUint8(_kObjectProperty);
    writeValue(buffer, value.relatedTable);
    writeValue(buffer, value.defaultValue);
    writeValue(buffer, value.name);
    writeValue(buffer, value.required);
    writeValue(buffer, value.type.index);
  }

  _writeGooglePlaySubscriptionStatus(
      WriteBuffer buffer, GooglePlaySubscriptionStatus value) {
    buffer.putUint8(_kGooglePlaySubscriptionStatus);
    writeValue(buffer, value.autoRenewing);
    writeValue(buffer, value.startTimeMillis);
    writeValue(buffer, value.kind);
    writeValue(buffer, value.expiryTimeMillis);
  }

  _writeGooglePlayPurchaseStatus(
      WriteBuffer buffer, GooglePlayPurchaseStatus value) {
    buffer.putUint8(_kGooglePlayPurchaseStatus);
    writeValue(buffer, value.kind);
    writeValue(buffer, value.purchaseTimeMillis);
    writeValue(buffer, value.purchaseState);
    writeValue(buffer, value.consumptionState);
    writeValue(buffer, value.developerPayload);
  }

  _writeFileInfo(WriteBuffer buffer, FileInfo value) {
    buffer.putUint8(_kFileInfo);
    writeValue(buffer, value.name);
    writeValue(buffer, value.createdOn);
    writeValue(buffer, value.publicUrl);
    writeValue(buffer, value.url);
    writeValue(buffer, value.size);
  }

  _writeGeoCategory(WriteBuffer buffer, GeoCategory value) {
    buffer.putUint8(-_kGeoCategory);
    writeValue(buffer, value.objectId);
    writeValue(buffer, value.name);
    writeValue(buffer, value.size);
  }

  _writeBackendlessGeoQuery(WriteBuffer buffer, BackendlessGeoQuery value) {
    buffer.putUint8(_kGeoQuery);
    writeValue(buffer, value.latitude);
    writeValue(buffer, value.longitude);
    writeValue(buffer, value.radius);
    writeValue(buffer, List.of(value.categories));
    writeValue(buffer, value.metadata);
    writeValue(buffer, value.relativeFindMetadata);
    writeValue(buffer, value.relativeFindPercentThreshold);
    writeValue(buffer, value.whereClause);
    writeValue(buffer, List.of(value.sortBy));
    writeValue(buffer, value.dpp);
    writeValue(buffer, value.clusterGridSize);
    writeValue(buffer, value.pageSize);
    writeValue(buffer, value.offset);
    writeValue(buffer, value.units.index);
    writeValue(buffer, value.includeMeta);
    writeValue(buffer, value.searchRectangle);
  }

  _writeGeoCluster(WriteBuffer buffer, GeoCluster value) {
    buffer.putUint8(_kGeoCluster);
    writeValue(buffer, value.objectId);
    writeValue(buffer, value.latitude);
    writeValue(buffer, value.longitude);
    writeValue(buffer, List.of(value.categories));
    writeValue(buffer, value.metadata);
    writeValue(buffer, value.distance);
    writeValue(buffer, value.totalPoints);
    writeValue(buffer, value.geoQuery);
  }

  _writeSearchMatchesResult(WriteBuffer buffer, SearchMatchesResult value) {
    buffer.putUint8(_kSearchMatchesResult);
    writeValue(buffer, value.matches);
    writeValue(buffer, value.geoPoint);
  }

  _writeMessageStatus(WriteBuffer buffer, MessageStatus value) {
    buffer.putUint8(_kMessageStatus);
    writeValue(buffer, value.messageId);
    writeValue(buffer, value.errorMessage);
    writeValue(buffer, value.status.index);
  }

  _writeDeviceRegistration(WriteBuffer buffer, DeviceRegistration value) {
    buffer.putUint8(_kDeviceRegistration);
    writeValue(buffer, value.id);
    writeValue(buffer, value.deviceToken);
    writeValue(buffer, value.deviceId);
    writeValue(buffer, value.os);
    writeValue(buffer, value.osVersion);
    writeValue(buffer, value.expiration);
    writeValue(buffer, value.channels);
  }

  _writeMessage(WriteBuffer buffer, Message value) {
    buffer.putUint8(_kMessage);
    writeValue(buffer, value.messageId);
    writeValue(buffer, value.headers);
    writeValue(buffer, value.data);
    writeValue(buffer, value.publisherId);
    writeValue(buffer, value.timestamp);
  }

  _writePublishOptions(WriteBuffer buffer, PublishOptions value) {
    buffer.putUint8(_kPublishOptions);
    writeValue(buffer, value.publisherId);
    writeValue(buffer, value.headers);
    writeValue(buffer, value.subtopic);
  }

  _writeDeliveryOptions(WriteBuffer buffer, DeliveryOptions value) {
    buffer.putUint8(_kDeliveryOptions);
    writeValue(buffer, value.pushBroadcast);
    writeValue(buffer, value.pushSinglecast);
    writeValue(buffer, value.segmentQuery);
    writeValue(buffer, value.publishPolicy.index);
    writeValue(buffer, value.publishAt);
    writeValue(buffer, value.repeatEvery);
    writeValue(buffer, value.repeatExpiresAt);
  }

  _writeCommand(WriteBuffer buffer, Command value) {
    buffer.putUint8(_kCommand);
    print("ALOOOOOOO: " + value.dataType.toString());
    writeValue(buffer, value.dataType.toString());
    writeValue(buffer, value.type);
    writeValue(buffer, value.data);
    writeValue(buffer, value.userInfo);
  }

  _writeUserInfo(WriteBuffer buffer, UserInfo value) {
    buffer.putUint8(_kUserInfo);
    writeValue(buffer, value.connectionId);
    writeValue(buffer, value.userId);
  }

  _writeBackendlessUser(WriteBuffer buffer, BackendlessUser value) {
    buffer.putUint8(_kBackendlessUser);
    writeValue(buffer, value.properties);
  }

  _writeUserProperty(WriteBuffer buffer, UserProperty value) {
    buffer.putUint8(_kUserProperty);
    writeValue(buffer, value.name);
    writeValue(buffer, value.required);
    writeValue(buffer, value.type.index);
    writeValue(buffer, value.identity);
  }

  _writeBulkEvent(WriteBuffer buffer, BulkEvent value) {
    buffer.putUint8(_kBulkEvent);
    writeValue(buffer, value.whereClause);
    writeValue(buffer, value.count);
  }
}
