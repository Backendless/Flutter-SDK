import Flutter
import UIKit

public class SwiftBackendlessSdkPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
    static public let shared = SwiftBackendlessSdkPlugin()
    static private var channelBackendlessNativeApi: FlutterMethodChannel?
    
    private override init() {}
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftBackendlessSdkPlugin()
        let messenger = registrar.messenger()
        channelBackendlessNativeApi = FlutterMethodChannel(name: "backendless/native_api", binaryMessenger: messenger)
        
        registrar.addMethodCallDelegate(instance, channel: channelBackendlessNativeApi!)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "registerForRemoteNotifications":
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    if let error = error {
                        print(":red_circle: APNS error: \(error.localizedDescription)")
                        result(false)
                    }
                    else {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        result(true)
                    }
                }
            }
        default:
            print("Not implemented SWIFT NATIVE METHOD")
            result(FlutterMethodNotImplemented)
        }
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        SwiftBackendlessSdkPlugin.channelBackendlessNativeApi?.invokeMethod("setDeviceToken", arguments: token)
        
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
            SwiftBackendlessSdkPlugin.channelBackendlessNativeApi?.invokeMethod("onTapPushAction", arguments: nil)
        }
        
        completionHandler(.newData)
        return true;
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter called");
        
        let strPayload = notification.request.content.userInfo["payload"] as? String
        
        
        if let map = strPayload?.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: map, options: .mutableContainers) as? [String:Any]

                if let flutterId = json?["flutter_notification_identifier"] as? String,
                flutterId == "identity" {
                    completionHandler([.alert, .badge, .sound])
                }
            } catch {
                print("payload wrong")
            }
        }
        else {
            SwiftBackendlessSdkPlugin.channelBackendlessNativeApi?.invokeMethod("showNotificationWithTemplate", arguments: notification.request.content.userInfo)
            completionHandler([]);
        }
    }
}
