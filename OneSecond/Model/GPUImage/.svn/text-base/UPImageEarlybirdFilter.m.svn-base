//
//  UPImageEarlybirdFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageEarlybirdFilter.h"
#import "GPUImagePicture.h"
#import "UPImageEarlybirdBaseFilter.h"

@implementation UPImageEarlybirdFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageEarlybirdBaseFilter *lookupFilter = [[UPImageEarlybirdBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"earlyBirdCurves"];//blowout
    eImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [eImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [eImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"earlybirdOverlayMap"];//overlay
    eImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [eImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [eImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"vignetteMap"];//map
    eImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [eImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [eImagePicture3 processImage];
    
    UIImage *image4 = [UIImage imageNamed:@"earlybirdBlowout"];//map
    eImagePicture4 = [[GPUImagePicture alloc] initWithImage:image4];
    [eImagePicture4 addTarget:lookupFilter atTextureLocation:4];
    [eImagePicture4 processImage];

    UIImage *image5 = [UIImage imageNamed:@"earlybirdMap"];//map
    eImagePicture5 = [[GPUImagePicture alloc] initWithImage:image5];
    [eImagePicture5 addTarget:lookupFilter atTextureLocation:5];
    [eImagePicture5 processImage];

    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
