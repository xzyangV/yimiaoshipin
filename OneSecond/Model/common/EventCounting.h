//
//  UPCounting.h
//  Up
//
//  Created by sup-mac03 on 14-9-26.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>


/* 分享到第三方名称定义 */
static NSString *kShareToWeiXinHY = @"WeChatFriend";

@interface EventCounting : NSObject

//统计开始，包括统计前的一些设置
+ (void)startCounting;

//统计自定义事件（可选)
+ (void)countEvent:(NSString *)eventName;
//计带标签的自定义事件（可选），可用标签来区别同一个事件的不同应用场景
//@param  labelKey    标签key (自定义) labelkey只用来在flurry统计时用上
+ (void)countEvent:(NSString *)eventName label:(NSString *)labelName;

//统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
+ (void)countEvent:(NSString *)eventName label:(NSString *)labelName parameters:(NSDictionary *)parameters;

//开始跟踪某一页面（可选），记录页面打开时间
+ (void)countPageBegin:(NSString *)eventName;

//结束某一页面的跟踪（可选），记录页面的关闭时间
+ (void)countPageEnd:(NSString *)eventName;

//+ (void)

@end
