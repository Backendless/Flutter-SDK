
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
        case is GeoPoint:
            writeGeoPoint(value as! GeoPoint)
        case is DataQueryBuilder:
            writeDataQueryBuilder(value as! DataQueryBuilder)
        case is LoadRelationsQueryBuilder:
            writeLoadRelationsQueryBuilder(value as! LoadRelationsQueryBuilder)
        case is ObjectProperty:
            writeObjectProperty(value as! ObjectProperty)
//        case is GooglePlaySubscriptionStatus:
//            writeGooglePlaySubscriptionStatus(value as! GooglePlaySubscriptionStatus)
//        case is GooglePlayPurchaseStatus:
//            writeGooglePlayPurchaseStatus(value as! GooglePlayPurchaseStatus)
        case is BackendlessFileInfo:
            writeFileInfo(value as! BackendlessFileInfo)
        case is GeoCategory:
            writeGeoCategory(value as! GeoCategory)
        case is BackendlessGeoQuery:
            writeGeoQuery(value as! BackendlessGeoQuery)
        case is GeoCluster:
            writeGeoCluster(value as! GeoCluster)
//        case is MatchesResult:
//            writeSearchMatchesResult(value as! SearchMatchesResult)
        case is MessageStatus:
            writeMessageStatus(value as! MessageStatus)
        case is DeviceRegistration:
            writeDeviceRegistration(value as! DeviceRegistration)
//        case is Message:
//            writeMessage(value as! Message)
        case is PublishOptions:
            writePublishOptions(value as! PublishOptions)
        case is DeliveryOptions:
            writeDeliveryOptions(value as! DeliveryOptions)
        case is PublishMessageInfo:
            writePublishMessageInfo(value as! PublishMessageInfo)
//        case is DevideRegistrationResult:
//            writeDevideRegistrationResult(value as! DevideRegistrationResult)
//        case is Command:
//            writeCommand(value as! Command)
        case is UserInfo:
            writeUserInfo(value as! UserInfo)
//        case is UserStatusResponse:
//            writeUserStatusResponse(value as! UserStatusResponse)
        case is ReconnectAttemptObject:
            writeReconnectAttempt(value as! ReconnectAttemptObject)
        case is BackendlessUser:
            writeBackendlessUser(value as! BackendlessUser)
        case is UserProperty:
            writeUserProperty(value as! UserProperty)
        case is BulkEvent:
            writeBulkEvent(value as! BulkEvent)
        default:
            break
        }
    }
    
    // MARK: -
    // MARK: - Write Date
    private func writeDate(_ date: Date) {
        writeValue(FlutterTypeCode.dateTime.rawValue)
        writeValue(date.timeIntervalSince1970)
    }
    
    // MARK: -
    // MARK: - Write GeoPoint
    private func writeGeoPoint(_ geoPoint: GeoPoint) {
        writeValue(FlutterTypeCode.geoPoint.rawValue)
        
        geoPoint.objectId.map { [weak self] in self?.writeValue($0) }
        writeValue(geoPoint.latitude)
        writeValue(geoPoint.longitude)
        writeValue(geoPoint.categories)
        geoPoint.metadata.map { [weak self] in self?.writeValue($0) }
        
        // TODO: -
        // TODO: - How to get distance?
        writeValue(Double(0)) // distance
    }
    
    // MARK: -
    // MARK: - Write DataQueryBuilder
    private func writeDataQueryBuilder(_ dataQueryBuilder: DataQueryBuilder) {
        writeValue(FlutterTypeCode.dataQueryBuilder.rawValue)
        
        dataQueryBuilder.getProperties().map { [weak self] in self?.writeValue($0) }
        dataQueryBuilder.getWhereClause().map { [weak self] in self?.writeValue($0) }
        dataQueryBuilder.getGroupBy().map { [weak self] in self?.writeValue($0) }
        dataQueryBuilder.getHavingClause().map { [weak self] in self?.writeValue($0) }
        writeValue(dataQueryBuilder.getPageSize())
        writeValue(dataQueryBuilder.getOffset())
        dataQueryBuilder.getSortBy().map { [weak self] in self?.writeValue($0) }
        dataQueryBuilder.getRelated().map { [weak self] in self?.writeValue($0) }
        writeValue(dataQueryBuilder.getRelationsDepth())
    }
    
    // MARK: -
    // MARK: - Write LoadRelationsQueryBuilder
    private func writeLoadRelationsQueryBuilder(_ loadRelationsQueryBuilder: LoadRelationsQueryBuilder) {
        writeValue(FlutterTypeCode.loadRelationsQueryBuilder.rawValue)
        
        loadRelationsQueryBuilder.getRelationName().map { [weak self] in self?.writeValue($0) }
        writeValue(loadRelationsQueryBuilder.getPageSize())
        writeValue(loadRelationsQueryBuilder.getOffset())
    }
    
    // MARK: -
    // MARK: - Write ObjectProperty
    private func writeObjectProperty(_ objectProperty: ObjectProperty) {
        writeValue(FlutterTypeCode.objectProperty.rawValue)
        
        objectProperty.relatedTable.map { [weak self] in self?.writeValue($0) }
        objectProperty.defaultValue.map { [weak self] in self?.writeValue($0) }
        writeValue(objectProperty.name)
        writeValue(objectProperty.required)
        
        // TODO: -
        // TODO: - How to get Int value of DataTypeEnum?
        
        writeValue(Int(0)) // DateTypeEnum
    }
    
    // MARK: -
    // MARK: - Write GooglePlaySubscriptionStatus
    private func writeGooglePlaySubscriptionStatus(_ value: Any) {
        writeValue(FlutterTypeCode.googlePlaySubscriptionStatus.rawValue)
        
        // No realization of module in iOS SDK
    }
    
    // MARK: -
    // MARK: - Write GooglePlayPurchaseStatus
    private func writeGooglePlayPurchaseStatus(_ value: Any) {
        writeValue(FlutterTypeCode.googlePlayPurchaseStatus.rawValue)
        
        // No realization of module in iOS SDK
    }
    
    // MARK: -
    // MARK: - Write FileInfo
    private func writeFileInfo(_ fileInfo: BackendlessFileInfo) {
        writeValue(FlutterTypeCode.fileInfo.rawValue)
        
        fileInfo.name.map { [weak self] in self?.writeValue($0) }
        fileInfo.createdOn.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        fileInfo.url.map { [weak self] in self?.writeValue($0) }
        writeValue(fileInfo.size)
    }
    
    // MARK: -
    // MARK: - Write GeoCategory
    private func writeGeoCategory(_ geoCategory: GeoCategory) {
        writeValue(FlutterTypeCode.geoCategory.rawValue)
        
        geoCategory.objectId.map { [weak self] in self?.writeValue($0) }
        geoCategory.name.map { [weak self] in self?.writeValue($0) }
        geoCategory.size.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
    }
    
    // MARK: -
    // MARK: - Write GeoQuery
    private func writeGeoQuery(_ geoQuery: BackendlessGeoQuery) {
        writeValue(FlutterTypeCode.geoQuery.rawValue)
        
        geoQuery.geoPoint.map { [weak self] in self?.writeValue($0.latitude) }
        geoQuery.geoPoint.map { [weak self] in self?.writeValue($0.longitude) }
        geoQuery.radius.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        geoQuery.categories.map { [weak self] in self?.writeValue($0) }
        geoQuery.metadata.map { [weak self] in self?.writeValue($0) }
        
        // TODO: -
        // TODO: - How to get RelativeFindMetadata?
        writeValue([String: String]()) // RelativeFindMetadata
        
        // TODO: -
        // TODO: - How to get RelativeFindPercentThreshold?
        writeValue(Double(0)) // RelativeFindPercentThreshold
        
        geoQuery.whereClause.map { [weak self] in self?.writeValue($0) }
        
        // TODO: -
        // TODO: - How to get SortBy?
        // TODO: - How to send data with Collection type in Java?
        writeValue(0) // SortBy
        
        writeValue(geoQuery.degreePerPixel)
        writeValue(geoQuery.clusterGridSize)
        writeValue(geoQuery.pageSize)
        writeValue(geoQuery.offset)
        writeValue(geoQuery.getUnits()) // Need to check if Data Type is correctly readed on Flutter side
        writeValue(geoQuery.includemetadata)
        
        // TODO: -
        // TODO: - How is SearchRectangle described in iOS SDK?
        writeValue([Double(0), Double(0)]) // SearchRectangle
    }
    
    // MARK: -
    // MARK: - Write GeoCluster
    private func writeGeoCluster(_ geoCluster: GeoCluster) {
        writeValue(FlutterTypeCode.geoCluster.rawValue)
        
        geoCluster.objectId.map { [weak self] in self?.writeValue($0) }
        writeValue(geoCluster.latitude)
        writeValue(geoCluster.longitude)
        
        // TODO: -
        // TODO: - How to send data with Collection type in Java?
        writeValue(geoCluster.categories)
        geoCluster.metadata.map { [weak self] in self?.writeValue($0) }
        
        // TODO: -
        // TODO: - How to get distance?
        writeValue(Double(0)) // distance
        writeValue(geoCluster.totalPoints)
        geoCluster.geoQuery.map { [weak self] in self?.writeGeoQuery($0) }
    }
    
    // MARK: -
    // MARK: - Write SearchMathesResult
//    private func writeSearchMathesResult(_ searchMathesResult: SearchMathesResult) {
//        writeValue(FlutterTypeCode.searchMathesResult.rawValue)
//    }
    
    // MARK: -
    // MARK: - Write MessageStatus
    private func writeMessageStatus(_ messageStatus: MessageStatus) {
        writeValue(FlutterTypeCode.messageStatus.rawValue)
        
        messageStatus.messageId.map { [weak self] in self?.writeValue($0) }
        messageStatus.errorMessage.map { [weak self] in self?.writeValue($0) }
        
        // TODO: -
        // TODO: - Convert String to PublishStatusEnum Int value
        writeValue(0) // PublishStatusEnum
    }
    
    // MARK: -
    // MARK: - Write DeviceRegistration
    private func writeDeviceRegistration(_ deviceRegistration: DeviceRegistration) {
        writeValue(FlutterTypeCode.deviceRegistration.rawValue)
        
        deviceRegistration.id.map { [weak self] in self?.writeValue($0) }
        deviceRegistration.deviceToken.map { [weak self] in self?.writeValue($0) }
        deviceRegistration.deviceId.map { [weak self] in self?.writeValue($0) }
        deviceRegistration.os.map { [weak self] in self?.writeValue($0) }
        deviceRegistration.osVersion.map { [weak self] in self?.writeValue($0) }
        deviceRegistration.expiration.map { [weak self] in self?.writeDate($0) }
        deviceRegistration.channels.map { [weak self] in self?.writeValue($0) }
    }
    
    // MARK:
    // MARK: - Write Message
//    private func writeMessage(_ deviceRegistration: Message) {
//        writeValue(FlutterTypeCode.message.rawValue)
//
//    }
    
    
    // MARK: -
    // MARK: - Write PublishOptions
    private func writePublishOptions(_ publishOptions: PublishOptions) {
        writeValue(FlutterTypeCode.publishOptions.rawValue)
        
        publishOptions.publisherId.map { [weak self] in self?.writeValue($0) }
        writeValue(publishOptions.headers)
        
        // TODO: -
        // TODO: - No subtopic in PublishOptions Swift Class
        
        writeValue("") // subtopic
    }
    
    // MARK: -
    // MARK: - Write DeliveryOptions
    private func writeDeliveryOptions(_ deliveryOptions: DeliveryOptions) {
        writeValue(FlutterTypeCode.deliveryOptions.rawValue)
        
        writeValue(deliveryOptions.getPushBroadcast())
        writeValue(deliveryOptions.getPushSinglecast())
        
        // TODO: -
        // TODO: - No segmentQuery in Swift DeliveryOptions
        writeValue("") // segmentQuery
        
        let publishPolicy = deliveryOptions.getPublishPolicy()
        switch publishPolicy {
        case "PUSH":
            writeValue(0)
        case "PUBSUB":
            writeValue(1)
        default:
            writeValue(2)
        }
        
        deliveryOptions.publishAt.map { [weak self] in self?.writeDate($0) }
        deliveryOptions.repeatEvery.map { [weak self] in self?.writeValue($0) }
        deliveryOptions.repeatExpiresAt.map { [weak self] in self?.writeDate($0) }
    }
    
    // MARK: -
    // MARK: - Write PublishMessageInfo
    private func writePublishMessageInfo(_ publishMessageInfo: PublishMessageInfo) {
        writeValue(FlutterTypeCode.publishMessageInfo.rawValue)
        
        publishMessageInfo.messageId.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.timestamp.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        publishMessageInfo.message.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.publisherId.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.subtopic.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.pushSinglecast.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.pushBroadcast.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        publishMessageInfo.publishPolicy.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.query.map { [weak self] in self?.writeValue($0) }
        publishMessageInfo.publishAt.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        publishMessageInfo.repeatEvery.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        
        // TODO: -
        // TODO: - No repeatExpiresAt: Date property in PublishMessageInfo Class
        writeDate(Date()) // Need to fix with correct Date
        
        publishMessageInfo.headers.map { [weak self] in self?.writeValue($0) }
    }
    
    // MARK: -
    // MARK: - Write DevideRegistrationResult
//    private func writeDevideRegistrationResult(_ deviceRegistationResult: DevideRegistrationResult) {
//        writeValue(FlutterTypeCode.deviceRegistrationResult.rawValue)
//
//    }
    
    // MARK: -
    // MARK: - Write Command
//    private func writeCommand(_ command: Command) {
//        writeValue(FlutterTypeCode.command.rawValue)
//
//    }
    
    // MARK: -
    // MARK: - Write UserInfo
    private func writeUserInfo(_ userInfo: UserInfo) {
        writeValue(FlutterTypeCode.userInfo.rawValue)
        
        userInfo.connectionId.map { [weak self] in self?.writeValue($0) }
        userInfo.userId.map { [weak self] in self?.writeValue($0) }
    }
    
    // MARK: -
    // MARK: - Write UserStatusResponse
//    private func writeUserStatusResponse(_ userStatusResponse: UserStatusResponse) {
//        writeValue(FlutterTypeCode.userStatusResponse.rawValue)
//
//    }
    
    // MARK: -
    // MARK: - Write ReconnectAttempt
    private func writeReconnectAttempt(_ reconnectAttempt: ReconnectAttemptObject) {
        writeValue(FlutterTypeCode.reconnectAttempt.rawValue)
        
        reconnectAttempt.timeout.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
        reconnectAttempt.attempt.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
    }
    
    // MARK: -
    // MARK: - Write BackendlessUser
    private func writeBackendlessUser(_ user: BackendlessUser) {
        writeValue(FlutterTypeCode.backendlessUser.rawValue)
        
        writeValue(user.getProperties())
    }
    
    // MARK: -
    // MARK: - WriteUserProperty
    private func writeUserProperty(_ userProperty: UserProperty) {
        writeValue(FlutterTypeCode.userProperty.rawValue)
        
        writeValue(userProperty.name)
        writeValue(userProperty.required)
        
        switch userProperty.type {
        case .UNKNOWN:
            writeValue(0)
        case .INT:
            writeValue(1)
        case .STRING:
            writeValue(2)
        case .BOOLEAN:
            writeValue(3)
        case .DATETIME:
            writeValue(4)
        case .DOUBLE:
            writeValue(5)
        case .RELATION:
            writeValue(6)
        case .COLLECTION:
            writeValue(7)
        case .RELATION_LIST:
            writeValue(8)
        case .STRING_ID:
            writeValue(9)
        case .TEXT:
            writeValue(10)
        }
        
        writeValue(userProperty.identity)
    }
    
    // MARK: -
    // MARK: - Write BulkEvent
    private func writeBulkEvent(_ bulkEvent: BulkEvent) {
        writeValue(FlutterTypeCode.bulkEvent.rawValue)
        
        bulkEvent.whereClause.map { [weak self] in self?.writeValue($0) }
        bulkEvent.count.map { [weak self] in self?.writeValue(Int(truncating: $0)) }
    }
    
}
