//
//  VideoClipObject.h
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "PersistentObject.h"

@interface VideoClipObject : PersistentObject

@property (nonatomic, getter = formatVidioUrl, strong) NSString *videoUrl;
@property (nonatomic, strong) UIImage *thumbnail;


+ (instancetype)objectWithVideoUrl:(NSString *)videoUrl;

@end
