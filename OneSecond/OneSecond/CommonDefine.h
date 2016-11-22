//
//  CommonDefine.h
//  Up
//
//  Created by An Mingyang on 13-1-23.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//
#import "AppDelegate.h"

#ifndef WherePlay_CommonDefine_h
#define WherePlay_CommonDefine_h

#define NETWORK_CONNECTION_NOT_REACHABLE UPLocalizedString(@"Check whether open network service", nil)//@"请检查网络服务!"

#endif

#define ColorForHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorForHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


#define kIsIOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    #define kIsIOS8 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
#else
    #define kIsIOS8 (0)
#endif

#define kIsTestEnvironment [ConfigureObject isTestEnvironment]

#define kNoNet UPLocalizedString(@"Check whether open network service", nil)//@"请检查是否开启了网络服务!"
#define kRequestError UPLocalizedString(@"Network error, please try again later", nil)//@"网络连接出错，请稍后再试！"
#define kUPRefreshDataErrorStr UPLocalizedString(@"Refresh failed, please try again later", nil)//@"刷新失败，请稍后再试！"
#define kUPLoadDataErrorStr UPLocalizedString(@"Failed to load please try again later", nil)//@"加载失败，请稍后再试！"
#define kInvalidNickNameErrorMsg UPLocalizedString(@"name format is not valid", nil) //@"姓名中不能包含有!@#$%^&*(){}[];':\",.<>/?`~\\|空格等特殊字符！"

// 一个像素线
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define kApplicationState [[UIApplication sharedApplication] applicationState]
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define kMainScreenFrame [[UIScreen mainScreen] applicationFrame]
#define kTabBarHeight 49.0
// 状态栏和navigationBar高度
#define kNavBarAndStatusBarHeight 64.0
#define kNavBarHeight 44.0
#define kHomeFollowSegHeight 30.5
#define kHomeNewSegHeight 95.0
// 状态栏和导航栏和tab栏总高度
#define kTabBarNavBarAndStatusBarHeight ((kTabBarHeight) + (kNavBarAndStatusBarHeight))

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kDefaultStatusBarHeight 20

#define kMainScreenActualFrame CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarNavBarAndStatusBarHeight)
#define kMainScreenNoTabBarFrame CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarAndStatusBarHeight)

#define kHomeTableFollowFrame CGRectMake(0, kHomeFollowSegHeight, kScreenWidth, kScreenHeight - kTabBarNavBarAndStatusBarHeight - kHomeFollowSegHeight)//主页关注table的frame
#define kHomeTableNewFrame CGRectMake(0, kHomeNewSegHeight, kScreenWidth, kScreenHeight - kTabBarNavBarAndStatusBarHeight - kHomeNewSegHeight)//主页最新table的frame

#define kNoNavigationBarViewOrginY [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20 : 0

#define kCornerSize 10

#define kRETURNCODE_SUCCESS 1
#define kRETURNCODE_FAIL 0
#define kRETURNCODE_INVALID 2

#define NumberPackets @"NumberPackets"
#define BonusAmount   @"BonusAmount"
#define LevelMessage  @"LevelMessage"
#define NormalMoney   @"NormalMoney"
#define LocalLanguageType @"UpLanguageType"
#define AppLanguage @"appLanguage"
#define UPLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
#define UPLocStr(key) UPLocalizedString((key), nil)

#define SVLocalizedString(key,nil) NSLocalizedString(key,nil)

#define kChannel @"channel"
#define kUserInfo @"cacheUserInfoData.plist"
#define kAddressBookUpdateTime @"kAddressBookUpdateTime"

#define kTitleFollow UPLocalizedString(@"attention", nil)
#define kTitleFollowed UPLocalizedString(@"Have concern", nil)
#define kTitleMutualFollow UPLocalizedString(@"Mutual concern", nil)

#define  kUpFont(a) [UIFont fontWithName:@"DINAlternate-bold" size:a]