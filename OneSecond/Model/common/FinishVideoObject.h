//
//  FinishVideoObject.h
//  OneSecond
//
//  Created by uper on 16/5/20.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistentObject.h"
#import "VideoObject.h"


@interface FinishVideoObject : PersistentObject

@property (nonatomic, strong) NSString *videoId;                    // 视频ID
@property (nonatomic, strong) VideoClipObjectList *videoClips;      // 视频所包含的视频片段
@property (nonatomic, strong) NSString *videoName;                  // 视频名称
@property (nonatomic, strong) NSString *createTime;                 // 视频创建时间
@property (nonatomic, strong) NSString *lastModificationTime;       // 视频最后修改时间
@property (nonatomic, assign, readonly) NSInteger videoClipCount;

@property (nonatomic, strong) UIImage *videoThumbnailImage;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) NSString *videoLength;
@property (nonatomic,strong) VideoObject *videoObject;


+ (instancetype)newFinishVideo;
- (void)deleteVideoClipObject:(VideoClipObject *)videoClipObject;

//+ (instancetype)unFinishedVideoInstance;
- (void)deleteUnfinishedVideoInfo;
- (void)updateLastModificationTime;
- (NSString *)finishVideoFilePath;
- (BOOL)FinsishVideoIsExist;
- (NSString *)coverfinishVideoFilePath;
- (BOOL)coverFinsishVideoIsExist;
//获取完成视频的infoId 用于分享到uper
- (NSString *)getVideoInfoId;

@end
