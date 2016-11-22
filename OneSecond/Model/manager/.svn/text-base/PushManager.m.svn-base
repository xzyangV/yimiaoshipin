//
//  PushManager.m
//  OneSecond
//
//  Created by uper on 16/5/12.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "PushManager.h"
#import "DeviceObject.h"

#define kShowRegistRemoteNotifyKey @"RegistRemoteNotifyTime"

@implementation PushManager


static NSString *kUPDeviceToken = nil;

+ (NSString *)deviceToken
{
    return (kUPDeviceToken == nil) ? @"" : kUPDeviceToken;
}

+ (void)registerRemoteNotification
{
    BOOL isRegisted;
    if (kIsIOS8) {
        isRegisted = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType remoteType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isRegisted = remoteType != UIRemoteNotificationTypeNone;
    }
    
    if (isRegisted) {
        [self actualRegisterForRemoteNotification];
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self delayShowNotificationAlertView];
        });
    }
}

+ (void)delayShowNotificationAlertView
{
    NSDate *preShowDate = [self getRegistRemoteNotifyTime];
    
    if (preShowDate) {
        BOOL isShowRegistNotify = [[NSUserDefaults standardUserDefaults] boolForKey:kRegistRemoteNotify];
        if (isShowRegistNotify) {
            // 注册时间不为空直接注册通知获取token，系统提示框只弹出一次。
            [self actualRegisterForRemoteNotification];
            return;
        }
        else {
            NSDate *currentDate = [NSDate date];
            NSTimeInterval timeseconds = [currentDate timeIntervalSinceDate:preShowDate];
            if (timeseconds < kRegistRemoteGapSectonds) {
                [PushManager updateUserToken:nil];
                return;
            }
        }
    }
    
    [PushManager setUserRegistRemoteNotifyTime:[NSDate date]];
    [self actualRegisterForRemoteNotification];

    // 注册时间为空弹出uper提示框
//    if ([UIApplication sharedApplication].keyWindow == [AppDelegate upAppDelegate].window) {
//        [PublicObject showAlertViewWithTitle:SVLocalizedString(@"One-sec video would like to send you notifications", nil)
//                                  message:SVLocalizedString(@"Allow notifications", nil)
//                              cancelTitle:SVLocalizedString(@"unwish", nil)
//                               otherTitle:SVLocalizedString(@"wish", nil)
//                               completion:^(BOOL cancelled, NSInteger buttonIndex)
//         {
//             // 存储注册的时间
//             [PushManager setUserRegistRemoteNotifyTime:[NSDate date]];
//             if (cancelled) {
//                 [self updateUserToken:nil];
//             }
//             else {
//                 [self actualRegisterForRemoteNotification];
//             }
//         }];
//    }
//    else {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self delayShowNotificationAlertView];
//        });
//    }
}


+ (void)actualRegisterForRemoteNotification
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRegistRemoteNotify];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 注册通知
    BOOL isRegist;
    
    if (kIsIOS8) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        isRegist = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
        UIRemoteNotificationType remoteType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isRegist = remoteType != UIRemoteNotificationTypeNone;
    }
    
    if (!isRegist) {
        // 尚未注册通知，或者关闭通知
        // 延迟执行获取登录用户信息。如果通知注册成功了，在didRegisterForRemoteNotificationsWithDeviceToken里面取消执行
        [self performSelector:@selector(updateUserToken:) withObject:nil afterDelay:3];
    }
    
}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    // 注册成功，将deviceToken保存到应用服务器数据库中
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    // 去掉空格
    NSString *noSpaceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 将bundle id 拼接
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    
//    kUPDeviceToken = [noSpaceToken stringByAppendingFormat:@";%@",bundleIdenfi];//正式版token
      kUPDeviceToken = [noSpaceToken stringByAppendingFormat:@";%@%@",bundleIdenfi,@"-dev"];//测试版token

    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateUserToken:) object:nil];
    
    [PushManager updateUserToken:nil];
}

+ (void)registerFailed
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    // 更新用户token
    [PushManager updateUserToken:nil];
    
}

+ (void)handleRemoteNotificationWithUserInfo:(NSDictionary *)userInfo isLaunch:(BOOL)isLaunch
{
    if (!userInfo || userInfo.count == 0) {
        return;
    }
    NSDictionary *apnsInfo = [userInfo objectForKey:@"aps"];
    int type = [[apnsInfo objectForKey:@"type"] intValue];
//    NSString *associatedValue = [apnsInfo objectForKey:@"u"];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        if (type ==1) {
            
        }
    }
    
}

+ (void)updateUserToken:(ExecCompletedBlock)completedBlock
{
    //上传token到服务器

//    NSTimeInterval tiemInter = [[NSDate date] timeIntervalSince1970];
//    NSString *timeStr = [NSString stringWithFormat:@"%d",(int)tiemInter];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"user_id"];
    [dict setObject:[PublicObject getCurrentDate] forKey:@"login_uuid"];
    
    NSDictionary *formatParam = [PublicObject formatParameters:dict secondKey:@"login_uuid"];
    [UPNetworkManager requestWithPath:kupdateDeviceInfo
                           parameters:formatParam
                    completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (![responseObject isKindOfClass:[NSDictionary class]]) {
                            if (completedBlock) {completedBlock(NO, kRequestError);}
                            return ;
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kFinishResignPushNotification object:nil];
                        
                        NSDictionary *returnDic = responseObject;
                        
                        int returnCode = [[returnDic objectForKey:kUPNetworkKeyCode] intValue];
                        NSString *msg = [returnDic objectForKey:kUPNetworkKeyMessage];
                        
                        if (returnCode == UPNetworkCodeSuccess) {
                            NSDictionary *dictData = [responseObject objectForKey:kUPNetworkKeyData];

                            [[DeviceObject sharedDeviceObject] setValuesForDictionary:dictData];//存储设备device_info_id
                           
                        }
                        else {
                          
                            
                        if (completedBlock) {completedBlock(NO, msg);}
                        }
                    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                        if (completedBlock) {completedBlock(NO, [error localizedDescription]);}
                    }];
    
    
}
// 存储用户显示注册通知时间
+ (void)setUserRegistRemoteNotifyTime:(NSDate *)date
{
    if (date) {
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:[self getRegistRemoteNotifyKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSDate *)getRegistRemoteNotifyTime{
    NSDate *preDate = [[NSUserDefaults standardUserDefaults] objectForKey:[self getRegistRemoteNotifyKey]];
    return preDate;
}

+ (NSString *)getRegistRemoteNotifyKey
{
    return kShowRegistRemoteNotifyKey;
}

@end
