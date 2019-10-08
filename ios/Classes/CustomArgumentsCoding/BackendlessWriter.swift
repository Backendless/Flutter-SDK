
import Flutter
import Backendless

// MARK: -
// MARK: - BackendlessWriter
class BackendlessWtiter: FlutterStandardWriter {
    
    // MARK: -
    // MARK: - Constants
    private struct Args {
        static let status = "status"
        static let type = "type"
    }
    
    // MARK: -
    // MARK: - Write Value
    override func writeValue(_ value: Any) {
        switch value {
        case is Date:
            writeDate(value as! Date)
        case is GeoPoint, is DataQueryBuilder, is LoadRelationsQueryBuilder, is ObjectProperty,
             is BackendlessFileInfo, is GeoCategory, is BackendlessGeoQuery, is GeoCluster,
             is SearchMatchesResult, is MessageStatus, is DeviceRegistration, is PublishOptions,
             is DeliveryOptions, is PublishMessageInfo, is DeviceRegistrationResult,
             is UserInfo, is ReconnectAttemptObject, is BackendlessUser, is UserProperty,
             is BulkEvent, is EmailEnvelope:
            guard let jsonData = dataFromValue(value) else { return }
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
            writeCode(for: value)
            
            if value is MessageStatus {
                let jsonToWrite = prepareJsonForMessageStatus(json)
                super.writeValue(jsonToWrite)
            } else if value is ObjectProperty || value is UserProperty {
                let jsonToWrite = prepareJsonForObjectProperty(json)
                super.writeValue(jsonToWrite)
            } else {
                super.writeValue(json)
            }
        case is CommandObject:
            let commandObject = value as! CommandObject
            let json = commandObject.encodeToJson()
            writeCode(for: value)
            super.writeValue(json)
        case is UserStatus:
            let json = jsonFrom(userStatus: value as! UserStatus)
            writeCode(for: value)
            super.writeValue(json)
        default:
            super.writeValue(value)
        }
    }
    
    // MARK: -
    // MARK: - Write Date
    private func writeDate(_ date: Date) {
        writeByte(FlutterTypeCode.dateTime.rawValue)
        writeValue(Int(date.timeIntervalSince1970))
    }
    
    // MARK: -
    // MARK: - DataFromValue
    private func dataFromValue(_ value: Any) -> Data? {
        switch value {
        case is GeoCluster:
            return try? JSONEncoder().encode(value as! GeoCluster)
        case is GeoPoint:
            return try? JSONEncoder().encode(value as! GeoPoint)
        case is DataQueryBuilder:
            return try? JSONEncoder().encode(value as! DataQueryBuilder)
        case is LoadRelationsQueryBuilder:
            return try? JSONEncoder().encode(value as! LoadRelationsQueryBuilder)
        case is UserProperty:
            return try? JSONEncoder().encode(value as! UserProperty)
        case is ObjectProperty:
            return try? JSONEncoder().encode(value as! ObjectProperty)
        case is BackendlessFileInfo:
            return try? JSONEncoder().encode(value as! BackendlessFileInfo)
        case is GeoCategory:
            return try? JSONEncoder().encode(value as! GeoCategory)
        case is BackendlessGeoQuery:
            return try? JSONEncoder().encode(value as! BackendlessGeoQuery)
        case is SearchMatchesResult:
            return try? JSONEncoder().encode(value as! SearchMatchesResult)
        case is MessageStatus:
            return try? JSONEncoder().encode(value as! MessageStatus)
        case is DeviceRegistration:
            return try? JSONEncoder().encode(value as! DeviceRegistration)
        case is PublishOptions:
            return try? JSONEncoder().encode(value as! PublishOptions)
        case is DeliveryOptions:
            return try? JSONEncoder().encode(value as! DeliveryOptions)
        case is PublishMessageInfo:
            return try? JSONEncoder().encode(value as! PublishMessageInfo)
        case is DeviceRegistrationResult:
            return try? JSONEncoder().encode(value as! DeviceRegistrationResult)
        case is UserInfo:
            return try? JSONEncoder().encode(value as! UserInfo)
        case is ReconnectAttemptObject:
            return try? JSONEncoder().encode(value as! ReconnectAttemptObject)
        case is BackendlessUser:
            return try? JSONEncoder().encode(value as! BackendlessUser)
        case is BulkEvent:
            return try? JSONEncoder().encode(value as! BulkEvent)
        case is EmailEnvelope:
            return try? JSONEncoder().encode(value as! EmailEnvelope)
        default:
            return nil
        }
    }
    
    // MARK: -
    // MARK: - WriteCodeForValue
    private func writeCode(for value: Any) {
        switch value {
        case is GeoCluster:
            writeByte(FlutterTypeCode.geoCluster.rawValue)
        case is GeoPoint:
            writeByte(FlutterTypeCode.geoPoint.rawValue)
        case is DataQueryBuilder:
            writeByte(FlutterTypeCode.dataQueryBuilder.rawValue)
        case is LoadRelationsQueryBuilder:
            writeByte(FlutterTypeCode.loadRelationsQueryBuilder.rawValue)
        case is UserProperty:
            writeByte(FlutterTypeCode.userProperty.rawValue)
        case is ObjectProperty:
            writeByte(FlutterTypeCode.objectProperty.rawValue)
        case is BackendlessFileInfo:
            writeByte(FlutterTypeCode.fileInfo.rawValue)
        case is GeoCategory:
            writeByte(FlutterTypeCode.geoCategory.rawValue)
        case is BackendlessGeoQuery:
            writeByte(FlutterTypeCode.geoQuery.rawValue)
        case is SearchMatchesResult:
            writeByte(FlutterTypeCode.searchMatchesResult.rawValue)
        case is MessageStatus:
            writeByte(FlutterTypeCode.messageStatus.rawValue)
        case is DeviceRegistration:
            writeByte(FlutterTypeCode.deviceRegistration.rawValue)
        case is PublishOptions:
            writeByte(FlutterTypeCode.publishOptions.rawValue)
        case is DeliveryOptions:
            writeByte(FlutterTypeCode.deliveryOptions.rawValue)
        case is PublishMessageInfo:
            writeByte(FlutterTypeCode.publishMessageInfo.rawValue)
        case is DeviceRegistrationResult:
            writeByte(FlutterTypeCode.deviceRegistrationResult.rawValue)
        case is CommandObject:
            writeByte(FlutterTypeCode.command.rawValue)
        case is UserInfo:
            writeByte(FlutterTypeCode.userInfo.rawValue)
        case is UserStatus:
            writeByte(FlutterTypeCode.userStatusResponse.rawValue)
        case is ReconnectAttemptObject:
            writeByte(FlutterTypeCode.reconnectAttempt.rawValue)
        case is BackendlessUser:
            writeByte(FlutterTypeCode.backendlessUser.rawValue)
        case is BulkEvent:
            writeByte(FlutterTypeCode.bulkEvent.rawValue)
        case is EmailEnvelope:
            writeByte(FlutterTypeCode.emailEnvelope.rawValue)
        default:
            break
        }
    }
    
    private func prepareJsonForMessageStatus(_ json: Any) -> [String: Any] {
        guard let inputDict = json as? [String: Any] else { return [:] }
        var result = inputDict
        
        inputDict.forEach {
            if $0.key == Args.status, let stringValue = $0.value as? String {
                let enumValue = PublishStatusEnum(rawValue: stringValue)
                result[$0.key] = enumValue.index
            }
        }
        
        return result
    }
    
    private func prepareJsonForObjectProperty(_ json: Any) -> [String: Any] {
        guard let inputDict = json as? [String: Any] else { return [:] }
        var result = inputDict
        
        inputDict.forEach {
            if $0.key == Args.type, let stringValue = $0.value as? String {
                let enumValue = DataTypeEnum(rawValue: stringValue) ?? .UNKNOWN
                result[$0.key] = enumValue.index
            }
        }
        
        return result
    }
    
    private func jsonFrom(userStatus: UserStatus) -> [String: Any] {
        var result: [String: Any] = [:]
        
        if let statusString = userStatus.status, let status = UserStatusEnum(rawValue: statusString) {
            result["status"] = status.index
        }
        
        if let data = userStatus.data {
            result["data"] = data
        }
        
        return result
    }
}
