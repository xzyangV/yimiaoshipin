//
//  ShareFaceBook.h
//  Up
//
//  Created by zhangyx on 14/7/9.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ShareObject.h"

@interface ShareFaceBook : ShareObject


/**
 *	@param 	result  认证返回事件处理
 */

- (void)faceBookAuthLoginWithResult:(AuthLoginEventHandler)result;

/**
 *	@param 	result  获取用户信息返回事件处理
 */

- (void)getUserInfoWithResult:(GetUserInfoEventHandler)result;

/**
 *	@param 	content  分享内容
 *	@param 	result  认证返回事件处理
 */

- (void)showShareWithContent:(ShareContent *)content
                      result:(PublishContentEventHandler)result;

/**
 *	@brief	获取好友列表
 *	@param 	result                      返回事件处理
 */

- (void)getFriendListResult:(GetFriendList)result;



+ (ShareFaceBook *)shareToFBInstance;

- (BOOL)isAuthLoginResult;

//- (ShareUserInfo *)cacheUserInfo;

- (void)logOut;

@end
