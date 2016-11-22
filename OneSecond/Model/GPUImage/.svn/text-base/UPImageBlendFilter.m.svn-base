//
//  UPImageBlendFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/25.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageBlendFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageHardLightBlendFilter.h"

@implementation UPImageBlendFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"sutroEdgeBurn"];
    bImagePicture = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageHardLightBlendFilter *lookupFilter = [[GPUImageHardLightBlendFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [bImagePicture addTarget:lookupFilter atTextureLocation:1];
    [bImagePicture processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}


@end
