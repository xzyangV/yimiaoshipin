//
//  FinishVideoObject.m
//  OneSecond
//
//  Created by uper on 16/5/20.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "FinishVideoObject.h"
#import "VideoClipObject.h"
//#import "UserObject.h"
#import "DBManager.h"
#import "VideoObjectList.h"
#import "UIImage+Blur.h"

#define kVideoFormat @"yyyy.MM.dd"

@implementation FinishVideoObject

- (NSInteger)videoClipCount
{
    return self.videoClips.count;
}

- (void)deleteUnfinishedVideoInfo
{
    self.videoId = nil;
    self.videoClips = nil;
    self.videoName = nil;
}

+ (instancetype)newFinishVideo
{
    FinishVideoObject *video = [[FinishVideoObject alloc] init];
    video.videoId = [PublicObject generateNoLineUUID];
    video.videoName = [[NSDate date] stringWithFormat:kVideoFormat];
    video.createTime = [[NSDate date] stringWithFormat:kVideoFormat];
    video.lastModificationTime = [[NSDate date] dateString];
    video.videoClips = [[VideoClipObjectList alloc] init];
    return video;
}
- (void)deleteVideoClipObject:(VideoClipObject *)videoClipObject
{
    
}

- (void)deleteFileWithPath:(NSString *)filePath
{
    [[DBManager getInstance] deleteWithFilePath:filePath];
}

- (void)updateLastModificationTime
{
    self.lastModificationTime = [[NSDate date] stringWithFormat:kVideoFormat];
    
}

- (NSString *)finishVideoFilePath
{
    NSString *finsishVideoDor = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"oneFinishVideo"];
    BOOL finishPathIsExist =  [[NSFileManager defaultManager] fileExistsAtPath:finsishVideoDor];
    if (!finishPathIsExist) {
        NSError *err;
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:finsishVideoDor withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
    }
    NSString *finishVideoFile = [finsishVideoDor stringByAppendingPathComponent:[self.videoURL lastPathComponent]];
    
    return finishVideoFile;
    
}

- (BOOL)FinsishVideoIsExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self finishVideoFilePath]];
}

- (NSString *)coverfinishVideoFilePath
{
    NSString *finsishVideoDor = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"coverFinishVideo"];
    BOOL finishPathIsExist =  [[NSFileManager defaultManager] fileExistsAtPath:finsishVideoDor];
    if (!finishPathIsExist) {
        NSError *err;
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:finsishVideoDor withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
    }
    NSString *finishVideoFile = [finsishVideoDor stringByAppendingPathComponent:[self.videoURL lastPathComponent]];
    
    return finishVideoFile;
}

- (BOOL)coverFinsishVideoIsExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self coverfinishVideoFilePath]];
}

- (NSString *)getVideoInfoId
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *info_id = [NSString stringWithFormat:@"%@_video_info_id",self.videoURL.lastPathComponent];
    NSString *video_info_id = [user objectForKey:info_id];
    return video_info_id;
}


@end
