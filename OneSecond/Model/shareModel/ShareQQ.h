//
//  ShareQQ.h
//  Up
//
//  Created by zhangyx on 13-4-27.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "ShareObject.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ShareQQ : ShareObject

+ (ShareQQ *)QQInstance;

/**
 *	@brief	连接QQ应用以使用相关功能
 *          http://mobile.qq.com/api/并将相关信息填写到以下字段
 *
 *	@param 	appid 	应用id
 */
- (void)connectQQWithAppID:(NSString *)appid;

/**
 *	@param 	content  分享内容
 *	@param 	result  认证返回事件处理
 */
- (void)showShareWithContent:(ShareContent *)content
                   shareType:(ShareType)shareType
                      result:(PublishContentEventHandler)result;


/**
 *	@param 	result  应用回调url
 */

- (BOOL)handleOpenUrl:(NSURL *)url;


@end
