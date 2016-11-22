//
//  UPImageKelvinFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageKelvinFilter.h"
#import "GPUImagePicture.h"
#import "UPImageKelvinBaseFilter.h"

@implementation UPImageKelvinFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"kelvinMap"];
    kelvinImageSource = [[GPUImagePicture alloc] initWithImage:image];
    UPImageKelvinBaseFilter *lookupFilter = [[UPImageKelvinBaseFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [kelvinImageSource addTarget:lookupFilter atTextureLocation:1];
    [kelvinImageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
