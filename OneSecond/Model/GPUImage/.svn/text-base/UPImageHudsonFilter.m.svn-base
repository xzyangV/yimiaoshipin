//
//  UPImageHudsonFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/2.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageHudsonFilter.h"
#import "GPUImagePicture.h"
#import "UPImageHudsonBaseFilter.h"

@implementation UPImageHudsonFilter


- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageHudsonBaseFilter *lookupFilter = [[UPImageHudsonBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"hudsonBackground"];//blowout
    hImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [hImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [hImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"overlayMap"];//overlay
    hImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [hImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [hImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"hudsonMap"];//map
    hImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [hImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [hImagePicture3 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
