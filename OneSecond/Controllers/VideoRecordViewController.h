//
//  VideoRecordViewController.h
//  OneSecond
//
//  Created by uper on 16/5/13.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SelectVideoCoverController.h"

@class VideoObject;
/**
 *	@brief	拍摄类型
 */
typedef enum
{
    RecordTypePhoto = 1, /**< 拍摄照片 */
    RecordTypeVideo = 2 /**< 录制视频 */
} RecordType;

@class VideoRecordViewController;
@class VideoObject;
@protocol RecordVideoControllerDelegate <NSObject>
@optional

- (void)recordVideoController:(VideoRecordViewController *)controller didFinishCapturePhotoWithInfo:(id)info;
- (void)recordVideoController:(VideoRecordViewController *)controller didFinishRecordWithURL:(NSURL *)URL thumbnail:(UIImage *)thumbnail videoID:(NSString *)videoID;
- (void)recordVideoControllerDidCancel:(VideoRecordViewController *)controller;
- (void)recordVideoControllerDidSelectPublishVideoLink:(VideoRecordViewController *)controller;

@end

@interface VideoRecordViewController : ParentViewController<SelectedVideoCover>

@property (nonatomic, weak) id<RecordVideoControllerDelegate> delegate;
@property (nonatomic, assign) RecordType recordType;
@property (nonatomic, strong) VideoObject *unFinishedVideo;

+ (NSString *)getRecordVideoFinishPath;
@end
