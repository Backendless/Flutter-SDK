
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
        // No realization of module in iOS SDK
    }
    
    // MARK: -
    // MARK: - Write GooglePlayPurchaseStatus
    private func writeGooglePlayPurchaseStatus(_ value: Any) {
        // No realization of module in iOS SDK
    }
    
    
}
