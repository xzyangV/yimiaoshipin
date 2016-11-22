//
//  RecordVideoClipPlayView.h
//  Up
//
//  Created by sup-mac03 on 16/4/8.
//  Copyright © 2016年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoClipObject;
@class RecordVideoClipPlayView;
@protocol RecordVideoClipPlayViewDelegate <NSObject>

- (void)recordVideoClipPlayViewDidSelectedDeleteAction:(RecordVideoClipPlayView *)videoClipPlayView;
- (void)recordVideoClipPlayViewDidSelectedSaveAction:(RecordVideoClipPlayView *)videoClipPlayView;
- (void)recordVideoClipPlayViewDidVideoItemReachEnd:(RecordVideoClipPlayView *)videoClipPlayView;

@end

@interface RecordVideoClipPlayView : UIView

@property (nonatomic, weak) id <RecordVideoClipPlayViewDelegate> delegate;
@property (nonatomic, strong) VideoClipObject *videoClipObject;
@property (nonatomic, assign) NSInteger videoClipIndex;
@property (nonatomic, assign, readonly) BOOL isPlaying;
/*
 *  @brief 播放视频片段
 *  @param videoURL:本地的视频地址
 */
- (void)playWithVideoFileURL:(NSString *)videoURL;
- (void)playWithVideoClipObject:(VideoClipObject *)videoClipObject videoClipIndex:(NSInteger)index;
- (void)hide;

@end
