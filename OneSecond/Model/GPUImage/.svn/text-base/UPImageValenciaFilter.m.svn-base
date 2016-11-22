//
//  UPImageValenciaFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageValenciaFilter.h"
#import "GPUImagePicture.h"
#import "UPImageValenciaBaseFilter.h"

@implementation UPImageValenciaFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // three input filter
    UPImageValenciaBaseFilter *lookupFilter = [[UPImageValenciaBaseFilter alloc] init];
    
    
    UIImage *image = [UIImage imageNamed:@"valenciaMap"];
    vImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [vImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [vImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"valenciaGradientMap"];
    vImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [vImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [vImagePicture2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
