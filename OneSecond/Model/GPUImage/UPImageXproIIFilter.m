//
//  UPImageXproIIFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageXproIIFilter.h"
#import "GPUImagePicture.h"
#import "UPImageXproIIBaseFilter.h"

@implementation UPImageXproIIFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // three input filter
    UPImageXproIIBaseFilter *lookupFilter = [[UPImageXproIIBaseFilter alloc] init];

    UIImage *image = [UIImage imageNamed:@"xproMap"];
    xImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [xImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [xImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"vignetteMap"];
    xImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [xImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [xImagePicture2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
