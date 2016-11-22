//
//  VideoClipCell.h
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VideoClipObject;

@interface VideoClipCell : UICollectionViewCell

+ (CGSize)defaultItemSize;
+ (CGSize)seletedItemSize;

@property (nonatomic, strong)VideoClipObject *videoClipObject;

// 隐藏视频片段的播放暂停按钮
- (void)hideVideoClipPlayControlView;

// 显示并将视频片段的播放状态改为开始
- (void)showAndchangeVideoClipPlayStateToBegin;

// 显示并将视频片段的播放状态改为暂停
- (void)showAndchangeVideoClipPlayStateToStop;
@end
