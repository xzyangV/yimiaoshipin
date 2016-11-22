//
//  UPImageAmaroFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/1.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageAmaroFilter.h"
#import "GPUImagePicture.h"
#import "UPImageAmaroBaseFilter.h"

@implementation UPImageAmaroFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageAmaroBaseFilter *lookupFilter = [[UPImageAmaroBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"blackboard1024"];//blowout
    aImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [aImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [aImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"overlayMap"];//overlay
    aImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [aImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [aImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"amaroMap"];//map
    aImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [aImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [aImagePicture3 processImage];

    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
