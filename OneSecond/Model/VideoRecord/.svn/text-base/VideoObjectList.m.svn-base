//
//  VideoObjectList.m
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoObjectList.h"
#import "VideoObject.h"
#import "VideoClipObject.h"

@implementation VideoObjectList


+ (instancetype)sharedVideoList
{
    static VideoObjectList *sharedVideoListInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVideoListInstance = [[VideoObjectList alloc] init];
        [sharedVideoListInstance loadFromFile:nil];
    });
    return sharedVideoListInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _persistentObjectClass = [VideoObject class];
    }
    return self;
}

- (VideoObject *)videoObjectWithVideoID:(NSString *)videoID
{
    if (videoID.length <= 0) { return nil;}
    
    VideoObject *tempVideo = nil;
    for (VideoObject *video in self.objectArray) {
        if ([video.videoId isEqualToString:videoID]) {
            tempVideo = video;
            break;
        }
    }
    return tempVideo;

}
- (void)saveVideoObject:(VideoObject *)videoObject
{
    if (!videoObject) {return;}
    
    if ([self isExistVideoObject:videoObject]) {
        if (videoObject.videoClips.count > 0) {
            [self updateVideObject:videoObject];
        }
        else{
            [self deleteVideoObject:videoObject];
        }
    }
    else{
        if (videoObject.videoClips.count > 0) {
            [self addVideoObject:videoObject];
        }
    }
}
- (BOOL)isExistVideoObject:(VideoObject *)videObject
{
    if (!videObject) {return NO;}
    
    for (VideoObject *video in self.objectArray) {
        if ([video.videoId isEqualToString:videObject.videoId]) {
            return YES;
        }
    }
    return NO;
}

- (void)addVideoObject:(VideoObject *)videoObject
{
    if (!videoObject) {return;}
    [videoObject updateLastModificationTime];
    [self.objectArray insertObject:videoObject atIndex:0];
    [self saveToFile:nil];
}

- (void)deleteVideoObject:(VideoObject *)videoObject
{
    if (!videoObject) {return;}
    
    VideoObject *readyDeleteVideo = nil;
    for (VideoObject *video in self.objectArray) {
        if (video.videoId.length > 0 && [video.videoId isEqualToString:videoObject.videoId]) {
            readyDeleteVideo = video;
            break;
        }
    }

    if (readyDeleteVideo) {
        // 删除对应的视频文件
        [readyDeleteVideo.videoClips.objectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[VideoClipObject class]]) {
                [readyDeleteVideo deleteVideoClipObject:obj];
            }
        }];
        [self.objectArray removeObject:readyDeleteVideo];
        [self saveToFile:nil];
    }
}

- (void)updateVideObject:(VideoObject *)videoObject
{
    if (!videoObject) {return;}
    
    VideoObject *readyUpdageVideo = nil;
    for (VideoObject *video in self.objectArray) {
        if (videoObject.videoId.length > 0 && [video.videoId isEqualToString:videoObject.videoId]) {
            readyUpdageVideo = video;
            break;
        }
    }
    
    if (readyUpdageVideo) {
        [videoObject updateLastModificationTime];
        NSInteger index = [self.objectArray indexOfObject:readyUpdageVideo];
        [self replaceObject:videoObject atIndex:index];
        [self saveToFile:nil];
    }
}
@end
