#import "PayuFlutterPlugin.h"
#if __has_include(<payu_payment/payu_payment-Swift.h>)
#import <payu_payment/payu_payment-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "payu_payment-Swift.h"
#endif

@implementation PayuFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPayuFlutterPlugin registerWithRegistrar:registrar];
}
@end
