
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
        case .point:
            value = readPoint()
        case .lineString:
            value = readLineString()
        case .polygon:
            value = readPolygon()
        default:
            guard let json: [String: Any] = readValue().flatMap(cast) else { return nil }
            let jsonWithDates = mapDateValues(json)
            let jsonToDecode: [String: Any]
            switch code {
            case .backendlessUser:
                jsonToDecode = mapUser(jsonWithDates)
            case .messageStatus:
                jsonToDecode = mapMessageStatus(jsonWithDates)
            case .command:
                jsonToDecode = mapCommand(jsonWithDates)
            default:
                jsonToDecode = jsonWithDates
            }
            value = decode(from: jsonToDecode, code)
        }
        return value
    }
    
    // MARK: -
    // MARK: - Read Date
    private func readDate() -> Date? {
        return readValue()
            .flatMap(cast)
            .map { Date(timeIntervalSince1970: $0 / 1000) }
    }

    // MARK: -
    // MARK: - Read Point
    private func readPoint() -> BLPoint? {
        guard let wkt = readValue() as? String else { return nil }
        if let point = try? BLPoint.fromWkt(wkt) {
            return point
        } else {
            return nil
        }
    }

    // MARK: -
    // MARK: - Read LineString
    private func readLineString() -> BLLineString? {
        guard let wkt = readValue() as? String else { return nil }
        if let lineString = try? BLLineString.fromWkt(wkt) {
            return lineString
        } else {
            return nil
        }
    }

    // MARK: -
    // MARK: - Read Polygon
    private func readPolygon() -> BLPolygon? {
        guard let wkt = readValue() as? String else { return nil }
        if let polygon = try? BLPolygon.fromWkt(wkt) {
            return polygon
        } else {
            return nil
        }
    }
    
    // MARK: -
    // MARK: - Prepare Json To Parse
    private func mapDateValues(_ json: [String: Any]) -> [String: Any] {
        var result = json
        
        json.forEach {
            if let date = $0.value as? Date {
                result[$0.key] = date.timeIntervalSince1970
            }
        }
        
        return result
    }
    
    // MARK: -
    // MARK: - Map User
    private func mapUser(_ json: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        var properties: [String: Any] = [:]
        let userFields = ["email", "name", "objectId", "userToken", "password"]
        
        json.forEach { (key, value) in
            if userFields.contains(key) {
                result[key] = value
                if key == "objectId" {
                    properties[key] = value
                }
            } else {
                properties[key] = value
            }
        }
        
        properties["blUserLocale"] = Locale.current.languageCode
        result["properties"] = properties
        
        return result
    }
    
    // MARK: -
    // MARK: - Map Message Status
    private func mapMessageStatus(_ json: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        
        let statuses = ["failed", "published", "scheduled", "cancelled", "unknown"]
        
        json.forEach { (key, value) in
            let newValue: Any
            if key == "status" {
                guard let index = value as? Int else { return }
                newValue = statuses[index]
            } else {
                newValue = value
            }
            result[key] = newValue
        }
        
        return result
    }
    
    // MARK: -
    // MARK: - Map Command
    private func mapCommand(_ json: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        
        json.forEach { (key, value) in
            if key == "userInfo" {
                guard let userInfo = value as? [String: Any] else { return }
                userInfo.forEach { (k, v) in result[k] = v }
            } else {
                result[key] = value
            }
        }
        
        return result
    }
    
    // MARK: -
    // MARK: - Decode
    private func decode(from json: [String: Any], _ code: FlutterTypeCode) -> Any? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else { return nil }

        switch code {
            case .dateTime:
                return nil
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
            case .messageStatus:
                return try? JSONDecoder().decode(MessageStatus.self, from: jsonData)
            case .deviceRegistration:
                return try? JSONDecoder().decode(DeviceRegistration.self, from: jsonData)
            case .message:
                return nil
            case .publishOptions:
                return try? JSONDecoder().decode(PublishOptions.self, from: jsonData)
            case .deliveryOptions:
                return try? JSONDecoder().decode(DeliveryOptions.self, from: jsonData)
            case .publishMessageInfo:
                return try? JSONDecoder().decode(PublishMessageInfo.self, from: jsonData)
            case .deviceRegistrationResult:
                return try? JSONDecoder().decode(DeviceRegistrationResult.self, from: jsonData)
            case .command:
                return CommandObject.decodeFromJson(json)
            case .userInfo:
                return try? JSONDecoder().decode(UserInfo.self, from: jsonData)
            case .userStatusResponse:
                return userStatus(fromJson: json)
            case .reconnectAttempt:
                return try? JSONDecoder().decode(ReconnectAttemptObject.self, from: jsonData)
            case .backendlessUser:
                return try? JSONDecoder().decode(BackendlessUser.self, from: jsonData)
            case .userProperty:
                return try? JSONDecoder().decode(UserProperty.self, from: jsonData)
            case .bulkEvent:
                return try? JSONDecoder().decode(BulkEvent.self, from: jsonData)
            case .emailEnvelope:
                return try? JSONDecoder().decode(EmailEnvelope.self, from: jsonData)
            case .point:
                return nil
            case .lineString:
                return nil
            case .polygon:
                return nil
            default:
                return nil
        }
    }
    
    private func userStatus(fromJson json: [String: Any]) -> UserStatus {
        let userStatusResult = UserStatus()
        
        if let index: Int = json["status"].flatMap(cast) {
            let status = UserStatusEnum(index: index)
            userStatusResult.status = status.rawValue
        }
        
        if let data: [[String: Any]] = json["data"].flatMap(cast) {
            userStatusResult.data = data
        }
        
        return userStatusResult
    }
}
