//
//  main.m
//  LaunchAtLogin
//
//  Converted from Swift to Objective-C
//  Original by Serhiy Mytrovtsiy on 08/04/2020.
//  Copyright © 2020 Serhiy Mytrovtsiy. All rights reserved.
//

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
