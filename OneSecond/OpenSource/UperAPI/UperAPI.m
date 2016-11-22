//
//  UperAPI.m
//  OneSecond
//
//  Created by sup-mac03 on 16/6/6.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "UperAPI.h"
#import "UperAPIObject.h"
#import "UperAPIResponse.h"
#import <UIKit/UIKit.h>

@implementation UperAPI

+(BOOL) isUperAppInstalled
{
    NSURL *url = [NSURL URLWithString:@"upchina://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return YES;
    }
    return NO;
}

+ (BOOL) sendReq:(UperAPIObject *)object
{
    if (!object.v_id || !object.v_u || !object.i_u || !object.v_l) {
        return NO;
    }

    NSString *openURLStr = [NSString stringWithFormat:@"upchina://share?type=video&v_i=%@&v_u=%@&i_u=%@&s_u=uper10000&v_l=%@",object.v_id,object.v_u,object.i_u,object.v_l];
    NSURL *openURL = [NSURL URLWithString:openURLStr];
    if ([[UIApplication sharedApplication] canOpenURL:openURL]) {
        [[UIApplication sharedApplication] openURL:openURL];
        return YES;
    }
    return NO;
}

+(BOOL) handleOpenURL:(NSURL *) url delegate:(id<UperAPIDelegate>) delegate
{
    NSString *urlString = [[NSString stringWithFormat:@"%@",url] lowercaseString];
    NSString *openPrefixString = [[NSString stringWithFormat:@"uper10000://share?"] lowercaseString];
    if ([urlString hasPrefix:openPrefixString]) {
        NSDictionary *paramDic = [PublicObject splitQuery:url.query];

        UperAPIResponse *resp = [[UperAPIResponse alloc] init];
        resp.success = [paramDic objectForKey:@"success"];
        resp.res_msg = [paramDic objectForKey:@"res_msg"];
        if (delegate && [delegate respondsToSelector:@selector(onResp:)]) {
            [delegate onResp:resp];
        }
        return YES;
    }
    return NO;
}
@end
