//
//  VideoClipCell.m
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipCell.h"
#import "VideoClipObject.h"

#define kImageVideoClipPlay [UIImage imageNamed:@"video_record_play"]
#define kImageVideoClipStop [UIImage imageNamed:@"video_record_pause"]

@interface VideoClipCell ()
{
    UIImageView *_videoThumbnail;
    UIImageView *_videClipPlayView;
}
@end

@implementation VideoClipCell

+ (CGSize)defaultItemSize
{
    return CGSizeMake(44, 44);
}

+ (CGSize)seletedItemSize
{
    return CGSizeMake(53, 53);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _videoThumbnail = [[UIImageView alloc] initWithFrame:self.bounds];
        _videoThumbnail.backgroundColor = [UIColor clearColor];
        [self addSubview:_videoThumbnail];
        
        _videClipPlayView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videClipPlayView.backgroundColor = [UIColor clearColor];
        _videClipPlayView.hidden = YES;
        [self addSubview:_videClipPlayView];

    }
    return self;
}

- (void)setVideoClipObject:(VideoClipObject *)videoClipObject
{
    if (_videoClipObject != videoClipObject) {
        _videoClipObject = videoClipObject;
    }
    [self updateUI];
}

- (void)updateUI
{
    _videClipPlayView.frame = CGRectMake((self.width - kImageVideoClipPlay.size.width) / 2.f, (self.height - kImageVideoClipPlay.size.height) / 2.f, kImageVideoClipPlay.size.width, kImageVideoClipPlay.size.height);
    
    _videoThumbnail.frame = self.bounds;
    if (self.videoClipObject.thumbnail) {
        _videoThumbnail.image = self.videoClipObject.thumbnail;
    }
    else{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            UIImage *image = [PublicObject videoThumbnailForLastFrame:NO withVideoUrl:self.videoClipObject.videoUrl];
//
//            self.videoClipObject.thumbnail = image;
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                _videoThumbnail.image = image;
//            });
//        });
        
        UIImage *image = [PublicObject videoThumbnailForLastFrame:NO withVideoUrl:self.videoClipObject.videoUrl];
        self.videoClipObject.thumbnail = image;
        _videoThumbnail.image = image;
        
        
    }
}

// 隐藏视频片段的播放暂停按钮
- (void)hideVideoClipPlayControlView
{
    _videClipPlayView.hidden = YES;
}

// 显示并将视频片段的播放状态改为开始
- (void)showAndchangeVideoClipPlayStateToBegin
{
    _videClipPlayView.hidden = NO;
    _videClipPlayView.image = kImageVideoClipPlay;
}

// 显示并将视频片段的播放状态改为暂停
- (void)showAndchangeVideoClipPlayStateToStop
{
    _videClipPlayView.hidden = NO;
    _videClipPlayView.image = kImageVideoClipStop;
}

@end
