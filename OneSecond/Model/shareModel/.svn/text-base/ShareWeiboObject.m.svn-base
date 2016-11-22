//
//  ShareWeiboObject.m
//  OneSecond
//
//  Created by uper on 16/5/13.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "ShareWeiboObject.h"
#import "WeiboSDK.h"

// user default key
#define kSinaWeiBoAuthData @"SinaWeiboAuthData"
#define kSinaUserIDKey @"UserIDKey"
#define kSinaAccessTokenKey @"AccessTokenKey"
#define kSinaExpirationDateKey @"ExpirationDateKey"

#define kSinaWeiboLogOutTag @"kSinaWeiboLogOutTag"
@interface ShareWeiboObject () <WeiboSDKDelegate,WBHttpRequestDelegate>


@property (nonatomic,strong) NSString *access_token;
@property (nonatomic,strong) NSString *user_sina_id;
@property (nonatomic,strong) NSDate *expiration_date;

@property (nonatomic,copy) AuthLoginEventHandler authLoginResult;
@property (nonatomic,copy) PublishContentEventHandler publishContentResult;

@end

@implementation ShareWeiboObject


+ (ShareWeiboObject *)ShareWeiboObjectInstance
{
    static ShareWeiboObject *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[ShareWeiboObject alloc] init];
        
        NSDictionary *authData = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaWeiBoAuthData];
        if (authData.count > 0) {
            singleton.access_token = [authData objectForKey:kSinaAccessTokenKey];
            singleton.expiration_date = [authData objectForKey:kSinaExpirationDateKey];
            singleton.user_sina_id = [authData objectForKey:kSinaUserIDKey];
        }
    });
    return singleton;
}

// 注册
- (void)connectSinaWeiboWithAppKey:(NSString *)appKey
{
    [WeiboSDK registerApp:appKey];
    [WeiboSDK enableDebugMode:NO];
}

//认证登陆
- (void)newSinaAuthLogiResult:(AuthLoginEventHandler)result{
    self.authLoginResult = result;
    [self ssoAuthLogin];
}

- (void)ssoAuthLogin
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kAppRedirectURI_sina;
    request.scope = @"all";
    if (![WeiboSDK sendRequest:request]) {
        NSLog(@"error = %@",request);
    }
    
}

- (BOOL)newSinahandleOpenUrl:(NSURL *)url
{
    BOOL isOpen = [WeiboSDK handleOpenURL:url delegate:self];
    return isOpen;
}


// 分享信息
- (void)showNSinaShareWithContent:(ShareContent *)content
                           result:(PublishContentEventHandler)result
{
    self.publishContentResult = result;
    [self postStatusWithContent:content];
}

- (void)postStatusWithContent:(ShareContent *)postContent
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kAppRedirectURI_sina;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    
    if (postContent.mediaType == PublishContentMediaTypeText) {
        message.text = postContent.content;
    }
    else if (postContent.mediaType == PublishContentMediaTypeImage) {
        message.text = postContent.content;
        WBImageObject *imageObj = [WBImageObject object];
        imageObj.imageData = UIImageJPEGRepresentation(postContent.shareImage, 1.0);
        message.imageObject = imageObj;
    }
    else if (postContent.mediaType == PublishContentMediaTypeNews) {
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = [PublicObject MD5ForString:[postContent.desc stringByAppendingString:postContent.url]];
        webpage.title = postContent.title;
        webpage.description = postContent.desc;
        webpage.thumbnailData = UIImageJPEGRepresentation(postContent.thumbImage, 1.0);
        webpage.webpageUrl = postContent.url;
        message.mediaObject = webpage;
    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message
                                                                                  authInfo:authRequest
                                                                              access_token:self.access_token];
    //    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
    //                         @"Other_Info_1": [NSNumber numberWithInt:123],
    //                         @"Other_Info_2": @[@"obj1", @"obj2"],
    //                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (void)saveAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.access_token, kSinaAccessTokenKey,
                              self.expiration_date, kSinaExpirationDateKey,
                              self.user_sina_id, kSinaUserIDKey, nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:kSinaWeiBoAuthData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//+ (void)shareWeiboWithObject:(NSObject*)object{
//    [ShareWeiboObject shareButtonPressed];
//}
//
//+ (void)shareButtonPressed
//{
////    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
//    authRequest.scope = @"all";
//    
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[ShareWeiboObject messageToShare] authInfo:authRequest access_token:nil];
////    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
////                         @"Other_Info_1": [NSNumber numberWithInt:123],
////                         @"Other_Info_2": @[@"obj1", @"obj2"],
////                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
//    [WeiboSDK sendRequest:request];
//}
//+ (WBMessageObject *)messageToShare
//{
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = NSLocalizedString(@"安生配合区苹果还排位哦几个号借我苹果键盘文件和高配!", nil);
//    return message;
//}
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
    NSLog(@"请求回调");
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSLog(@"请求失败");
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}



#pragma mark WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"didReceiveWeiboRequest = %@",request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        // 发送消息回调
        WeiboSDKResponseStatusCode statusCode = response.statusCode;
        if (statusCode == WeiboSDKResponseStatusCodeSuccess) {
            //分享成功
//            [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow labelText:@"分享成功" afterDelay:3];

        }
        else if (statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            // 取消发送
        }
        else if (statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
            // 授权失败
        }
        else {
            // 失败
        }
        if (self.publishContentResult) {
            self.publishContentResult (ShareTypeSinaWeibo,(statusCode == WeiboSDKResponseStatusCodeSuccess));
            self.publishContentResult = nil;
        }
       
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        // 认证登陆回调
        BOOL isSuccess = NO;
        BOOL isCaccel = NO;
        NSString *tipsString = @"";
        WeiboSDKResponseStatusCode statusCode = response.statusCode;
        if (statusCode == WeiboSDKResponseStatusCodeSuccess) {
            isSuccess = YES;
            WBAuthorizeResponse *authRes = (WBAuthorizeResponse *)response;
            self.user_sina_id = authRes.userID;
            self.access_token = authRes.accessToken;
            self.expiration_date = authRes.expirationDate;
            
            [self saveAuthData];
            
            tipsString = @"登录成功";
        }
        else if (statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            // 取消授权
            isCaccel = YES;
            tipsString = @"取消登录";
        }
        else {
            // 失败
            tipsString = UPLocalizedString(@"Login failed", nil);
        }
        if (self.authLoginResult) {
            self.authLoginResult (isSuccess , isCaccel, tipsString);
            self.authLoginResult = nil;
        }

    }

}





@end
