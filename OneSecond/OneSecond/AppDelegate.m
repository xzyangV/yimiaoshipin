//
//  AppDelegate.m
//  OneSecond
//
//  Created by uper on 16/5/12.
//  Copyright © 2016年 uper. All rights reserved.
//  xiaozhou

#import "AppDelegate.h"
#import "PushManager.h"
#import "SecondURLHandleManager.h"
#import "VideoRecordViewController.h"
#import "WelcomeViewController.h"
#import "DeviceObject.h"
#import "AdLunchView.h"
#import "Harpy.h"
#import "Reachability.h"
#import "EventCounting.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)upAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    Reachability* hostReach =[Reachability reachabilityForInternetConnection];
    [hostReach startNotifier]; //开始监听,会启动一个run loop
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self checkIsFirstRunApp];//检测是否第一次启动App 判断是否显示广告页
//    [Harpy checkVersion];//检测版本信息 ,是否需要强制更新
    
    //APP全局参数
    [DeviceObject appupdateTimestamp];
    //开始统计初始化
    [EventCounting startCounting];
    NSDictionary *remoteUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteUserInfo) {
        [self checkIsFirstRunApp];
    }
    
    [PushManager handleRemoteNotificationWithUserInfo:remoteUserInfo isLaunch:YES];//处理推送操作
    [self performSelector:@selector(resignPushNotification) withObject:nil afterDelay:3];

    return YES;
}

- (void)resignPushNotification
{
    [PushManager registerRemoteNotification];// 注册通知
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PushManager registerDeviceToken:deviceToken];//注册成功，将deviceToken保存到应用服务器数据库中
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [PushManager registerFailed];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PushManager handleRemoteNotificationWithUserInfo:userInfo isLaunch:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [DeviceObject appupdateTimestamp];

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [SecondURLHandleManager application:application openURL:url sourceApplication:sourceApplication];
}

- (void)reloadApp{
    [self buildRootView];
}

- (void)checkIsFirstRunApp
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *welcomeStr = [user objectForKey:@"isFirstRunApp"];
    
    if ([PublicObject isEmpty:welcomeStr]) {
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor clearColor];
        self.window.rootViewController = [[WelcomeViewController alloc]init];
        [self.window makeKeyAndVisible];
        [user setObject:@"isAlreadyRun" forKey:@"isFirstRunApp"];
        [user synchronize];
    }else{
        [self buildRootView];
    }
}

- (void)buildRootView{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:[[VideoRecordViewController alloc] init]];
    self.window.rootViewController = nav;
    nav.navigationBar.translucent = NO;
    [self.window makeKeyAndVisible];
}

- (void)networkStateChange
{
    if (![PublicObject networkIsReachableForShowAlert:YES]) {
        return;
    }
}
@end
