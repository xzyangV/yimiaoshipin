//
//  WelcomeObjectList.m
//  OneSecond
//
//  Created by uper on 16/5/19.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "WelcomeObjectList.h"

@implementation WelcomeObjectList


+ (instancetype)sharedWelcomeList
{
    static WelcomeObjectList *instanceWelcomeList = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instanceWelcomeList = [[ WelcomeObjectList alloc] init];
    });
    return instanceWelcomeList;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _persistentObjectClass = [WelcomeObject class];
    }
    return self;
}

- (void)buildDataWithPageNo:(int)pageNo object:(id)object
{
    
}
@end
