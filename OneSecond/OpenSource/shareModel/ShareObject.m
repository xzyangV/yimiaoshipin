//
//  ShareObject.m
//  OneSecond
//
//  Created by uper on 16/5/13.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "ShareObject.h"

#import "ShareWeiboObject.h"
#import "ShareWeixin.h"
#import "ShareQQ.h"
#import "ShareQzone.h"
#import "ShareFaceBook.h"
#import "ShareUper.h"

@implementation ShareObject


+ (BOOL)initializePlatWithAppKey:(NSString *)appKey
                       appSecret:(NSString *)appSecret
                     redirectUri:(NSString *)redirectUri
                       shareType:(ShareType)shareType
               andRootController:(UIViewController *)rootController

{
    if (shareType == ShareTypeSinaWeibo) {
        // 新浪微博
        [[ShareWeiboObject ShareWeiboObjectInstance] connectSinaWeiboWithAppKey:appKey];
        return YES;
    }
    else if (shareType == ShareTypeQQSpace) {
        // qq空间
        [[ShareQzone qzoneInstance] connectQZoneWithAppKey:appKey];
        return YES;
    }
    else if (shareType == ShareTypeMail) {
        // 邮件
        return NO;
    }
    else if (shareType == ShareTypeSMS ) {
        // 短信
        return NO;
    }
    else if (shareType == ShareTypeWeixiSession ) {
        // 微信好友
        return [[ShareWeixin weixinInstance] connectWeixinWithAppID:appKey];
    }
    else if (shareType == ShareTypeWeixiTimeline ) {
        // 微信朋友圈
        return [[ShareWeixin weixinInstance] connectWeixinWithAppID:appKey];
    }
    else if (shareType == ShareTypeQQ ) {
        // qq
        [[ShareQQ QQInstance] connectQQWithAppID:appKey];
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isCanShareToSnsWithType:(ShareType)shareType
{
    if (![PublicObject networkIsReachableForShowAlert:YES]) {
        return NO;
    }
    if (shareType == ShareTypeSinaWeibo) {
        [ShareObject initializePlatWithAppKey:kAppKey_sina
                                    appSecret:kAppSecret_sina
                                  redirectUri:kAppRedirectURI_sina
                                    shareType:ShareTypeSinaWeibo
                            andRootController:nil];
        
        return YES;
    }
    else if (shareType == ShareTypeWeixiSession || shareType == ShareTypeWeixiTimeline) {
        BOOL isCanShare = [ShareObject initializePlatWithAppKey:kAppID_weixin
                                                      appSecret:@""
                                                    redirectUri:@""
                                                      shareType:shareType
                                              andRootController:nil];
        if (!isCanShare) {
            [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow
                                        labelText:UPLocalizedString(@"weixin registration failed unable to share!", nil)//@"微信注册失败，暂时不能分享！"
                                       afterDelay:kStayTime];
        }
        return isCanShare;
    }
    else if (shareType == ShareTypeQQ || shareType == ShareTypeQQSpace) {
        [ShareObject initializePlatWithAppKey:kAppID_qq
                                    appSecret:@""
                                  redirectUri:@""
                                    shareType:ShareTypeQQ
                            andRootController:nil];
        return YES;
    }
    else if (shareType == ShareTypeTwitter) {
        [ShareObject initializePlatWithAppKey:kAppKey_twitter
                                    appSecret:kAppSecret_twitter
                                  redirectUri:nil
                                    shareType:ShareTypeTwitter
                            andRootController:nil];
        return YES;
    }
    else if (shareType == ShareTypeFaceBook) {
        [ShareObject initializePlatWithAppKey:kAppID_facebook
                                    appSecret:nil
                                  redirectUri:nil
                                    shareType:ShareTypeFaceBook
                            andRootController:nil];
        return YES;
    }
    return NO;
}

+ (BOOL)isSupportSSOLogin:(ShareType)shareType
{
    if (shareType == ShareTypeQQSpace || shareType == ShareTypeQQ) {
        
//        return [ShareQzone isSupportIphoneSSOLogin];
        return YES;
    }
    return YES;
}


+ (BOOL)isAuthResultWithType:(ShareType)shareType
{
    if (shareType == ShareTypeSinaWeibo) {
        //        return [[ShareSinaWeibo sinaWeiboInstance] isUserInfoResult];
        //        [[NShareSinaWeibo newSinaWeiboShareInstance] connectSinaWeiboWithAppKey:<#(NSString *)#>]
        return YES;//[[NShareSinaWeibo newSinaWeiboShareInstance] isAuthValid];
    }
//    else if (shareType == ShareTypeTencentWeibo) {
//        return NO;//[[ShareTecentWeibo tecentWeiboInstance] isAuthResult];
//    }
    else if (shareType == ShareTypeFaceBook) {
        return [[ShareFaceBook shareToFBInstance] isAuthLoginResult];
    }
    return YES;
}

+ (void)authLoginWithType:(ShareType)shareType
                   result:(AuthLoginEventHandler)authLoginResult
{
    
    [self authLoginWithType:shareType viewController:nil result:authLoginResult];
    
}

+ (void)authLoginWithType:(ShareType)shareType
           viewController:(UIViewController *)controller
                   result:(AuthLoginEventHandler)authLoginResult
{
    if (shareType == ShareTypeSinaWeibo) {
        // 新浪微博
        [[ShareWeiboObject ShareWeiboObjectInstance] newSinaAuthLogiResult:authLoginResult];
    }
    else if (shareType == ShareTypeQQSpace || shareType == ShareTypeQQ) {
        // qq空间
        [[ShareQzone qzoneInstance] qzoneAuthLoginWithResult:^(BOOL result, BOOL isCancel, NSString *error) {
            if (authLoginResult) {
                authLoginResult (result,isCancel,error);
            }
        }];
    }
    else if (shareType == ShareTypeFaceBook) {
        // facebook
        [[ShareFaceBook shareToFBInstance] faceBookAuthLoginWithResult:^(BOOL result, BOOL isCancel, NSString *error) {
            if (authLoginResult) {
                authLoginResult (result,isCancel,error);
            }
        }];
        
    }
//    else if (shareType == ShareTypeInstagram) {
//        // Instagram
//        [[ShareInstagram shareInstagramInstance] instagramAuthLoginWithController:controller
//                                                                           result:^(BOOL result, BOOL isCancel, NSString *error, ShareUserInfo *userInfo) {
//                                                                               if (authLoginResult) {
//                                                                                   authLoginResult (result,isCancel,error);
//                                                                               }
//                                                                           }];
//    }
//    else if (shareType == ShareTypeTencentWeibo) {
//        // 腾讯微博
//    }
//    else if (shareType == ShareTypeMail) {
//        // 邮件
//    }
//    else if (shareType == ShareTypeSMS ) {
//        // 短信
//    }
    else if (shareType == ShareTypeWeixiSession ) {
        // 微信好友
        if (authLoginResult) {
            authLoginResult (YES,NO,nil);
        }
    }
    else if (shareType == ShareTypeWeixiTimeline ) {
        // 微信朋友圈
        if (authLoginResult) {
            authLoginResult (YES,NO,nil);
        }
    }
    else {
    }
}

+ (void)showShareWithType:(ShareType)shareType
                  content:(ShareContent *)content
                   result:(PublishContentEventHandler)aresult
{
    
    if (shareType == ShareTypeSinaWeibo) {
        // 新浪微博
        //        [[ShareSinaWeibo sinaWeiboInstance] showShareWithContent:content result:^(ShareType type, BOOL result) {
        //
        //            if (aresult) {
        //                aresult(type,result);
        //            }
        //        }];
        [[ShareWeiboObject ShareWeiboObjectInstance] showNSinaShareWithContent:content result:aresult];
    }
    else if (shareType == ShareTypeFaceBook) {
        // facebook
        [[ShareFaceBook shareToFBInstance] showShareWithContent:content result:aresult];
    }
//    else if (shareType == ShareTypeMail) {
//        // 邮件
//    }
//    else if (shareType == ShareTypeSMS ) {
//        // 短信
//    }
    else if (shareType == ShareTypeWeixiSession ) {
        // 微信好友
        [[ShareWeixin weixinInstance] showSessionShareWithContent:content result:aresult];
    }
    else if (shareType == ShareTypeWeixiTimeline ) {
        // 微信朋友圈
        [[ShareWeixin weixinInstance] showTimeLineShareWithContent:content result:aresult];
    }
    else if (shareType == ShareTypeQQ || shareType == ShareTypeQQSpace) {
        // qq
        [[ShareQQ QQInstance] showShareWithContent:content
                                         shareType:shareType
                                            result:aresult];
        
    }
//    else if (shareType == ShareTypeQQSpace) {
//        // qq
//        [[ShareQzone qzoneInstance] showShareWithContent:content result:aresult];
//        
//    }
    else {
        
    }
}

// 创建分享内容
+ (ShareContent *)content:(NSString *)content
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                imagePath:(NSString *)imagepath
           thumbimagePath:(NSString *)thumbImagePath
                mediaType:(PublishContentMediaType)mediaType
{
    ShareContent* publishContent = [[ShareContent alloc] init];
    [publishContent setContent:content];
    [publishContent setTitle:title];
    [publishContent setUrl:url];
    [publishContent setDesc:description];
    [publishContent setMediaType:mediaType];
    [publishContent setImagePath:imagepath];
    [publishContent setThumbImagePath:thumbImagePath];
    
    
    return publishContent;
}

// 创建分享内容
+ (ShareContent *)content:(NSString *)content
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                    image:(UIImage *)image
               thumbimage:(UIImage *)thumbImage
                mediaType:(PublishContentMediaType)mediaType
{
    ShareContent *publishContent = [[ShareContent alloc] init];
    [publishContent setContent:content];
    [publishContent setTitle:title];
    [publishContent setUrl:url];
    [publishContent setDesc:description];
    [publishContent setMediaType:mediaType];
    [publishContent setShareImage:image];
    [publishContent setThumbImage:thumbImage];
    
    
    return publishContent;
}

// 创建分享内容
+ (ShareContent *)content:(NSString *)content
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                imageData:(NSData *)imageData
           thumbimageData:(NSData *)thumbImageData
                mediaType:(PublishContentMediaType)mediaType
{
    ShareContent* publishContent = [[ShareContent alloc] init];
    [publishContent setContent:content];
    [publishContent setTitle:title];
    [publishContent setUrl:url];
    [publishContent setDesc:description];
    [publishContent setMediaType:mediaType];
    [publishContent setShareImageData:imageData];
    [publishContent setThumbImageData:thumbImageData];
    
    
    return publishContent;
}




+ (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication shareType:(ShareType)shareType
{
    
    if (shareType == ShareTypeSinaWeibo) {
        // 新浪微博
        return [[ShareWeiboObject ShareWeiboObjectInstance] newSinahandleOpenUrl:url];
    }

    else if (shareType == ShareTypeQQSpace) {
        // qq空间
        return [[ShareQzone qzoneInstance] handleOpenURL:url];
    }
    else if (shareType == ShareTypeFaceBook) {
        // face book
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                        fallbackHandler:^(FBAppCall *call) {
                            NSLog(@"In fallback handler");
                        }];
    }
//    else if (shareType == ShareTypeMail) {
//        // 邮件
//        return NO;
//    }
//    else if (shareType == ShareTypeSMS ) {
//        // 短信
//        return NO;
//    }
    else if (shareType == ShareTypeWeixiSession ) {
        // 微信好友
        return [[ShareWeixin weixinInstance] handleOpenUrl:url];
    }
    else if (shareType == ShareTypeWeixiTimeline ) {
        // 微信朋友圈
        return [[ShareWeixin weixinInstance] handleOpenUrl:url];
    }
    else if (shareType == ShareTypeQQ ) {
        // qq
        return [[ShareQQ QQInstance] handleOpenUrl:url];
    }
    else if (shareType == ShareTypeUper){
        return [[ShareUper uperShareInstance] handleOpenUrl:url];
    }
    else{
        return NO;
    }
}

+ (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    NSLog(@"urlString = %@",urlString);
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
    else {
        // 其他
        platmType = 0;
    }
    return [ShareObject handleOpenUrl:url sourceApplication:sourceApplication shareType:platmType];
}

@end
