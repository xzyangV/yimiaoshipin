//
//  UPImageToasterFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageToasterFilter.h"
#import "GPUImagePicture.h"
#import "UPImageToasterBaseFilter.h"

@implementation UPImageToasterFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageToasterBaseFilter *lookupFilter = [[UPImageToasterBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"toasterMetal"];//blowout
    tImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [tImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [tImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"toasterSoftLight"];//overlay
    tImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [tImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [tImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"toasterCurves"];//map
    tImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [tImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [tImagePicture3 processImage];
    
    UIImage *image4 = [UIImage imageNamed:@"toasterOverlayMapWarm"];//map
    tImagePicture4 = [[GPUImagePicture alloc] initWithImage:image4];
    [tImagePicture4 addTarget:lookupFilter atTextureLocation:4];
    [tImagePicture4 processImage];
    
    UIImage *image5 = [UIImage imageNamed:@"toasterColorShift"];//map
    tImagePicture5 = [[GPUImagePicture alloc] initWithImage:image5];
    [tImagePicture5 addTarget:lookupFilter atTextureLocation:5];
    [tImagePicture5 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
