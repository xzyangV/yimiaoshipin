//
//  UPImageMonoFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/31.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageMonoFilter.h"
#import "GPUImageMonochromeFilter.h"
#import "GPUImageVignetteFilter.h"

@implementation UPImageMonoFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    GPUImageVignetteFilter *filter0 = [[GPUImageVignetteFilter alloc] init];
    [filter0 setVignetteEnd:0.75];
    [self addFilter:filter0];
    
    GPUImageMonochromeFilter *filter1 = [[GPUImageMonochromeFilter alloc] init];
    [self addFilter:filter1];
    [filter0 addTarget:filter1];
    
    [self setInitialFilters:[NSArray arrayWithObjects:filter0, nil]];
    [self setTerminalFilter:filter1];

    return self;
}


@end
