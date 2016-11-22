//
//  UserInfo.m
//  TestShareDemo
//
//  Created by EdwardShao on 4/20/13.
//  Copyright (c) 2013 zhangyx. All rights reserved.
//

#import "ShareUserInfo.h"

@implementation ShareUserInfo

+ (NSArray *)getPostParameterSnsUserList:(NSArray *)snsUserList
{
    NSMutableArray *userList = [NSMutableArray array];
    for (ShareUserInfo *shareUser in snsUserList) {
        
        NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc] init];
        [parameterDic setObject:shareUser.uid forKey:@"rmd_id"];
        if ([PublicObject isEmpty:shareUser.nickname]) {
            shareUser.nickname = @"";
        }
        [parameterDic setObject:shareUser.nickname forKey:@"name"];

        [userList addObject:parameterDic];
    }
    return userList;
}


@end
