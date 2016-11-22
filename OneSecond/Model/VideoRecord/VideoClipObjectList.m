//
//  VideoClipObjectList.m
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipObjectList.h"
#import "VideoClipObject.h"

@implementation VideoClipObjectList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _persistentObjectClass = [VideoClipObject class];
    }
    return self;
}

@end
