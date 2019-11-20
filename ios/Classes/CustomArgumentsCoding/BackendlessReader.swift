
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
        case .geoQuery:
            value = readGeoQuery()
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
    // MARK: - Read Geo Query
    private func readGeoQuery() -> BackendlessGeoQuery? {
        guard let json: [String: Any] = readValue().flatMap(cast) else { return nil }
        let jsonToDecode = prepareGeoQueryJson(from: json)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonToDecode, options: []) else { return nil }
        
        return try? JSONDecoder().decode(BackendlessGeoQuery.self, from: jsonData)
    }
    
    private func prepareGeoQueryJson(from json: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        var geoPoint: [String: Any] = [:]
        var rectangleSource: [Double] = []
        
        let geopointKeys = ["latitude", "longitude"]
        
        json.forEach {
            if geopointKeys.contains($0.key) {
                geoPoint[$0.key] = $0.value
            } else if $0.key == "searchRectangle" {
                if let data = ($0.value as? FlutterStandardTypedData)?.data {
                    rectangleSource = data.withUnsafeBytes { (pointer: UnsafePointer<Double>) -> [Double] in
                        let buffer = UnsafeBufferPointer(start: pointer,
                                                         count: data.count / 8)
                        return Array<Double>(buffer)
                    }
                }
            } else if $0.key == "categories" {
                guard
                    let categories = $0.value as? [String],
                    !categories.isEmpty
                    else {
                        return
                }
                result[$0.key] = $0.value
            } else {
                result[$0.key] = $0.value
            }
        }
        
        result["geoPoint"] = geoPoint
        
        if !rectangleSource.isEmpty {
            var rectJson: [String: Any] = [:]
            let northWest = ["latitude": rectangleSource[0], "longitude": rectangleSource[1]]
            let southEast = ["latitude": rectangleSource[2], "longitude": rectangleSource[3]]
            rectJson = ["nordWestPoint": northWest, "southEastPoint": southEast]
            result["rectangle"] = rectJson
        }
        
        return result
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
        guard let jsonFromProperties = json["properties"] as? [String: Any] else {
            return [:]
        }
        
        var result: [String: Any] = [:]
        var properties: [String: Any] = [:]
        let userFields = ["email", "name", "objectId", "userToken", "password"]
        
        jsonFromProperties.forEach { (key, value) in
            if userFields.contains(key) {
                result[key] = value
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
        case .searchMatchesResult:
            return try? JSONDecoder().decode(SearchMatchesResult.self, from: jsonData)
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
