
import Flutter
import Backendless

// MARK: -
// MARK: - BackendlessWriter
class BackendlessWtiter: FlutterStandardWriter {
    
    
    // MARK: -
    // MARK: - Write Value
    override func writeValue(_ value: Any) {
        switch value {
        case is Date:
            writeDate(value as! Date)
        case is GeoPoint, is DataQueryBuilder, is LoadRelationsQueryBuilder, is ObjectProperty,
             is BackendlessFileInfo, is GeoCategory, is BackendlessGeoQuery, is GeoCluster,
//             is MatchesResult,
             is MessageStatus, is DeviceRegistration,
//             is Message
             is PublishOptions, is DeliveryOptions, is PublishMessageInfo,
//             is DeviceRegistrationResult
//             is Command
             is UserInfo,
//             is UserStatusResponse
             is ReconnectAttemptObject, is BackendlessUser, is UserProperty, is BulkEvent:
            guard let jsonData = dataFromValue(value) else { return }
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
            writeCodeForValue(value)
            super.writeValue(json)
        default:
            super.writeValue(value)
        }
    }
    
    // MARK: -
    // MARK: - Write Date
    private func writeDate(_ date: Date) {
        writeValue(FlutterTypeCode.dateTime.rawValue)
        writeValue(date.timeIntervalSince1970)
    }
    
    // MARK: -
    // MARK: - DataFromValue
    private func dataFromValue(_ value: Any) -> Data? {
        switch value {
        case is GeoPoint:
            return try? JSONEncoder().encode(value as! GeoPoint)
        case is DataQueryBuilder:
            return try? JSONEncoder().encode(value as! DataQueryBuilder)
        case is LoadRelationsQueryBuilder:
            return try? JSONEncoder().encode(value as! LoadRelationsQueryBuilder)
        case is ObjectProperty:
            return try? JSONEncoder().encode(value as! ObjectProperty)
        case is BackendlessFileInfo:
            return try? JSONEncoder().encode(value as! BackendlessFileInfo)
        case is GeoCategory:
            return try? JSONEncoder().encode(value as! GeoCategory)
        case is BackendlessGeoQuery:
            return try? JSONEncoder().encode(value as! BackendlessGeoQuery)
        case is GeoCluster:
            return try? JSONEncoder().encode(value as! GeoCluster)
            //        case is MatchesResult:
        //            return try? JSONEncoder().encode(value as! MatchesResult)
        case is MessageStatus:
            return try? JSONEncoder().encode(value as! MessageStatus)
        case is DeviceRegistration:
            return try? JSONEncoder().encode(value as! DeviceRegistration)
            //        case is Message:
        //            return try? JSONEncoder().encode(value as! Message)
        case is PublishOptions:
            return try? JSONEncoder().encode(value as! PublishOptions)
        case is DeliveryOptions:
            return try? JSONEncoder().encode(value as! DeliveryOptions)
        case is PublishMessageInfo:
            return try? JSONEncoder().encode(value as! PublishMessageInfo)
            //        case is DeviceRegistrationResult:
            //            return try? JSONEncoder().encode(value as! DeviceRegistrationResult)
            //        case is Command:
        //            return try? JSONEncoder().encode(value as! Command)
        case is UserInfo:
            return try? JSONEncoder().encode(value as! UserInfo)
            //        case is UserStatusResponse:
        //            return try? JSONEncoder().encode(value as! UserStatusResponse)
        case is ReconnectAttemptObject:
            return try? JSONEncoder().encode(value as! ReconnectAttemptObject)
        case is BackendlessUser:
            return try? JSONEncoder().encode(value as! BackendlessUser)
        case is UserProperty:
            return try? JSONEncoder().encode(value as! UserProperty)
        case is BulkEvent:
            return try? JSONEncoder().encode(value as! BulkEvent)
        default:
            return nil
        }
    }
    
    // MARK: -
    // MARK: - WriteCodeForValue
    private func writeCodeForValue(_ value: Any) {
        switch value {
        case is GeoPoint:
            writeValue(FlutterTypeCode.geoPoint.rawValue)
        case is DataQueryBuilder:
            writeValue(FlutterTypeCode.dataQueryBuilder.rawValue)
        case is LoadRelationsQueryBuilder:
            writeValue(FlutterTypeCode.loadRelationsQueryBuilder.rawValue)
        case is ObjectProperty:
            writeValue(FlutterTypeCode.objectProperty.rawValue)
        case is BackendlessFileInfo:
            writeValue(FlutterTypeCode.fileInfo.rawValue)
        case is GeoCategory:
            writeValue(FlutterTypeCode.geoCategory.rawValue)
        case is BackendlessGeoQuery:
            writeValue(FlutterTypeCode.geoQuery.rawValue)
        case is GeoCluster:
            writeValue(FlutterTypeCode.geoCluster.rawValue)
            //        case is MatchesResult:
        //            writeValue(FlutterTypeCode.searchMathesResult.rawValue)
        case is MessageStatus:
            writeValue(FlutterTypeCode.messageStatus.rawValue)
        case is DeviceRegistration:
            writeValue(FlutterTypeCode.deviceRegistration.rawValue)
            //        case is Message:
        //            writeValue(FlutterTypeCode.message.rawValue)
        case is PublishOptions:
            writeValue(FlutterTypeCode.publishOptions.rawValue)
        case is DeliveryOptions:
            writeValue(FlutterTypeCode.deliveryOptions.rawValue)
        case is PublishMessageInfo:
            writeValue(FlutterTypeCode.publishMessageInfo.rawValue)
            //        case is DeviceRegistrationResult:
            //            writeValue(FlutterTypeCode.deviceRegistrationResult.rawValue)
            //        case is Command:
        //            writeValue(FlutterTypeCode.command.rawValue)
        case is UserInfo:
            writeValue(FlutterTypeCode.userInfo.rawValue)
            //        case is UserStatusResponse:
        //            writeValue(FlutterTypeCode.userStatusResponse.rawValue)
        case is ReconnectAttemptObject:
            writeValue(FlutterTypeCode.reconnectAttempt.rawValue)
        case is BackendlessUser:
            writeValue(FlutterTypeCode.backendlessUser.rawValue)
        case is UserProperty:
            writeValue(FlutterTypeCode.userProperty.rawValue)
        case is BulkEvent:
            writeValue(FlutterTypeCode.bulkEvent.rawValue)
        default:
            break
        }
    }
    
    // TODO: - GeoPoint
    // TODO: - How to get distance?
    
    // TODO: - ObjectProperty
    // TODO: - How to get Int value of DataTypeEnum?
    
    // TODO: - BackendlessGeoQuery
    // TODO: - How to get RelativeFindMetadata?
    // TODO: - How to get RelativeFindPercentThreshold?
    // TODO: - How to get SortBy?
    // TODO: - How to send data with Collection type in Java?
    // TODO: - How is SearchRectangle described in iOS SDK?
    
    // TODO: - BackendlessGeoCluster
    // TODO: - How to send data with Collection type in Java?
    // TODO: - How to get distance?
    
    // TODO: - MessageStatus
    // TODO: - Convert String to PublishStatusEnum Int value
    
    // TODO: - PublishOptions
    // TODO: - No subtopic in PublishOptions Swift Class
    
    // TODO: - DeliveryOptions
    // TODO: - No segmentQuery in Swift DeliveryOptions
    
    // TODO: - PublishMessageInfo
    // TODO: - No repeatExpiresAt: Date property in PublishMessageInfo Class
}
