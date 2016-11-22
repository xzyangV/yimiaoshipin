//
//  SecondURLHandleManager.m
//  OneSecond
//
//  Created by uper on 16/5/13.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "SecondURLHandleManager.h"
#import "ShareObject.h"
@implementation SecondURLHandleManager


+ (SecondURLHandleManager *)urlHandleManager
{
    static SecondURLHandleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SecondURLHandleManager alloc] init];
    });
    return manager;
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    NSString *urlString = [[NSString stringWithFormat:@"%@",url] lowercaseString];
    //    NSLog(@"urlString = %@",urlString);

        int platmType;
        if ([urlString hasPrefix:[NSString stringWithFormat:@"wb%@",kAppKey_sina]]) {
            // 新浪微博
            platmType = ShareTypeSinaWeibo;
        }
        else if ([urlString hasPrefix:[NSString stringWithFormat:@"tencent%@",kAppID_qzone]]) {
            // qq空间 qq
            platmType = ShareTypeQQ;
        }
        else if ([urlString hasPrefix:[NSString stringWithFormat:@"wb%@",WiressSDKDemoAppKey]]) {
            // 腾讯微博
            platmType = ShareTypeTencentWeibo;
        }
        else if ([urlString hasPrefix:[NSString stringWithFormat:@"%@",kAppID_weixin]]) {
            // 微信
            platmType = ShareTypeWeixiSession;
        }
        else if ([urlString hasPrefix:[NSString stringWithFormat:@"fb%@",kAppID_facebook]]) {
            // face book
            platmType = ShareTypeFaceBook;
        }
        else if ([urlString hasPrefix:[NSString stringWithFormat:@"uper10000"]]){
            //  uper
            platmType = ShareTypeUper;
        }
        else {
            // 其他
            platmType = 0;
        }
    return  [ShareObject handleOpenUrl:url sourceApplication:sourceApplication shareType:platmType];

}

@end
