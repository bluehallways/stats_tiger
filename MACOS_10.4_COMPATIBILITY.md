# macOS 10.4 Tiger Compatibility Analysis

## Executive Summary

Converting Stats to run on Mac OS X 10.4 Tiger (2005) is **not feasible** through Swift-to-Objective-C conversion alone. This document explains why and what would actually be required.

## Timeline Context

- **Mac OS X 10.4 Tiger**: Released April 2005
- **Swift Language**: Announced June 2014 (9 years later)
- **Stats App**: Built for macOS 10.13+ (2017, 12 years later)

## Critical API Incompatibilities

### 1. NSRunningApplication
**Used in:** LaunchAtLogin/main.m
```objc
NSArray *runningApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:mainBundleId];
```
**Problem:** NSRunningApplication was introduced in **macOS 10.6** (2009)

**10.4 Alternative:**
```objc
// Would need to use Carbon Process Manager or parse `ps` output
ProcessSerialNumber psn;
ProcessInfoRec info;
// Complex Carbon API calls here...
```

### 2. NSWorkspace Modern Methods
**Used in:** LaunchAtLogin/main.m
```objc
[[NSWorkspace sharedWorkspace] launchApplication:mainPath];
```
**Problem:** Modern NSWorkspace methods have different signatures in 10.4

**10.4 Alternative:**
```objc
// Use Launch Services (Carbon framework)
LSApplicationParameters params;
FSRef appRef;
// More complex setup...
LSOpenApplication(&appRef, &outPSN, &params);
```

### 3. Blocks (Closures)
**Used in:** HelperProtocol.h, Constants.m
```objc
- (void)versionWithCompletion:(void (^)(NSString *))completion;
```
**Problem:** Blocks were introduced in **Mac OS X 10.6** with modern LLVM

**10.4 Alternative:**
```objc
// Use target-action pattern or delegates
@protocol HelperDelegate
- (void)helper:(Helper *)helper didGetVersion:(NSString *)version;
@end
```

### 4. Grand Central Dispatch
**Used in:** Constants.m
```objc
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{ ... });
```
**Problem:** GCD was introduced in **macOS 10.6**

**10.4 Alternative:**
```objc
// Use @synchronized or pthread_once
static pthread_once_t onceToken = PTHREAD_ONCE_INIT;
pthread_once(&onceToken, initFunction);
```

### 5. Modern Objective-C Features
**Used throughout:**
- `@property` with automatic synthesis (10.5+)
- Dot notation for properties (10.5+)
- `@available()` checks (modern)
- Fast enumeration `for (id obj in array)` (10.5+)
- Literals `@[]`, `@{}`, `@"string"` (10.8+)

**10.4 Alternative:**
- Manual getter/setter methods
- Bracket notation only
- Runtime version checks
- Traditional for loops with `NSEnumerator`
- Traditional object creation

## System APIs Not Available in 10.4

### SMC (System Management Controller) Access
The entire sensor reading system would need rewriting:
- IOKit interfaces have changed
- SMC key access methods different
- Temperature sensor APIs evolved

### Modern Cocoa Features
- NSStatusItem (menu bar) API differences
- NSPopover (didn't exist)
- NSStackView (didn't exist)
- Auto Layout (10.7+)
- Many AppKit drawing APIs

### Memory Management
10.4 used **manual retain/release**, not ARC:
```objc
// Modern (ARC)
NSString *text = [[NSString alloc] initWithFormat:@"Hello"];

// 10.4 (Manual)
NSString *text = [[[NSString alloc] initWithFormat:@"Hello"] autorelease];
```

## What Would Actually Be Required

### 1. Complete Rewrite (Not Conversion)
- Start from scratch with Carbon/Cocoa 10.4 APIs
- Estimated time: **6-12 months** full-time development
- Lose 90%+ of modern functionality

### 2. Framework Replacements
| Modern Framework | 10.4 Alternative |
|-----------------|------------------|
| Modern Cocoa | Carbon + Old Cocoa |
| NSRunningApplication | Process Manager |
| GCD | pthreads |
| Blocks | Delegates/Target-Action |
| ARC | Manual memory management |
| NSJSONSerialization | Third-party JSON library |
| NSURLSession | NSURLConnection |
| Modern layout | Manual frame calculation |

### 3. Feature Cuts
Many features would be impossible on 10.4:
- Modern GPU monitoring (APIs didn't exist)
- Bluetooth monitoring (limited APIs)
- Network monitoring (different APIs)
- Many sensor readings (SMC access changed)
- Widgets/Extensions (didn't exist)
- Localization in modern format

### 4. Development Environment
- Can't use modern Xcode
- Would need Xcode 2.x (2006)
- No Swift, limited Objective-C
- No modern debugging tools
- Testing on real hardware required (VMs unreliable)

## Realistic Alternatives

### Option 1: Target 10.6 Snow Leopard Instead
- Much more feasible (only 8 year old APIs vs 15+)
- Blocks and GCD available
- Modern Objective-C 2.0
- Estimated time: 2-3 months

### Option 2: Create "Stats Lite" for Old Systems
- Basic CPU, RAM, Disk monitoring only
- No SMC sensors
- Simple menu bar display
- Estimated time: 1-2 months
- Would be a new, simpler app

### Option 3: Use Existing Legacy Apps
- iStat Menus had 10.4-compatible versions
- MenuMeters supported old OS versions
- Temperature Monitor supported older systems

## Proof of Concept Limitations

Our conversion demonstrates:
- ✅ Swift can be converted to Objective-C syntactically
- ✅ Basic patterns translate well
- ❌ Modern APIs have no 10.4 equivalents
- ❌ Even Objective-C code uses post-10.4 features
- ❌ Not a viable path to 10.4 compatibility

## Conclusion

**Converting Stats to run on macOS 10.4 is not practically achievable** through code conversion. It would require:

1. Complete ground-up rewrite
2. Using only 2005-era APIs
3. Eliminating most features
4. 6-12 months of dedicated development
5. Creating essentially a different application

The proof-of-concept conversion successfully demonstrates Swift-to-Objective-C translation but cannot overcome the fundamental API incompatibilities between modern macOS (10.13+) and Tiger (10.4).

## Recommendation

**Do not attempt full 10.4 conversion.** Instead:
- Maintain modern Swift version for macOS 10.13+
- Consider 10.6+ support if older system support is critical
- Reference existing legacy monitoring tools for 10.4 users
- Focus development on modern features and improvements

---

*This analysis is based on actual API availability and development constraints. The 3 files converted as proof-of-concept would not run on 10.4 despite being Objective-C due to modern API usage.*
