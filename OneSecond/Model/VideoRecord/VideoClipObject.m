//
//  VideoClipObject.m
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipObject.h"
#import "DBManager.h"

@implementation VideoClipObject

+ (instancetype)objectWithVideoUrl:(NSString *)videoUrl
{
    VideoClipObject *clipObject = [[VideoClipObject alloc] init];
    clipObject.videoUrl = videoUrl;
    return clipObject;
}

- (NSString *)formatVidioUrl
{
    NSString *urlString = [_videoUrl lastPathComponent];
    NSString *sss = [[DBManager getInstance] getCacheFolderPathWithFolderName:@"recordVideo"];
    return [sss stringByAppendingPathComponent:urlString];
}
@end
