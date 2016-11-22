//
//  UPImageRiseFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/2.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageRiseFilter.h"
#include "UPImageRiseBaseFilter.h"
#include "GPUImagePicture.h"

@implementation UPImageRiseFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageRiseBaseFilter *lookupFilter = [[UPImageRiseBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"blackboard1024"];//blowout
    rImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [rImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [rImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"overlayMap"];//overlay
    rImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [rImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [rImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"riseMap"];//map
    rImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [rImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [rImagePicture3 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
