//
//  RecordVideoClipPlayView.m
//  Up
//
//  Created by sup-mac03 on 16/4/8.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "RecordVideoClipPlayView.h"

//#import "VideoProgressView.h"
//#import "DownLoadVideo.h"
//#import "SpotNewsBrowseCount.h"
//#import "SpotNewsObject.h"
//#import "MagazineObject.h"
#import "VideoClipObject.h"

#import "DBManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


#define kVideoPlayStatus @"status"

#define kDeleteBtnImg [UIImage imageNamed:@"video_record_delete"]
#define kSaveBtnImg [UIImage imageNamed:@"video_record_continiu"]

@interface RecordVideoClipPlayView () {
    UIButton *_deleteBtn;
    UIButton *_saveBtn;
    UILabel *_timeLabel;
}

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation RecordVideoClipPlayView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];
        
        CGFloat titleLabelHeight = 20;
        CGFloat titleLabelWidth = 40;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, titleLabelWidth, titleLabelHeight)];
        _timeLabel.clipsToBounds = YES;
        _timeLabel.backgroundColor = ColorForHexAlpha(0x000000, 0.4);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = ColorForHex(0xf2f2f2);
        _timeLabel.layer.cornerRadius = 4.f;
        [self addSubview:_timeLabel];

        // 删除按钮与继续了录制按钮之间的距离
        CGFloat btnSpace = 100;
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake((self.width - (kDeleteBtnImg.size.width + kSaveBtnImg.size.width + btnSpace)) / 2.f, (self.height - kDeleteBtnImg.size.height) / 2.f, kDeleteBtnImg.size.width, kDeleteBtnImg.size.height + 20);
        [_deleteBtn setImage:kDeleteBtnImg forState:UIControlStateNormal];
        [_deleteBtn setTitle:SVLocalizedString(@"delete", nil) forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        CGSize deleteImageSize = _deleteBtn.imageView.frame.size;
        CGSize deleteTitleSize = _deleteBtn.titleLabel.frame.size;
        CGFloat totalHeight = (deleteImageSize.height + deleteTitleSize.height + 5);
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - deleteImageSize.height), 0.0, 0.0, - deleteTitleSize.width);
        _deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - deleteImageSize.width, - (totalHeight - deleteTitleSize.height), 0.0);
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(_deleteBtn.right + btnSpace, _deleteBtn.top, kSaveBtnImg.size.width, kSaveBtnImg.size.height + 20);
        [_saveBtn setImage:kSaveBtnImg forState:UIControlStateNormal];
        [_saveBtn setTitle:SVLocalizedString(@"continiu record", nil) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
        CGSize saveImageSize = _saveBtn.imageView.frame.size;
        CGSize saveTitleSize = _saveBtn.titleLabel.frame.size;
        CGFloat saveTotalHeight = (saveImageSize.height + saveTitleSize.height + 5);
        _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(- (saveTotalHeight - saveImageSize.height), 0.0, 0.0, - saveTitleSize.width);
        _saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - saveImageSize.width, - (saveTotalHeight - saveTitleSize.height), 0.0);

        [self hideVideoClipControl];
    }
    return self;
}

- (void)dealloc
{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removePlayerObserver];
}

- (BOOL)isPlaying
{
    if (!self.hidden && self.player && self.player.rate == 1) {
        return YES;
    }
    return NO;
}

#pragma mark build subview

- (void)playWithVideoClipObject:(VideoClipObject *)videoClipObject videoClipIndex:(NSInteger)index
{
    self.videoClipObject = videoClipObject;
    self.videoClipIndex = index;
    [self playWithVideoFileURL:self.videoClipObject.videoUrl];
    [self updateTimeLabel];
}

- (void)playWithVideoFileURL:(NSString *)videoURL
{
    [self show];
    [self hideVideoClipControl];
    
    // 播放器
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:videoURL]];
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    [self removePlayerObserver];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addPlayerObserver];

    // 创建播放器的layer
    if (!self.playerLayer) {
        self.playerLayer = [[AVPlayerLayer alloc] init];
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.playerLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.playerLayer];
        self.playerLayer.hidden = NO;
    }
    
    // 将播放器挂在layer上显示
    self.playerLayer.player = self.player;
    
    [self.player play];
}

#pragma mark- Private Method

- (void)updateTimeLabel
{
    NSString *aTime = [NSString stringWithFormat:@"%lu秒",(unsigned long)self.videoClipIndex + 1];
    _timeLabel.text = aTime;
    [self bringSubviewToFront:_timeLabel];

}
- (void)hide
{
    [self.player pause];
    [self removePlayerObserver];
    self.hidden = YES;
    [self hideVideoClipControl];
}

- (void)show
{
    self.hidden = NO;
}

- (void)showVideoClipControl
{
    [self bringSubviewToFront:_deleteBtn];
    [self bringSubviewToFront:_saveBtn];
    _deleteBtn.hidden = NO;
    _saveBtn.hidden = NO;
}

- (void)hideVideoClipControl
{
    _deleteBtn.hidden = YES;
    _saveBtn.hidden = YES;
}

- (void)addPlayerObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidFailedReachEnd:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:[self.player currentItem]];
//    [self.player.currentItem addObserver:self forKeyPath:kVideoPlayStatus options:0 context:nil];
}
- (void)removePlayerObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:[self.player currentItem]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemPlaybackStalledNotification
                                                  object:[self.player currentItem]];
//    [self.player.currentItem removeObserver:self forKeyPath:kVideoPlayStatus];
}


#pragma mark- btnAction

- (void)deleteBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoClipPlayViewDidSelectedDeleteAction:)]) {
        [self.delegate recordVideoClipPlayViewDidSelectedDeleteAction:self];
    }
    [self hide];
}

- (void)saveBtnClicked:(id)sender
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoClipPlayViewDidSelectedSaveAction:recordVideoClipPlayViewDidSelectedSaveAction:)]) {
//        [self.delegate recordVideoClipPlayViewDidSelectedSaveAction:self];
//    }
    [self hide];
}

#pragma mark NSNotification

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoClipPlayViewDidVideoItemReachEnd:)]) {
        [self.delegate recordVideoClipPlayViewDidVideoItemReachEnd:self];
    }
    [self showVideoClipControl];
}

- (void)playerItemDidFailedReachEnd:(NSNotification *)notification
{
    [self showVideoClipControl];
}

- (void)appDidEnterBackground:(NSNotification *)notification
{
    [self.player pause];
}


@end
