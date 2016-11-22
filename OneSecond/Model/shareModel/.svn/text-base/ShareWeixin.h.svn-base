//
//  ShareWeixin.h
//  Up
//
//  Created by zhangyx on 13-4-27.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "ShareObject.h"
#import "WXApi.h"
#import "ShareEventHandlerDef.h"
@interface ShareWeixin : ShareObject

+ (ShareWeixin *)weixinInstance;

/**
 *	@brief	连接微信应用以使用相关功能
 *          http://open.weixin.qq.com并将相关信息填写到以下字段
 *
 *	@param 	appid 	应用id
 */
- (BOOL)connectWeixinWithAppID:(NSString *)appid;


/** @brief	微信认证登录
 *	@param 	controller  调用控制器
 *	@param 	result  登录事件回调
 */
//
//- (void)wechatAuthLogin:(UIViewController *)controller block:(GetUserInfoEventHandler)completedBlock;

/** @brief	分享到微信好友
 *	@param 	content  分享内容
 *	@param 	result  认证返回事件处理
 */
- (void)showSessionShareWithContent:(ShareContent *)content
                             result:(PublishContentEventHandler)result;

/** @brief	分享到微信朋友圈
 *	@param 	content  分享内容
 *	@param 	result  认证返回事件处理
 */
- (void)showTimeLineShareWithContent:(ShareContent *)content
                              result:(PublishContentEventHandler)result;

/** @brief  微信支付
 *	@param 	payObject   微信支付对象
 *	@param 	result      微信支付事件回调
 */
- (void)wechatPay:(PayReq *)payObject
           result:(SNSPayBlock)completedBlock;


- (BOOL)handleOpenUrl:(NSURL *)url;

@end
