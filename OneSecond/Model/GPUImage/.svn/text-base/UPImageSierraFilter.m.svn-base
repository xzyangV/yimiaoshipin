//
//  UPImageSierraFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/2.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageSierraFilter.h"
#import "UPImageSierraBaseFilter.h"
#import "GPUImagePicture.h"

@implementation UPImageSierraFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageSierraBaseFilter *lookupFilter = [[UPImageSierraBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"sierraVignette"];//blowout
    sImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [sImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [sImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"overlayMap"];//overlay
    sImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [sImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [sImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"sierraMap"];//map
    sImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [sImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [sImagePicture3 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
