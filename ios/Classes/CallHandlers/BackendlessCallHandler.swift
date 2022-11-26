class BackendlessCallHandler : FlutterCallHandlerProtocol {
   static public var deviceToken: String?

       func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
           switch(call.method) {
                case "getDeviceToken":
                    print("GET DEVICE TOKEN SWIFT")
                    result(deviceToken)
                    break;
                default:
                    print("Not implemeted SWIFT NATIVE METHOD")
                    result(FlutterMethodNotImplemented)
                }
        }
}
