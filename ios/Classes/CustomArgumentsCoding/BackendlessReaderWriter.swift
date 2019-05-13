
// MARK: -
// MARK: - FlutterTypeCode
enum FlutterTypeCode: UInt8 {
    case dateTime = 128
    case geoPoint
    case dataQueryBuilder
    case loadRelationsQueryBuilder
    case objectProperty
    case googlePlaySubscriptionStatus
    case googlePlayPurchaseStatus
    case fileInfo
    case geoCategory
    case geoQuery
    case geoCluster
    case searchMathesResult
    case messageStatus
    case deviceRegistration
    case message
    case publishOptions
    case deliveryOptions
    case publishMessageInfo
    case deviceRegistrationResult
    case command
    case userInfo
    case userStatusResponse
    case reconnectAttempt
    case backendlessUser
    case userProperty
    case bulkEvent
}

// MARK: -
// MARK: - BackendlessReaderWriter
class BackendlessReaderWriter: FlutterStandardReaderWriter {
    override func writer(with data: NSMutableData) -> FlutterStandardWriter {
        return BackendlessWtiter(data: data)
    }
    
    override func reader(with data: Data) -> FlutterStandardReader {
        return BackendlessReader(data: data)
    }
}
