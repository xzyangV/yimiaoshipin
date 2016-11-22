//
//  RecordVideoClipsView.h
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RecordVideoClipsView;
@class VideoClipEditCell;
@class VideoClipCell;

@protocol RecordVideoClipsViewDelegate <NSObject>

- (void)recordVideoClipsView:(RecordVideoClipsView *)recordVideoClipView didSelectedEditCell:(VideoClipEditCell *)editCell;
- (void)recordVideoClipsView:(RecordVideoClipsView *)recordVideoClipView didSelectedVideoClipCell:(VideoClipCell *)videoClipCell;
- (void)recordVideoClipsView:(RecordVideoClipsView *)recordVideoClipView didSelectedVideoClipPlayCell:(VideoClipCell *)videoClipCell;

@end

@interface RecordVideoClipsView : UIView

@property (nonatomic, strong) NSArray *videoClips;
@property (nonatomic, weak) id <RecordVideoClipsViewDelegate> delegate;
@property (nonatomic, strong) VideoClipEditCell *editCell;

// 停止或开始视频片段的播放 （更改播放的状态）
- (void)changeVideoClipStateToPlay;
- (void)changeVideoClipStateToStop;
- (void)scroolToBottomAnimation:(BOOL)animation;
- (void)setUnableUseEditBtn;
- (void)setAbleUseEditBtn;
@end
