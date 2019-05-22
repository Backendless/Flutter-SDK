

// MARK: -
// MARK: - FlutterCallHandlerProtocol
protocol FlutterCallHandlerProtocol: AnyObject {
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}
