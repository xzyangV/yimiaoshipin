//
//  UPImageNashvilleFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageNashvilleFilter.h"
#import "GPUImagePicture.h"
#import "UPImageNashvilleBaseFilter.h"

@implementation UPImageNashvilleFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"nashvilleMap"];
    nasImageSource = [[GPUImagePicture alloc] initWithImage:image];
    UPImageNashvilleBaseFilter *lookupFilter = [[UPImageNashvilleBaseFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [nasImageSource addTarget:lookupFilter atTextureLocation:1];
    [nasImageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
