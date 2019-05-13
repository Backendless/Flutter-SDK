
import Flutter
import Backendless

// MARK: -
// MARK: - BackendlessReader
class BackendlessReader: FlutterStandardReader {
    
    override func readValue(ofType type: UInt8) -> Any? {
        print("~~~> type: \(type) <~~~")
        let code = FlutterTypeCode(rawValue: type)
        
        return code != nil ? readCustomValue(byCode: code!) : readValue(ofType: type)
    }
    
    private func readCustomValue(byCode code: FlutterTypeCode) -> Any? {
        let value: Any?
        
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
        default:
            value = nil
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
    
    
    
    
    
    
    
}
