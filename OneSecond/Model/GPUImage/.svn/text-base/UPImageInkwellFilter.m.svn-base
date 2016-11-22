//
//  UPImageInkwellFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageInkwellFilter.h"
#import "GPUImagePicture.h"
#import "UPImageInkwellBaseFilter.h"

@implementation UPImageInkwellFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"inkwellMap"];
    inkImageSource = [[GPUImagePicture alloc] initWithImage:image];
    UPImageInkwellBaseFilter *lookupFilter = [[UPImageInkwellBaseFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [inkImageSource addTarget:lookupFilter atTextureLocation:1];
    [inkImageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
