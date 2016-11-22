//
//  UPImage1977Filter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImage1977Filter.h"
#import "GPUImagePicture.h"
#import "UPImage1977BaseFilter.h"

@implementation UPImage1977Filter
- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    // three input filter
    UPImage1977BaseFilter *lookupFilter = [[UPImage1977BaseFilter alloc] init];
    
    
    UIImage *image = [UIImage imageNamed:@"1977map"];
    qiqiImagePicture1 = [[GPUImagePicture alloc] initWithImage:image];
    [self addFilter:lookupFilter];
    
    [qiqiImagePicture1 addTarget:lookupFilter atTextureLocation:1];
    [qiqiImagePicture1 processImage];
    
    UIImage *image2 = [UIImage imageNamed:@"1977blowout"];
    qiqiImagePicture2 = [[GPUImagePicture alloc] initWithImage:image2];
    [qiqiImagePicture2 addTarget:lookupFilter atTextureLocation:2];
    [qiqiImagePicture2 processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
