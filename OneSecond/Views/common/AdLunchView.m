//
//  AdLunchView.m
//  OneSecond
//
//  Created by uper on 16/5/27.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "AdLunchView.h"
#import "AppDelegate.h"
#import "UpWebViewController.h"
#import "UIImage+GIF.h"

@interface AdLunchView ()
{
    UIImageView *_launchView;
    BOOL _isClose;
    UIButton *_passButton;
    UIButton *_clelrPassButton;
}
@end
@implementation AdLunchView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _launchView = [[UIImageView alloc] initWithFrame:self.bounds];
        _launchView.backgroundColor = [UIColor whiteColor];
        _launchView.contentMode = UIViewContentModeScaleAspectFill;
        _launchView.userInteractionEnabled = YES;
        
        [self initLoadingImageView];

        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
    }
    return self;
}

- (void)initLoadingImageView
{
    NSString  *name = @"beginPlay.gif";
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    if (!self.loadingImageView) {
        self.loadingImageView = [[UIImageView alloc]init];
    }
    self.loadingImageView.backgroundColor = [UIColor clearColor];
    self.loadingImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    self.loadingImageView.frame = self.bounds;
    [_launchView addSubview:self.loadingImageView];
    [_launchView bringSubviewToFront:self.loadingImageView];
    
}

#pragma mark Action

- (void)dismiss
{
    [self dismissAnimation1];
}

- (void)dismissAnimation1
{
    [UIView animateWithDuration:0.5 animations:^{
        _launchView.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1);
        _launchView.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self dismissCompletion];
    }];
}
- (void)dismissAnimation2
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _launchView.frame = CGRectMake(-self.width, 0, self.width, self.height);
    } completion:^(BOOL finished) {
        [self dismissCompletion];
    }];
}

- (void)dismissCompletion
{
    [self removeFromSuperview];
}


@end
