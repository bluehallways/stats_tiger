//
//  Constants.m
//  Kit
//
//  Converted from Swift to Objective-C
//  Original by Serhiy Mytrovtsiy on 15/04/2020.
//  Copyright © 2020 Serhiy Mytrovtsiy. All rights reserved.
//

#import "Constants.h"

NSString *NSStringFromModuleType(ModuleType type) {
    switch (type) {
        case ModuleTypeCPU:
            return @"CPU";
        case ModuleTypeRAM:
            return @"RAM";
        case ModuleTypeGPU:
            return @"GPU";
        case ModuleTypeDisk:
            return @"Disk";
        case ModuleTypeSensors:
            return @"Sensors";
        case ModuleTypeNetwork:
            return @"Network";
        case ModuleTypeBattery:
            return @"Battery";
        case ModuleTypeBluetooth:
            return @"Bluetooth";
        case ModuleTypeClock:
            return @"Clock";
        case ModuleTypeCombined:
            return @"";
        default:
            return @"Unknown";
    }
}

#pragma mark - PopupConstants

@implementation PopupConstants

+ (instancetype)sharedInstance {
    static PopupConstants *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PopupConstants alloc] init];
    });
    return instance;
}

- (CGFloat)width {
    return 264.0;
}

- (CGFloat)height {
    return 300.0;
}

- (CGFloat)margins {
    return 8.0;
}

- (CGFloat)spacing {
    return 2.0;
}

- (CGFloat)headerHeight {
    return 42.0;
}

- (CGFloat)separatorHeight {
    return 30.0;
}

- (CGFloat)portalHeight {
    return 120.0;
}

@end

#pragma mark - SettingsConstants

@implementation SettingsConstants

+ (instancetype)sharedInstance {
    static SettingsConstants *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SettingsConstants alloc] init];
    });
    return instance;
}

- (CGFloat)width {
    return 540.0;
}

- (CGFloat)height {
    return 480.0;
}

- (CGFloat)margin {
    return 10.0;
}

- (CGFloat)row {
    return 30.0;
}

@end

#pragma mark - WidgetConstants

@implementation WidgetConstants

+ (instancetype)sharedInstance {
    static WidgetConstants *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WidgetConstants alloc] init];
    });
    return instance;
}

- (CGFloat)width {
    return 32.0;
}

- (CGFloat)height {
    CGFloat systemHeight = [[NSApplication sharedApplication] mainMenu].menuBarHeight;
    return (systemHeight == 0.0) ? 22.0 : systemHeight;
}

- (CGPoint)margin {
    CGPoint point = CGPointMake(2.0, 2.0);
    
    // Check for macOS 11.0+
    if (@available(macOS 11.0, *)) {
        point.x = 0.0;
    }
    
    return point;
}

- (CGFloat)spacing {
    return 2.0;
}

@end

#pragma mark - Constants

@implementation Constants

+ (PopupConstants *)Popup {
    return [PopupConstants sharedInstance];
}

+ (SettingsConstants *)Settings {
    return [SettingsConstants sharedInstance];
}

+ (WidgetConstants *)Widget {
    return [WidgetConstants sharedInstance];
}

+ (NSImage *)defaultProcessIcon {
    static NSImage *icon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        icon = [[NSWorkspace sharedWorkspace] iconForFile:@"/bin/bash"];
    });
    return icon;
}

@end
