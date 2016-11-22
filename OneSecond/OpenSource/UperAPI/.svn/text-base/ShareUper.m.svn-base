//
//  UperShare.m
//  OneSecond
//
//  Created by sup-mac03 on 16/6/6.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "ShareUper.h"
#import "UperAPI.h"
#import "UperAPIResponse.h"
#import "EventCounting.h"
@interface ShareUper ()<UperAPIDelegate>


@end

@implementation ShareUper

+ (instancetype)uperShareInstance
{
    static ShareUper *uperShareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uperShareInstance = [[ShareUper alloc] init];
    });
    return uperShareInstance;
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
    return [UperAPI handleOpenURL:url delegate:self];
}

- (void)onResp:(UperAPIResponse *)resp
{
    NSLog(@"success:%@ msg:%@",resp.success,resp.res_msg);
    if ([resp.success intValue] == 1) {
        [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow labelText:@"分享成功" afterDelay:2];
        [EventCounting countEvent:kShareToUper];
        [EventCounting countEvent:kTotalShareCount];
    }else{
        [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow labelText:@"分享失败" afterDelay:2];

    }

    
}
@end
