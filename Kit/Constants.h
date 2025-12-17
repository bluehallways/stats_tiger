//
//  Constants.h
//  Kit
//
//  Converted from Swift to Objective-C
//  Original by Serhiy Mytrovtsiy on 15/04/2020.
//  Copyright © 2020 Serhiy Mytrovtsiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Module type enumeration
 */
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

/**
 * Returns the string representation of a module type
 */
NSString *NSStringFromModuleType(ModuleType type);

/**
 * Popup window constants
 */
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

/**
 * Settings window constants
 */
@interface SettingsConstants : NSObject

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat margin;
@property (nonatomic, readonly) CGFloat row;

+ (instancetype)sharedInstance;

@end

/**
 * Widget constants
 */
@interface WidgetConstants : NSObject

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGPoint margin;
@property (nonatomic, readonly) CGFloat spacing;

+ (instancetype)sharedInstance;

@end

/**
 * Global constants container
 */
@interface Constants : NSObject

@property (class, nonatomic, readonly) PopupConstants *Popup;
@property (class, nonatomic, readonly) SettingsConstants *Settings;
@property (class, nonatomic, readonly) WidgetConstants *Widget;
@property (class, nonatomic, readonly) NSImage *defaultProcessIcon;

@end

NS_ASSUME_NONNULL_END
