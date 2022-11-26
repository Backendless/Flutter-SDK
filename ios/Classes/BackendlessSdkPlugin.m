#import "BackendlessSdkPlugin.h"
#if __has_include(<backendless_sdk/backendless_sdk-Swift.h>)
#import <backendless_sdk/backendless_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "backendless_sdk-Swift.h"
#endif

@implementation BackendlessSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBackendlessSdkPlugin registerWithRegistrar:registrar];
}
@end
