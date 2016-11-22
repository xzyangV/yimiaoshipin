//
//  ShareObject.h
//  OneSecond
//
//  Created by uper on 16/5/13.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareEventHandlerDef.h"
#import "ShareContent.h"
@interface ShareObject : NSObject


/**
 *	@param 	appKey  应用Key
 *	@param 	appSecret  应用密钥
 *	@param 	redirectUri  回调地址
 *	@param 	shareType      平台类型
 */
+ (BOOL)initializePlatWithAppKey:(NSString *)appKey
                       appSecret:(NSString *)appSecret
                     redirectUri:(NSString *)redirectUri
                       shareType:(ShareType)shareType
               andRootController:(UIViewController *)rootController;

+ (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication shareType:(ShareType)shareType;
+ (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

+ (BOOL)isCanShareToSnsWithType:(ShareType)shareType;

+ (BOOL)isSupportSSOLogin:(ShareType)shareType;
/**
 *	@brief	是否认证登录
 *
 *	@param 	shareType 	平台类型
 */
+ (BOOL)isAuthResultWithType:(ShareType)shareType;


+ (void)authLoginWithType:(ShareType)shareType
                   result:(AuthLoginEventHandler)authLoginResult;

+ (void)authLoginWithType:(ShareType)shareType
           viewController:(UIViewController *)controller
                   result:(AuthLoginEventHandler)authLoginResult;

/**
 *
 *	@param 	type 	平台类型
 *	@param 	content 	分享内容
 *	@param 	result 	分享返回事件处理
 */
+ (void)showShareWithType:(ShareType)shareType
                  content:(ShareContent *)content
                   result:(PublishContentEventHandler)result;


/**
 *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
 *
 *	@param 	content
 *	@param 	image
 *	@param 	title
 *	@param 	url
 *	@param 	description
 *	@param 	mediaType
 *
 *	@return	分享内容对象
 */

+ (ShareContent *)content:(NSString *)content
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                imagePath:(NSString *)imagepath
           thumbimagePath:(NSString *)thumbImagePath
                mediaType:(PublishContentMediaType)mediaType;


// 创建分享内容
+ (ShareContent *)content:(NSString *)content
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                    image:(UIImage *)image
               thumbimage:(UIImage *)thumbImage
                mediaType:(PublishContentMediaType)mediaType;

+ (ShareContent *)content:(NSString *)content
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                imageData:(NSData *)imageData
           thumbimageData:(NSData *)thumbImageData
                mediaType:(PublishContentMediaType)mediaType;

@end
