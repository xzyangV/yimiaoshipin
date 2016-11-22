//
//  VideoObject.h
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "PersistentObject.h"
#import "VideoClipObjectList.h"
@class VideoClipObject;

@interface VideoObject : PersistentObject
@property (nonatomic, strong) NSString *videoId;                    // 视频ID
@property (nonatomic, strong) VideoClipObjectList *videoClips;      // 视频所包含的视频片段
@property (nonatomic, strong) NSString *videoName;                  // 视频名称
@property (nonatomic, strong) NSString *createTime;                 // 视频创建时间
@property (nonatomic, strong) NSString *lastModificationTime;       // 视频最后修改时间
@property (nonatomic, assign, readonly) NSInteger videoClipCount;
// 获取视频最后一帧的图片
- (UIImage *)imageFromLastFrame;
+ (instancetype)newVideo;
- (void)deleteVideoClipObject:(VideoClipObject *)videoClipObject;

+ (instancetype)unFinishedVideoInstance;
- (void)deleteUnfinishedVideoInfo;
- (void)updateLastModificationTime;
@end
