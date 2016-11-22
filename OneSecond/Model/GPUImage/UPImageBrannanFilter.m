//
//  UPImageBrannanFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageBrannanFilter.h"
#import "GPUImagePicture.h"
#import "UPImageBrannanBaseFilter.h"

@implementation UPImageBrannanFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // four input filter
    UPImageBrannanBaseFilter *lookupFilter = [[UPImageBrannanBaseFilter alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"brannanProcess"];//blowout
    bImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [bImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [bImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"brannanBlowout"];//overlay
    bImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [bImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [bImagePicture2 processImage];
    
    UIImage *image3 = [UIImage imageNamed:@"brannanContrast"];//map
    bImagePicture3 = [[GPUImagePicture alloc] initWithImage:image3];
    [bImagePicture3 addTarget:lookupFilter atTextureLocation:3];
    [bImagePicture3 processImage];
    
    UIImage *image4 = [UIImage imageNamed:@"brannanLuma"];//map
    bImagePicture4 = [[GPUImagePicture alloc] initWithImage:image4];
    [bImagePicture4 addTarget:lookupFilter atTextureLocation:4];
    [bImagePicture4 processImage];
    
    UIImage *image5 = [UIImage imageNamed:@"brannanScreen"];//map
    bImagePicture5 = [[GPUImagePicture alloc] initWithImage:image5];
    [bImagePicture5 addTarget:lookupFilter atTextureLocation:5];
    [bImagePicture5 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}
@end
