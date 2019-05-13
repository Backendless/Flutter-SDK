
import Flutter
import Backendless

// MARK: -
// MARK: - BackendlessReader
class BackendlessReader: FlutterStandardReader {
    
    // MARK: -
    // MARK: - Read Value
    override func readValue(ofType type: UInt8) -> Any? {
        print("~~~> type: \(type) <~~~")
        let code = FlutterTypeCode(rawValue: type)
        
        return code != nil ? readCustomValue(byCode: code!) : readValue(ofType: type)
    }
    
    // MARK: -
    // MARK: - Read Custom Value
    private func readCustomValue(byCode code: FlutterTypeCode) -> Any? {
        var value: Any?
        
        switch code {
        case .dateTime:
            value = readDate()
        case .geoPoint:
            value = readGeoPoint()
        case .dataQueryBuilder:
            value = readDataQueryBuilder()
        case .loadRelationsQueryBuilder:
            value = readLoadRelationsQueryBuilder()
        case .objectProperty:
            value = readObjectProperty()
        case .googlePlaySubscriptionStatus:
            value = readGooglePlaySubscriptionStatus()
        case .googlePlayPurchaseStatus:
            value = readGooglePlayPurchaseStatus()
        case .fileInfo:
            value = readFileInfo()
        case .geoCategory:
            value = readGeoCategory()
        case .geoQuery:
            value = readGeoQuery()
        case .geoCluster:
            value = readGeoCluster()
        case .searchMathesResult:
            value = readSearchMathesResult()
        case .messageStatus:
            value = readMessageStatus()
        case .deviceRegistration:
            value = readDeviceRegistration()
        case .message:
            value = readMesage()
        case .publishOptions:
            value = readPublishOptions()
        case .deliveryOptions:
            value = readDeliveryOptions()
        case .publishMessageInfo:
            value = readPublishMessageInfo()
        case .deviceRegistrationResult:
            value = readDeviceRegistrationResult()
        case .command:
            value = readCommand()
        case .userInfo:
            value = readUserInfo()
        case .userStatusResponse:
            value = readUserStatusResponse()
        case .reconnectAttempt:
            value = readReconnectAttempt()
        case .backendlessUser:
            value = readBackendlessUser()
        case .userProperty:
            value = readUserProperty()
        case .bulkEvent:
            value = readBulkEvent()
        }
        
        return value
    }
    
    // MARK: -
    // MARK: - Read Date
    private func readDate() -> Date? {
        // TODO: - Choose type
        
        // TODO: -
        // TODO: - Init object with properties
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read GeoPoint
    private func readGeoPoint() -> GeoPoint {
        let objectId: String = readValue().flatMap(cast) ?? ""
        let latitude: Double = readValue().flatMap(cast) ?? 0.0
        let longitude: Double = readValue().flatMap(cast) ?? 0.0
        let categories: [String] = readValue().flatMap(cast) ?? []
        let metadata: [String: Any] = readValue().flatMap(cast) ?? [:]
        let distance: Double = readValue().flatMap(cast) ?? 0.0
        
        return GeoPoint(latitude: latitude, longitude: longitude, categories: categories, metadata: metadata)
    }
    
    // MARK: -
    // MARK: - Read DataQueryBuilder
    private func readDataQueryBuilder() -> DataQueryBuilder {
        let builder = DataQueryBuilder()
        
        readValue().flatMap(cast).map { builder.setProperties(properties: $0) }
        readValue().flatMap(cast).map { builder.setWhereClause(whereClause: $0) }
        readValue().flatMap(cast).map { builder.setGroupBy(groupBy: $0) }
        readValue().flatMap(cast).map { builder.setHavingClause(havingClause: $0) }
        readValue().flatMap(cast).map { builder.setPageSize(pageSize: $0) }
        readValue().flatMap(cast).map { builder.setOffset(offset: $0) }
        readValue().flatMap(cast).map { builder.setSortBy(sortBy: $0) }
        readValue().flatMap(cast).map { builder.setRelated(related: $0) }
        readValue().flatMap(cast).map { builder.setRelationsDepth(relationsDepth: $0) }
        
        return builder
    }
    
    // MARK: -
    // MARK: - Read LoadRelationsQueryBuilder
    private func readLoadRelationsQueryBuilder() -> LoadRelationsQueryBuilder {
        let builder = LoadRelationsQueryBuilder(tableName: "")
        
        // TODO: -
        // TODO: - Init object with properties
        
        return builder
    }
    
    // MARK: -
    // MARK: - Read ObjectProperty
    private func readObjectProperty() -> ObjectProperty? {
        
        // TODO: -
        // TODO: - Init object with properties
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read GooglePlaySubscriptionStatus
    private func readGooglePlaySubscriptionStatus() -> Any? {
        // No realization of module in iOS SDK
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read GooglePlayPurchaseStatus
    private func readGooglePlayPurchaseStatus() -> Any? {
        // No realization of module in iOS SDK
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read FileInfo
    private func readFileInfo() -> BackendlessFileInfo {
        let fileInfo = BackendlessFileInfo()
        
        readValue().flatMap(cast).map { fileInfo.name = $0 }
        readValue().flatMap(cast).map { fileInfo.createdOn = $0 }
        readValue().flatMap(cast).map { fileInfo.publicUrl = $0 }
        readValue().flatMap(cast).map { fileInfo.url = $0 }
        readValue().flatMap(cast).map { fileInfo.size = $0 }
        
        return fileInfo
    }
    
    // MARK: -
    // MARK: - Read GeoCategory
    private func readGeoCategory() -> GeoCategory? {
        
        guard
            let objectId: String? = readValue().flatMap(cast),
            let name: String? = readValue().flatMap(cast),
            let size: NSNumber = readValue().flatMap(cast)
            else {
                return nil
        }
        
        // No open init for GeoCategory, just from a NSCoder
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read GeoQuery
    private func readGeoQuery() -> BackendlessGeoQuery? {
        
        // TODO: -
        // TODO: - Init object with properties
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read GeoCluster
    private func readGeoCluster() -> GeoCluster? {
        let geoCluster = GeoCluster()
        
        // TODO: -
        // TODO: - Set all proreties
        
        return geoCluster
    }
    
    // MARK: -
    // MARK: - Read SearchMathesResult
    private func readSearchMathesResult() -> Any? {
        
        // TODO: -
        // TODO: - Return [GeoPoint] ? or some other Object?
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read MessageStatus
    private func readMessageStatus() -> MessageStatus? {
        guard
            let messageId: String? = readValue().flatMap(cast),
            let status: String? = readValue().flatMap(cast),
            let errorMesage: String? = readValue().flatMap(cast)
        else {
            return nil
        }
        
        // TODO: -
        // TODO: - Return Message Status
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read DeviceRegistration
    private func readDeviceRegistration() -> DeviceRegistration? {
        guard
            let id: String? = readValue().flatMap(cast),
            let diviceToken: String? = readValue().flatMap(cast),
            let deviceId: String? = readValue().flatMap(cast),
            let os: String? = readValue().flatMap(cast),
            let osVersion: String? = readValue().flatMap(cast),
            let expiration = readDate(),
            let channels: [String]? = readValue().flatMap(cast)
        else {
            return nil
        }
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read Message
    private func readMesage() -> Any? {
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read PublishOptions
    private func readPublishOptions() -> PublishOptions {
        let publishOptions = PublishOptions()
        
        readValue().flatMap(cast).map { publishOptions.publisherId = $0 }
        readValue().flatMap(cast).map { (headers: [String: Any]) in
            headers.forEach {
                publishOptions.addHeader(name: $0.key, value: $0.value)
            }
        }
        
        return publishOptions
    }
    
    // MARK: -
    // MARK: - Read DeliveryOptions
    private func readDeliveryOptions() -> DeliveryOptions {
        let deliveryOptions = DeliveryOptions()
        
        readValue().flatMap(cast).map { deliveryOptions.setPushBroadcast(pushBroadcast: $0) }
        readValue().flatMap(cast).map { deliveryOptions.setPushSinglecast(singlecast: $0) }
        _ = readValue() // segmentQuery
        readValue().flatMap(cast).map { deliveryOptions.setPublishPolicy(publishPolicy: $0) }
        readDate().map { deliveryOptions.publishAt = $0 }
        readValue().flatMap(cast).map { deliveryOptions.repeatEvery = $0 }
        readValue().flatMap(cast).map { deliveryOptions.repeatExpiresAt = $0 }
        
        return deliveryOptions
    }
    
    // MARK: -
    // MARK: - Read PublishMessageInfo
    private func readPublishMessageInfo() -> PublishMessageInfo {
        let publishMessageInfo = PublishMessageInfo()
        
        readValue().flatMap(cast).map { publishMessageInfo.messageId = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.timestamp = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.message = $0 } // Need to check
        readValue().flatMap(cast).map { publishMessageInfo.publisherId = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.subtopic = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.pushSinglecast = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.pushBroadcast = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.publishPolicy = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.query = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.publishAt = $0 }
        readValue().flatMap(cast).map { publishMessageInfo.repeatEvery = $0 }
        _ = readValue() // repeatExpiresAt
        readValue().flatMap(cast).map { publishMessageInfo.headers = $0 }
        
        return publishMessageInfo
    }
    
    // MARK: -
    // MARK: - Read DeviceRegistrationResult
    private func readDeviceRegistrationResult() -> Any? {
        
        // TODO: -
        // TODO: - DeviceRegistrationResult
        // TODO: - Just a String in iOS method responseHandler
        
        return nil
    }
    
    private func readCommand() -> Any? {
        
        // TODO: -
        // TODO: - What is Command Object?
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read UserInfo
    private func readUserInfo() -> UserInfo {
        let userInfo = UserInfo()
        
        readValue().flatMap(cast).map { userInfo.connectionId = $0 }
        readValue().flatMap(cast).map { userInfo.userId = $0 }
        
        return userInfo
    }
    
    // MARK: -
    // MARK: - Read UserStatusResponse
    private func readUserStatusResponse() -> Any? {
        
        // TODO: -
        // TODO: - UserStatusResponse
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read ReconnectAttempt
    private func readReconnectAttempt() -> ReconnectAttemptObject {
        let reconnectAttempt = ReconnectAttemptObject()
        
        readValue().flatMap(cast).map { reconnectAttempt.timeout = $0 }
        readValue().flatMap(cast).map { reconnectAttempt.attempt = $0 }
        
        return reconnectAttempt
    }
    
    // MARK: -
    // MARK: - Read BackendlessUser
    private func readBackendlessUser() -> BackendlessUser? {
        let backendlessUser = BackendlessUser()
        
        readValue().flatMap(cast).map { backendlessUser.setProperties(properties: $0) }
        
        return backendlessUser
    }
    
    // MARK: -
    // MARK: - Read UserProperty
    private func readUserProperty() -> Any? {
        guard
            let name: String = readValue().flatMap(cast),
            let isRequired: Bool = readValue().flatMap(cast),
            let type: Int = readValue().flatMap(cast)
            // TODO: -
            // TODO: - Can't convert type: Int to DataTypeEnum with String rawValue
        else {
            return nil
        }
        
        // TODO: -
        // TODO: - Return UserProperty
        
        return nil
    }
    
    // MARK: -
    // MARK: - Read BulkEvent
    private func readBulkEvent() -> BulkEvent {
        let bulkEvent = BulkEvent()
        
        readValue().flatMap(cast).map { bulkEvent.whereClause = $0 }
        readValue().flatMap(cast).map { bulkEvent.count = $0 }
        
        return bulkEvent
    }
}

enum NewEnum {
    
    func newMethod() {
        
    }
}
