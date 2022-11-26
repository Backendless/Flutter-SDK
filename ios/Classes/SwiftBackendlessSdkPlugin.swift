import Flutter
import UIKit

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin {
    static public let shared = SwiftBackendlessSdkPlugin()
    static private var channelBackendless: FlutterMethodChannel?
    static private var handler: FlutterCallHandlerProtocol?
    
    private override init() {}
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        channelBackendless = FlutterMethodChannel(name: "backendless", binaryMessenger: messenger)
        handler = BackendlessCallHandler()
        channelBackendless?.setMethodCallHandler(handler?.routeFlutterCall)
        
        registrar.addMethodCallDelegate(self.shared, channel: channelBackendless!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "getDeviceToken":
            print("1232314")
            result(BackendlessCallHandler.deviceToken);
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        BackendlessCallHandler.deviceToken = token;
        
        print(token)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool  {
        print("Received push notification:")
        
        for (key, value) in userInfo {
            print("* \(key): \(value)")
        }
        
        let state = UIApplication.shared.applicationState
        
        if state == .active
        {
            print("___ACTIVE")
        }
        else if state == .inactive {
            print("INACTIVE")
            SwiftBackendlessSdkPlugin.channelBackendless?.invokeMethod("onTapPushAction", arguments: nil)
        }
        
        completionHandler(.newData)
        return true;
    }
}
