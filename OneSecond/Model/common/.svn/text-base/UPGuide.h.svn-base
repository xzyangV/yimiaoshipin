//
//  UPGuide.h
//  Up
//
//  Created by amy on 14-3-18.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    UPGuideTypeSceondVideoPublish,            //一秒视频发布引导
    UPGuideTypeReadTextAfterburned,            //阅后即焚长按查看内容
    UPGuideTypeExitSecondVideoAndBeginRecord,            //退出一秒视频按钮提示和开始录制视频
    UPGuideTypeCreatMoreSecondVideo,            //创建多个一秒视频(所有草稿)
    UPGuideTypePreviewAndEditSecondVideo,            //预览和编辑一秒视频(下一步)
    UPGuideTypeSaveSecondVideo,            //保存一秒视频(保存)
    UPGuideTypeMoveSecondVideo,            //长按移动一秒视频(移动)
    UPGuideTypeNextLensSecondVideo,            //再按一下 录制下一个镜头
    UPGuideTypeShareSecondVideo,             //分享一秒视频
    UPGuideTypePreviewSecondVideo             //预览一秒视频

} UPGuideType;


@interface UPGuide : NSObject


+ (BOOL)whetherShowGuideWithType:(UPGuideType)guideType;
+ (void)showGuideWithType:(UPGuideType)guideType completed:(void(^)(void))block;
+ (void)showGuideWithType:(UPGuideType)guideType force:(BOOL)force completed:(void(^)(void))block;
+ (void)showGuideWithType:(UPGuideType)guideType force:(BOOL)force keyBoardHeight:(float)keyBoardHeight completed:(void(^)(void))block;
+ (void)setHaveSeenGuideWithType:(UPGuideType)guideType;
+ (void)showGuideWithType:(UPGuideType)guideType force:(BOOL)force forView:(UIView *)view completed:(void(^)(void))block;




+ (void)showGuideWithType:(UPGuideType)guideType WithCustomView:(UIView *)view  completed:(void(^)(void))block;
+ (void)showGuideWithType:(UPGuideType)guideType WithCustomView:(UIView *)view  force:(BOOL)force completed:(void(^)(void))block;


@end
