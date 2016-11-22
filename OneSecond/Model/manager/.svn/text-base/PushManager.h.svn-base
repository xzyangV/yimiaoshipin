//
//  PushManager.h
//  OneSecond
//
//  Created by uper on 16/5/12.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRegistRemoteNotify @"kRegistRemoteNotify"
#define kRegistRemoteGapSectonds 2 * 24 * 3600

@interface PushManager : NSObject



+ (NSString *)deviceToken;
+ (void)registerRemoteNotification;
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)registerFailed;
+ (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)userInfo isLaunch:(BOOL)isLaunch;

@end
