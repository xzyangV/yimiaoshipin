//
//  VideoClipEditDragCell.m
//  Up
//
//  Created by sup-mac03 on 16/4/12.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipEditDragCell.h"
#import "VideoClipObject.h"

#define kDeleteImg [UIImage imageNamed:@"video_record_edit_delete"]

@interface VideoClipEditDragCell ()
{
    UIImageView *_videoThumbImgView;
    UIButton *_deleteBtn;
    
}
@end


@implementation VideoClipEditDragCell

+ (CGFloat)defaultSize
{
    return 60 + kDeleteImg.size.width / 2.5f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = ColorForHex(0x777777);

        CGFloat iconSize = 60;
        _videoThumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeleteImg.size.width / 2.5f, kDeleteImg.size.height / 2.5f, iconSize, iconSize)];
        _videoThumbImgView.backgroundColor = ColorForHex(0x777777);
        _videoThumbImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_videoThumbImgView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(0, 0, kDeleteImg.size.width, kDeleteImg.size.height);
        [_deleteBtn setImage:kDeleteImg forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)setVideoClipObject:(VideoClipObject *)videoClipObject
{
    if (_videoClipObject != videoClipObject) {
        _videoClipObject = videoClipObject;
    }
    if (_videoClipObject.thumbnail) {
        _videoThumbImgView.image = _videoClipObject.thumbnail;
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [PublicObject videoThumbnailForLastFrame:NO withVideoUrl:_videoClipObject.videoUrl];
            _videoClipObject.thumbnail = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                _videoThumbImgView.image = image;
            });
        });
    }
}

- (void)deleteBtnClicked:(id)sender
{
    if (self.deleteBlock) {
        self.deleteBlock(self.videoClipObject);
    }
}
@end
