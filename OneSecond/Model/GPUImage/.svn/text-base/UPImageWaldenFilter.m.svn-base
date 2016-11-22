//
//  UPImageWaldenFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageWaldenFilter.h"
#import "GPUImagePicture.h"
#import "UPImageWaldenBaseFilter.h"

@implementation UPImageWaldenFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // three input filter
    UPImageWaldenBaseFilter *lookupFilter = [[UPImageWaldenBaseFilter alloc] init];
    
    
    UIImage *image = [UIImage imageNamed:@"waldenMap"];
    wImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [wImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [wImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"vignetteMap"];
    wImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [wImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [wImagePicture2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
