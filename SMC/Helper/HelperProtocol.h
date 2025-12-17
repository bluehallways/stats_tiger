//
//  HelperProtocol.h
//  Helper
//
//  Converted from Swift to Objective-C
//  Original by Serhiy Mytrovtsiy on 17/11/2022
//  Copyright © 2022 Serhiy Mytrovtsiy. All rights reserved.
//

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
