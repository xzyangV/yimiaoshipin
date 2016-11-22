//
//  UPCounting.m
//  Up
//
//  Created by sup-mac03 on 14-9-26.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "EventCounting.h"
#import "TalkingData.h"
#import "ConfigureObject.h"

@implementation EventCounting

+ (void)startCounting
{
    if (kIsTestEnvironment) {
        return;
    }
    [TalkingData setLogEnabled:NO];
    [TalkingData sessionStarted:@"029CEC594B3D7BCC563E7AA4C43FD99B" withChannelId:[PublicObject upAppChannelId]];
}


+ (void)countEvent:(NSString *)eventName
{
    if (kIsTestEnvironment) {return;}

    [TalkingData trackEvent:eventName];
}

+ (void)countEvent:(NSString *)eventName label:(NSString *)labelName
{
    if (kIsTestEnvironment) {
        return;
    }
    if ([PublicObject isEmpty:eventName]) {
        return;
    }
    [TalkingData trackEvent:eventName label:labelName];
}

+ (void)countEvent:(NSString *)eventName label:(NSString *)labelName parameters:(NSDictionary *)parameters
{
    if (kIsTestEnvironment) {return;}
    [TalkingData trackEvent:eventName label:labelName parameters:parameters];
}

+ (void)countPageBegin:(NSString *)eventName
{
    if (kIsTestEnvironment) {return;}
    [TalkingData trackPageBegin:eventName];
}


+ (void)countPageEnd:(NSString *)eventName
{
    if (kIsTestEnvironment) {return;}
    [TalkingData trackPageEnd:eventName];
}


@end
