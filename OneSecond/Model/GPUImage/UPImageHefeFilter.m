//
//  UPImageHefeFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageHefeFilter.h"
#import "GPUImagePicture.h"
#import "UPImageHefeBaseFilter.h"

@implementation UPImageHefeFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageHefeBaseFilter *lookupFilter = [[UPImageHefeBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"edgeBurn"];//blowout
    hImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [hImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [hImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"hefeMap"];//overlay
    hImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [hImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [hImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"hefeGradientMap"];//map
    hImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [hImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [hImagePicture3 processImage];
    
    UIImage *image4 = [UIImage imageNamed:@"hefeSoftLight"];//map
    hImagePicture4 = [[GPUImagePicture alloc] initWithImage:image4];
    [hImagePicture4 addTarget:lookupFilter atTextureLocation:4];
    [hImagePicture4 processImage];
    
    UIImage *image5 = [UIImage imageNamed:@"hefeMetal"];//map
    hImagePicture5 = [[GPUImagePicture alloc] initWithImage:image5];
    [hImagePicture5 addTarget:lookupFilter atTextureLocation:5];
    [hImagePicture5 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}
@end
