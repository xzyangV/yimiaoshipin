//
//  ShareWeiboObject.h
//  OneSecond
//
//  Created by uper on 16/5/13.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareEventHandlerDef.h"
#import "ShareContent.h"
@interface ShareWeiboObject : NSObject

+ (ShareWeiboObject *)ShareWeiboObjectInstance;

// 注册
- (void)connectSinaWeiboWithAppKey:(NSString *)appKey;




//+ (void)shareWeiboWithObject:(NSObject*)object;

/**
 *	@param 	result  认证返回事件处理
 */
- (void)newSinaAuthLogiResult:(AuthLoginEventHandler)result;

/**
 *	@param 	content  分享内容
 *	@param 	result  认证返回事件处理
 */
- (void)showNSinaShareWithContent:(ShareContent *)content
                           result:(PublishContentEventHandler)result;
- (BOOL)newSinahandleOpenUrl:(NSURL *)url;
@end
