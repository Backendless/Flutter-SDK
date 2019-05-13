
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
        
        //        objectProperty.setType(DateTypeEnum.values()[(int) readValue(buffer)]);
        
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
        fileInfo.createdOn.map { [weak self] in self?.writeValue($0) }
        fileInfo.url.map { [weak self] in self?.writeValue($0) }
        writeValue(fileInfo.size)
    }
    
    // MARK: -
    // MARK: - Write GeoCategory
    private func writeGeoCategory(_ geoCategory: GeoCategory) {
        writeValue(FlutterTypeCode.geoCategory.rawValue)
        
        geoCategory.objectId.map { [weak self] in self?.writeValue($0) }
        geoCategory.name.map { [weak self] in self?.writeValue($0) }
        geoCategory.size.map { [weak self] in self?.writeValue($0) }
    }
    
    // MARK: -
    // MARK: - Write GeoQuery
    private func writeGeoQuery(_ geoQuery: BackendlessGeoQuery) {
        writeValue(FlutterTypeCode.geoQuery.rawValue)
        
        geoQuery.geoPoint.map { [weak self] in self?.writeValue($0.latitude) }
        geoQuery.geoPoint.map { [weak self] in self?.writeValue($0.longitude) }
        geoQuery.radius.map { [weak self] in self?.writeValue($0) }
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
    // MARK: -
    private func writeMessageStatus(_ messageStatus: MessageStatus) {
        
    }
    
    
}
