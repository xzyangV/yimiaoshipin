//
//  UPImageLomoFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageLomoFilter.h"
#import "GPUImagePicture.h"
#import "UPImageLomoBaseFilter.h"
@implementation UPImageLomoFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // three input filter
    UPImageLomoBaseFilter *lookupFilter = [[UPImageLomoBaseFilter alloc] init];
    
    
    UIImage *image = [UIImage imageNamed:@"lomoMap"];
    lImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [lImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [lImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"vignetteMap"];
    lImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [lImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [lImagePicture2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
