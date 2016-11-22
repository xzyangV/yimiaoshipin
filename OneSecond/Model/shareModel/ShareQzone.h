//
//  ShareQzone.h
//  TestShareDemo
//
//  Created by zhangyx on 13-4-19.
//  Copyright (c) 2013年 zhangyx. All rights reserved.
//

#import "ShareObject.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>

@interface ShareQzone : ShareObject  {
    
}
@property (nonatomic,strong) TencentOAuth *tencentOAuth;


/**
 *	@brief	连接QQ空间应用以使用相关功能
 *          http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
 *
 *	@param 	appId 	应用id
 *
 */
- (void)connectQZoneWithAppKey:(NSString *)appId;


+ (BOOL)isSupportIphoneSSOLogin;


/**
 *	@param 	result  认证返回事件处理
 */
- (void)qzoneAuthLoginWithResult:(AuthLoginEventHandler)result;

/**
 *	@param 	result  获取用户信息返回事件处理
 */
- (void)getUserInfoWithresult:(GetUserInfoEventHandler)result;


/**
 *	@param 	content  分享内容
 *	@param 	result  认证返回事件处理
 */
- (void)showShareWithContent:(ShareContent *)content
                      result:(PublishContentEventHandler)result;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)onClickLogout;

+ (ShareQzone *)qzoneInstance;

@end
