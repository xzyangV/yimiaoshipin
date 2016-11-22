//
//  RecordVideoProgress.m
//  Up
//
//  Created by zhangyx on 13-8-14.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "RecordVideoProgress.h"
#import "RecordVideoDefine.h"

#define kProgressColor ColorForHex(0xf2e216)

@interface RecordVideoProgress()
{
    UIView *_progressView;
}


@end

@implementation RecordVideoProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _progressView.backgroundColor = kProgressColor;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self updateProgress];
}

- (void)updateProgress
{
    CGFloat progressWidth = self.width * (1 - self.progress);
    if (progressWidth <= 5.f) {
        progressWidth = 5.f;
    }
    _progressView.frame = CGRectMake((self.width - progressWidth) / 2.f, 0, progressWidth, self.height);
}

- (void)resetProgress
{
    self.progress = 0;
}
@end
