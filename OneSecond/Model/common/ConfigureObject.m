//
//  ConfigureObject.m
//  Up
//
//  Created by zhangyx on 14/7/22.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "ConfigureObject.h"
//#import "UpdateCheckObject.h"
#import "PublicObject.h"
#import "AppDelegate.h"


@implementation ConfigureObject

static NSString * const kUPDisBundleID = @"com.upok.up";
static NSString * const kUPBetaBundleID = @"com.upokinhouse.up";
static NSString * const kUPIDPBundleID = @"com.idppush.up";

static NSString * const kUPAppID = @"673070997";

static NSString * const kUPVideoServerURL = @"video.upok.com.cn";
static NSString * const kUPServerURL = @"ssl.upok.com.cn";
static NSString * const kUPTestServerURL = @"test.upok.com.cn:444";

static NSString * const kUPServerHostUserDefaultKey = @"kUPServerHostUserDefaultKey";

#define kUpIdpGaoDeMapAppKey        @"8c501be997e4d7759e99cacf69ca66a1"
#define kUpBetaGaoDeMapAppKey       @"d891b18fb6296cccf52e65fde68de6f8"
#define kUpAppStoreGaoDeMapAppKey	@"07cfa7176e55bb684cc38aff1c4fe95b"


+ (BOOL)appIsUpInHourseScheme
{
    NSString *bundleIdenfi = [self appBundleID];
    if ([PublicObject isEmpty:bundleIdenfi]) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }
    if ([bundleIdenfi isEqualToString:kUPBetaBundleID]) {
        return YES;
    }
    return NO;
}

+ (BOOL)appIsBetaVerson
{
    NSString *bundleIdenfi = [self appBundleID];
    if ([PublicObject isEmpty:bundleIdenfi]) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }
    if ([bundleIdenfi isEqualToString:kUPDisBundleID]) {
        // 正式版
        return NO;
    }
    return YES;
}

+ (BOOL)isUpinternationalVerson
{
    if (![PublicObject isChinaRegion]) {
        // 国际版
        return YES;
    }
    return NO;
}

+ (NSString *)upServerHost
{
//    return kUPTestServerURL;
    NSString *serverHost = kUPServerURL;
    if ([self appIsBetaVerson]) {
        BOOL isTestServer = [[[NSUserDefaults standardUserDefaults] objectForKey:kUPServerHostUserDefaultKey] boolValue];
        if (isTestServer) {
            serverHost = kUPTestServerURL;
        }
    }
    return serverHost;
}

+ (void)buildUpServerHost:(BOOL)isTestServer
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isTestServer] forKey:kUPServerHostUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isTestServerHost
{
    BOOL isTestServer = [[[NSUserDefaults standardUserDefaults] objectForKey:kUPServerHostUserDefaultKey] boolValue];
    return isTestServer;
}

+ (NSString *)upVideoServerHost
{
    return kUPVideoServerURL;
}

+ (BOOL)isTestEnvironment
{
    if ([self appIsBetaVerson]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getAppID
{
    return kUPAppID;
    /*
    NSString *bundleIdenfi = [AppDelegate upAppDelegate].appBundleID;
    if ([PublicObject isEmpty:bundleIdenfi]) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }

    if ([bundleIdenfi isEqualToString:@"com.upok.upup"] ||
        [bundleIdenfi isEqualToString:@"com.upokinhouse.upup"]) {
        return kUpInternationalAPPID;
    }
    else {
        return kUpAppID;
    }
     */
}

+ (NSString *)getRateAppBundleID
{
    return kUPDisBundleID;
/*
    NSString *bundleIdenfi = [AppDelegate upAppDelegate].appBundleID;
    if ([PublicObject isEmpty:bundleIdenfi]) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }

    if ([bundleIdenfi isEqualToString:@"com.upok.upup"] ||
        [bundleIdenfi isEqualToString:@"com.upokinhouse.upup"]) {
        return @"com.upok.upup";
    }
    else {
        return @"com.upok.up";
    }
 */
}

static NSString *kUPAppBundleID = nil;
+ (NSString *)appBundleID
{
    if (!kUPAppBundleID) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        kUPAppBundleID = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }
    return kUPAppBundleID;
}




+ (NSString *)getAppRateURL
{
    NSString *evaluationAppUrl = [NSString
                                  stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",[ConfigureObject getAppID]];
    if (kIsIOS7) {
        // 在7.0下app评价链接不好用，故先调用下载连接
        evaluationAppUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xiang-shang/id%@?mt=8",[self getAppID]];;
    }
    return evaluationAppUrl;
}

+ (NSString *)getGaodeMapAppKey
{
    NSString *bundleIdenfi = [self appBundleID];
    if ([PublicObject isEmpty:bundleIdenfi]) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }
    
    if ([bundleIdenfi isEqualToString:kUPDisBundleID]) {
        // 正式版
        return kUpAppStoreGaoDeMapAppKey;
    }
    else if ([bundleIdenfi isEqualToString:kUPBetaBundleID]) {
        // 企业测试版
        return kUpBetaGaoDeMapAppKey;
    }
    else if ([bundleIdenfi isEqualToString:kUPIDPBundleID]) {
        // 开发调试版
        return kUpIdpGaoDeMapAppKey;
    }
    else {
        // 默认为正式版
        return kUpAppStoreGaoDeMapAppKey;
    }
}

@end
