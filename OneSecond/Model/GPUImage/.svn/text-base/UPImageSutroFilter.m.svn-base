//
//  UPImageSutroFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageSutroFilter.h"
#import "GPUImagePicture.h"
#import "UPImageSutroBaseFilter.h"

@implementation UPImageSutroFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageSutroBaseFilter *lookupFilter = [[UPImageSutroBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"vignetteMap"];//blowout
    sImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [sImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [sImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"sutroMetal"];//overlay
    sImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [sImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [sImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"softLight"];//map
    sImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [sImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [sImagePicture3 processImage];
    
    UIImage *image4 = [UIImage imageNamed:@"sutroEdgeBurn"];//map
    sImagePicture4 = [[GPUImagePicture alloc] initWithImage:image4];
    [sImagePicture4 addTarget:lookupFilter atTextureLocation:4];
    [sImagePicture4 processImage];
    
    UIImage *image5 = [UIImage imageNamed:@"sutroCurves"];//map
    sImagePicture5 = [[GPUImagePicture alloc] initWithImage:image5];
    [sImagePicture5 addTarget:lookupFilter atTextureLocation:5];
    [sImagePicture5 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
