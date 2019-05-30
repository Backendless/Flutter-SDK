
import Flutter
import Backendless

// MARK: -
// MARK: - BackendlessReader
class BackendlessReader: FlutterStandardReader {
    
    // MARK: -
    // MARK: - Read Value
    override func readValue(ofType type: UInt8) -> Any? {
        let code = FlutterTypeCode(rawValue: type)
        
        return code != nil ? readCustomValue(byCode: code!) : super.readValue(ofType: type)
    }
    
    // MARK: -
    // MARK: - Read Custom Value
    private func readCustomValue(byCode code: FlutterTypeCode) -> Any? {
        var value: Any?

        switch code {
        case .dateTime:
            value = readDate()
        default:
            guard let json: [String: Any] = readValue().flatMap(cast) else { return nil }
            value = decode(from: json, code)
        }

        return value
    }
    
    // MARK: -
    // MARK: - Read Date
    private func readDate() -> Date? {
        return readValue()
            .flatMap(cast)
            .map { Date(timeIntervalSince1970: $0) }
    }
    
    private func decode(from json: [String: Any], _ code: FlutterTypeCode) -> Any? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else { return nil }
        
        switch code {
        case .dateTime:
            return nil
        case .geoPoint:
            return try? JSONDecoder().decode(GeoPoint.self, from: jsonData)
        case .dataQueryBuilder:
            return try? JSONDecoder().decode(DataQueryBuilder.self, from: jsonData)
        case .loadRelationsQueryBuilder:
            return try? JSONDecoder().decode(LoadRelationsQueryBuilder.self, from: jsonData)
        case .objectProperty:
            return try? JSONDecoder().decode(ObjectProperty.self, from: jsonData)
        case .googlePlaySubscriptionStatus:
            return nil
        case .googlePlayPurchaseStatus:
            return nil
        case .fileInfo:
            return try? JSONDecoder().decode(BackendlessFileInfo.self, from: jsonData)
        case .geoCategory:
            return try? JSONDecoder().decode(GeoCategory.self, from: jsonData)
        case .geoQuery:
            return try? JSONDecoder().decode(BackendlessGeoQuery.self, from: jsonData)
        case .geoCluster:
            return try? JSONDecoder().decode(GeoCluster.self, from: jsonData)
        case .searchMathesResult:
//            return try? JSONDecoder().decode(MathesResult.self, from: jsonData)
            return nil
        case .messageStatus:
            return try? JSONDecoder().decode(MessageStatus.self, from: jsonData)
        case .deviceRegistration:
            return try? JSONDecoder().decode(DeviceRegistration.self, from: jsonData)
        case .message:
//            return try? JSONDecoder().decode(Message.self, from: jsonData)
            return nil
        case .publishOptions:
            return try? JSONDecoder().decode(PublishOptions.self, from: jsonData)
        case .deliveryOptions:
            return try? JSONDecoder().decode(DeliveryOptions.self, from: jsonData)
        case .publishMessageInfo:
            return try? JSONDecoder().decode(PublishMessageInfo.self, from: jsonData)
        case .deviceRegistrationResult:
//            return try? JSONDecoder().decode(DeviceRegistrationResult.self, from: jsonData)
            return nil
        case .command:
//            return try? JSONDecoder().decode(Command.self, from: jsonData)
            return nil
        case .userInfo:
            return try? JSONDecoder().decode(UserInfo.self, from: jsonData)
        case .userStatusResponse:
//            return try? JSONDecoder().decode(UserStatusResponse.self, from: jsonData)
            return nil
        case .reconnectAttempt:
            return try? JSONDecoder().decode(ReconnectAttemptObject.self, from: jsonData)
        case .backendlessUser:
            return try? JSONDecoder().decode(BackendlessUser.self, from: jsonData)
        case .userProperty:
            return try? JSONDecoder().decode(UserProperty.self, from: jsonData)
        case .bulkEvent:
            return try? JSONDecoder().decode(BulkEvent.self, from: jsonData)
        }
    }
}
