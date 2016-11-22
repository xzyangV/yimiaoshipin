//
//  UploadVideoWithQiNiuObject.h
//  OneSecond
//
//  Created by uper on 16/5/19.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

typedef NS_ENUM(NSUInteger, SVUploadFileType) {
    SVUploadFileTypeVideo,
    SVUploadFileTypePhoto,
    svUploadFileTypeOther
};

typedef void (^SVUploadFileCompletedBlock) (BOOL isSuccess, NSURL *fileURL);
typedef void (^SVSetUploadServerResultCompletedBlock) (BOOL isSuccess, NSString *share_UrlStr,NSString *video_info_id);
typedef void (^SVUploadFileProgressBlock)(float percent);


@interface SVUploadFileManager : NSObject

//上传到七牛服务器
+ (void)uploadFileWithFileURL:(NSString *)filePath
                     fileType:(SVUploadFileType)fileType
                progressBlock:(SVUploadFileProgressBlock)progressBlock
               completedBlock:(SVUploadFileCompletedBlock)completedBlock;

//将从七牛获得的视频地址传到服务器
+ (void)setUploadServerResultWithFinishUrl:(NSString *)finishUrl
                              video_length:(float)video_length
                            main_image_url:(NSString *)main_image_url
                          main_image_width:(float)main_image_width
                         main_image_height:(float)main_image_height
                            completedBlock:(SVSetUploadServerResultCompletedBlock)completedBlock;

//取消上传
+ (void)cancelUploadFileWithFileURL:(NSString *)filePath
                     fileType:(SVUploadFileType)fileType;

@end
