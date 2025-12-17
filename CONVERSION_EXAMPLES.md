# Side-by-Side Conversion Examples

This document shows actual Swift-to-Objective-C conversions from the Stats project.

## Example 1: LaunchAtLogin Helper (main.m)

### Original Swift (main.swift)
```swift
import Cocoa

func main() {
    let mainBundleId = Bundle.main.bundleIdentifier!.replacingOccurrences(of: ".LaunchAtLogin", with: "")
    
    if !NSRunningApplication.runningApplications(withBundleIdentifier: mainBundleId).isEmpty {
        exit(0)
    }
    
    let pathComponents = (Bundle.main.bundlePath as NSString).pathComponents
    let mainPath = NSString.path(withComponents: Array(pathComponents[0...(pathComponents.count - 5)]))
    NSWorkspace.shared.launchApplication(mainPath)
    
    exit(0)
}

main()
```

### Converted Objective-C (main.m)
```objc
#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Get the main bundle identifier by removing ".LaunchAtLogin" suffix
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *mainBundleId = [bundleId stringByReplacingOccurrencesOfString:@".LaunchAtLogin" 
                                                                      withString:@""];
        
        // Check if the main application is already running
        NSArray *runningApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:mainBundleId];
        if ([runningApps count] > 0) {
            return 0;
        }
        
        // Get the path to the main application
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSArray *pathComponents = [bundlePath pathComponents];
        
        // Go up 5 levels from the LaunchAtLogin bundle to get the main app path
        NSUInteger count = [pathComponents count];
        NSArray *mainPathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, count - 4)];
        NSString *mainPath = [NSString pathWithComponents:mainPathComponents];
        
        // Launch the main application
        [[NSWorkspace sharedWorkspace] launchApplication:mainPath];
        
        return 0;
    }
}
```

**Key Changes:**
- Function-based → C main() with @autoreleasepool
- Force unwrap `!` → No nil-checking needed (would crash anyway)
- Swift `.isEmpty` → Objective-C `[array count] > 0`
- Range syntax `[0...(count-5)]` → `NSMakeRange(0, count-4)`
- Dot syntax `.shared` → Message syntax `[NSWorkspace sharedWorkspace]`

---

## Example 2: Protocol with Closures

### Original Swift (protocol.swift)
```swift
import Foundation

@objc public protocol HelperProtocol {
    func version(completion: @escaping (String) -> Void)
    func setSMCPath(_ path: String)
    
    func setFanMode(id: Int, mode: Int, completion: @escaping (String?) -> Void)
    func setFanSpeed(id: Int, value: Int, completion: @escaping (String?) -> Void)
    func powermetrics(_ samplers: [String], completion: @escaping (String?) -> Void)
    
    func uninstall()
}
```

### Converted Objective-C (HelperProtocol.h)
```objc
#import <Foundation/Foundation.h>

@protocol HelperProtocol <NSObject>

@required

/**
 * Returns the version of the helper
 * @param completion Completion handler that receives the version string
 */
- (void)versionWithCompletion:(void (^)(NSString *version))completion;

/**
 * Sets the path to the SMC binary
 * @param path The file path to the SMC binary
 */
- (void)setSMCPath:(NSString *)path;

/**
 * Sets the fan mode
 * @param fanId The ID of the fan to control
 * @param mode The mode to set the fan to
 * @param completion Completion handler that receives an optional error string
 */
- (void)setFanMode:(NSInteger)fanId 
              mode:(NSInteger)mode 
        completion:(void (^)(NSString * _Nullable error))completion;

/**
 * Sets the fan speed
 * @param fanId The ID of the fan to control
 * @param value The speed value to set
 * @param completion Completion handler that receives an optional error string
 */
- (void)setFanSpeed:(NSInteger)fanId 
              value:(NSInteger)value 
         completion:(void (^)(NSString * _Nullable error))completion;

/**
 * Runs powermetrics with specified samplers
 * @param samplers Array of sampler names to use
 * @param completion Completion handler that receives an optional error string
 */
- (void)powermetrics:(NSArray<NSString *> *)samplers 
          completion:(void (^)(NSString * _Nullable error))completion;

/**
 * Uninstalls the helper
 */
- (void)uninstall;

@end
```

**Key Changes:**
- Swift closures `(String) -> Void` → Blocks `void (^)(NSString *)`
- Swift optionals `String?` → Nullability annotations `NSString * _Nullable`
- Swift `Int` → Objective-C `NSInteger`
- Swift `[String]` → Objective-C `NSArray<NSString *> *`
- Swift unnamed param `_ path:` → Objective-C named param `path:`
- Swift multi-param `id:mode:` → Objective-C split params `fanId mode:`

---

## Example 3: Structs and Enums

### Original Swift (constants.swift)
```swift
import Cocoa

public struct Popup_c_s {
    public let width: CGFloat = 264
    public let height: CGFloat = 300
    public let margins: CGFloat = 8
    public let spacing: CGFloat = 2
    public let headerHeight: CGFloat = 42
    public let separatorHeight: CGFloat = 30
    public let portalHeight: CGFloat = 120
}

public struct Widget_c_s {
    public let width: CGFloat = 32
    public var height: CGFloat {
        get {
            let systemHeight = NSApplication.shared.mainMenu?.menuBarHeight
            return (systemHeight == 0 ? 22 : systemHeight) ?? 22
        }
    }
    public var margin: CGPoint {
        get {
            var point: CGPoint = CGPoint(x: 2, y: 2)
            if #available(macOS 11.0, *) {
                point.x = 0
            }
            return point
        }
    }
    public let spacing: CGFloat = 2
}

public struct Constants {
    public static let Popup: Popup_c_s = Popup_c_s()
    public static let Widget: Widget_c_s = Widget_c_s()
    
    public static let defaultProcessIcon = NSWorkspace.shared.icon(forFile: "/bin/bash")
}

public enum ModuleType: Int {
    case CPU
    case RAM
    case GPU
    case disk
    case sensors
    case network
    case battery
    case bluetooth
    case clock
    case combined
    
    public var stringValue: String {
        switch self {
        case .CPU: return "CPU"
        case .RAM: return "RAM"
        case .GPU: return "GPU"
        case .disk: return "Disk"
        case .sensors: return "Sensors"
        case .network: return "Network"
        case .battery: return "Battery"
        case .bluetooth: return "Bluetooth"
        case .clock: return "Clock"
        case .combined: return ""
        }
    }
}
```

### Converted Objective-C (Constants.h + Constants.m)

**Constants.h:**
```objc
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ModuleType) {
    ModuleTypeCPU = 0,
    ModuleTypeRAM,
    ModuleTypeGPU,
    ModuleTypeDisk,
    ModuleTypeSensors,
    ModuleTypeNetwork,
    ModuleTypeBattery,
    ModuleTypeBluetooth,
    ModuleTypeClock,
    ModuleTypeCombined
};

NSString *NSStringFromModuleType(ModuleType type);

@interface PopupConstants : NSObject
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat margins;
@property (nonatomic, readonly) CGFloat spacing;
@property (nonatomic, readonly) CGFloat headerHeight;
@property (nonatomic, readonly) CGFloat separatorHeight;
@property (nonatomic, readonly) CGFloat portalHeight;
+ (instancetype)sharedInstance;
@end

@interface WidgetConstants : NSObject
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGPoint margin;
@property (nonatomic, readonly) CGFloat spacing;
+ (instancetype)sharedInstance;
@end

@interface Constants : NSObject
@property (class, nonatomic, readonly) PopupConstants *Popup;
@property (class, nonatomic, readonly) WidgetConstants *Widget;
@property (class, nonatomic, readonly) NSImage *defaultProcessIcon;
@end
```

**Constants.m (excerpt):**
```objc
#import "Constants.h"

NSString *NSStringFromModuleType(ModuleType type) {
    switch (type) {
        case ModuleTypeCPU: return @"CPU";
        case ModuleTypeRAM: return @"RAM";
        case ModuleTypeGPU: return @"GPU";
        case ModuleTypeDisk: return @"Disk";
        case ModuleTypeSensors: return @"Sensors";
        case ModuleTypeNetwork: return @"Network";
        case ModuleTypeBattery: return @"Battery";
        case ModuleTypeBluetooth: return @"Bluetooth";
        case ModuleTypeClock: return @"Clock";
        case ModuleTypeCombined: return @"";
        default: return @"Unknown";
    }
}

@implementation WidgetConstants

+ (instancetype)sharedInstance {
    static WidgetConstants *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WidgetConstants alloc] init];
    });
    return instance;
}

- (CGFloat)height {
    CGFloat systemHeight = [[NSApplication sharedApplication] mainMenu].menuBarHeight;
    return (systemHeight == 0.0) ? 22.0 : systemHeight;
}

- (CGPoint)margin {
    CGPoint point = CGPointMake(2.0, 2.0);
    if (@available(macOS 11.0, *)) {
        point.x = 0.0;
    }
    return point;
}

@end
```

**Key Changes:**
- Swift `struct` → Objective-C `@interface` class with singleton
- Swift `enum` → Objective-C `typedef NS_ENUM`
- Swift `case CPU` → Objective-C `ModuleTypeCPU`
- Swift computed property → Objective-C method returning value
- Swift `static let` → Class property with `+ (Type *)property` method
- Swift optional chaining `?.` → Objective-C dot notation
- Swift `#available` → Objective-C `@available`
- Enum method `var stringValue` → C function `NSStringFromModuleType()`

---

## Code Size Comparison

| File | Swift Lines | Objective-C Lines | Files | Increase |
|------|-------------|-------------------|-------|----------|
| LaunchAtLogin | 26 | 40 | 1 → 1 | +54% |
| HelperProtocol | 24 | 63 | 1 → 1 | +163% |
| Constants | 87 | 206 | 1 → 2 | +137% |

**Why Objective-C is larger:**
- Header/implementation split
- More verbose syntax
- Explicit nullability annotations
- Additional documentation
- Explicit memory management patterns

---

## Usage Comparison

### Swift Usage
```swift
let popup = Constants.Popup
let width = popup.width  // 264.0

let module = ModuleType.CPU
let name = module.stringValue  // "CPU"
```

### Objective-C Usage
```objc
PopupConstants *popup = [Constants Popup];
CGFloat width = popup.width;  // 264.0

ModuleType module = ModuleTypeCPU;
NSString *name = NSStringFromModuleType(module);  // @"CPU"
```

---

## Conclusion

The conversions demonstrate that:
1. ✅ Swift can be mechanically translated to Objective-C
2. ✅ Most patterns have clear equivalents
3. ⚠️ Code becomes more verbose (average +126% size)
4. ⚠️ Requires creating header files
5. ❌ Still uses modern APIs incompatible with Mac OS X 10.4

For true 10.4 compatibility, the APIs themselves would need replacing, not just the language syntax.
