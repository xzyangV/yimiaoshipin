//
//  VideoProgressView.m
//  Up
//
//  Created by zhangyx on 13-7-19.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "VideoProgressView.h"

#define kProgressValueLabelColor [UIColor whiteColor]

//static BOOL VideoProgressViewExists = NO;


@interface VideoProgressView () {
    
    UIImageView *_animationArticleView;
    UILabel *_progressLabel;
    
    __block double _imageviewAngle;
    __block BOOL _isRun;
}
@property (nonatomic,strong) NSTimer *animationTimer;
@end

@implementation VideoProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        VideoProgressViewExists = YES;
        _isRun = NO;
        
        _animationArticleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_animationArticleView];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [PublicObject fontWithSize:15.0 fontName:@"" isBold:YES];
        _progressLabel.textColor = kProgressValueLabelColor;
        
        [self addSubview:_progressLabel];
        // 初始值为0
//        [self setProgressValue:0];
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"VideoProgressView dealloc");
    [self stopAnimate];
}

- (void)setActiveImage:(UIImage *)activeImage
{
    _animationArticleView.image = activeImage;
}

- (void)setProgressValue:(double)progressValue
{
    if (_progressValue != progressValue) {
        _progressValue = progressValue;
    }
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%", (progressValue * 100)];
}

- (BOOL)isLoading
{
    return _isRun;
}

- (void)beginAnimate
{
//    if (_progressValue >= 1) {
//        [self stopAnimate];
//        return;
//    }
    self.hidden = NO;
    _isRun = YES;
    if (self.animationTimer) {
        [self.animationTimer invalidate];
    }
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                           target:self
                                                         selector:@selector(startCycleCall)
                                                         userInfo:nil repeats:YES];
//    [self startCycleCall];
}

- (void)stopAnimate
{
    if (self.animationTimer) {
        [self.animationTimer invalidate];
    }
    _isRun = NO;
    _progressLabel.text = @"";
    _progressValue = 0;
    self.hidden = YES;
}

- (void)startCycleCall
{
//    NSLog(@"startCycleCall");
    if (!_isRun) {
        if (self.animationTimer) {
            [self.animationTimer invalidate];
        }
        return;
    }
    __weak VideoProgressView *bself = self;
    CGAffineTransform endAngle = CGAffineTransformRotate(_animationArticleView.transform, M_PI/2);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        if (!AnimationisStop) {
            VideoProgressView *tSelf = bself;
            tSelf->_animationArticleView.transform = endAngle;
//        }
    } completion:^(BOOL finished) {
//        VideoProgressView *tSelf = bself;
//        NSLog(@"结束动画isRun=%d,AnimationisStop =%d",tSelf->_isRun,AnimationisStop);
//        if (tSelf->_isRun && !AnimationisStop) {
//            tSelf->_imageviewAngle += 10;
//            [bself startCycleCall];
//        }
    }];
}

@end
