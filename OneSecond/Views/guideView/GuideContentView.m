//
//  GuideContentView.m
//  Up
//
//  Created by sup-mac03 on 15/12/3.
//  Copyright © 2015年 amy. All rights reserved.
//

#import "GuideContentView.h"

#define kTitleFont [UIFont boldSystemFontOfSize:15]
#define kContentEdgeInsets UIEdgeInsetsMake(40, 40, 40, 40)
#define kContentImageEdgeInsets UIEdgeInsetsMake(0, 30, 0, 30)
#define kGuideContentViewWidth kScreenWidth - 100
#define kTriangleOffSet 4

#define kTriangleBlueUpImage [UIImage imageNamed:@"TriangleBlueUp"]
#define kTriangleBlueDownImage [UIImage imageNamed:@"TriangleBlueDown"]
#define kGuideAlertImage    [UIImage imageNamed:@"bulbIcon"]
//#define kremindSignSmallImage     [UIImage imageNamed:@"remindSignSmall"]
#define kTraverseGesturesImage     [UIImage imageNamed:@"TraverseGestures"]

@interface GuideContentView ()
{
    UIView *_bgView;//蓝色背景
    UILabel *_guideLabel;//提示文字
    UIImageView *_alertImageView;//叹号
    UIImageView *_arrowImageView;//箭头
    UIImageView *_contentImageView;//内容图片
}
@end

@implementation GuideContentView

- (instancetype) initWithFrame:(CGRect)frame
{
    frame.size.width = kGuideContentViewWidth;
    
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        
        self.clipsToBounds = YES;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = ColorForHex(0x3365fd);
        _bgView.layer.cornerRadius = 5.f;
        [self addSubview:_bgView];
        
        _guideLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _guideLabel.numberOfLines = 0;
        _guideLabel.backgroundColor = [UIColor clearColor];
        _guideLabel.textAlignment = NSTextAlignmentCenter;
        _guideLabel.textColor = [UIColor whiteColor];
        _guideLabel.font = kTitleFont;
        [_bgView addSubview:_guideLabel];
        
        _alertImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _alertImageView.backgroundColor = [UIColor clearColor];
        _alertImageView.image = kGuideAlertImage;
        [_bgView addSubview:_alertImageView];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_arrowImageView];

        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentImageView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_contentImageView];
    }
    return self;
}
//默认位置
- (void)commonInit
{
    self.guideArrowPosition = GuideArrowPositionTopMiddle;
    self.guideAlertIconPosition = GuideAlertIconPositionTopMiddle;
    self.guideContentImagePosition = GuideContentImagePositionNone;
}

- (void)setGuideTitle:(NSString *)guideTitle
{
    if (_guideTitle != guideTitle) {
        _guideTitle = guideTitle;
    }
    [self setUpUI];
}

- (void)setUpUI
{
    CGFloat titleWidth = kGuideContentViewWidth - kContentEdgeInsets.left - kContentEdgeInsets.right;
    _contentImageView.hidden = YES;
    if (self.guideContentImagePosition != GuideContentImagePositionNone) {
        _contentImageView.hidden = NO;
        titleWidth = kGuideContentViewWidth - kContentEdgeInsets.left - kContentImageEdgeInsets.left - kContentImageEdgeInsets.right - kTraverseGesturesImage.size.width;
    }
    CGFloat titleHeight = [PublicObject heightForString:self.guideTitle font:kTitleFont andWidth:titleWidth];
    _guideLabel.text = self.guideTitle;
    
    CGFloat bgViewHeight = titleHeight + kContentEdgeInsets.top + kContentEdgeInsets.bottom;
    self.height = titleHeight + kContentEdgeInsets.top + kContentEdgeInsets.bottom + kTriangleBlueUpImage.size.height - kTriangleOffSet + kGuideAlertImage.size.height / 2.f;
    
    // 背景
    _bgView.frame = CGRectMake(0, 0, self.width, bgViewHeight);
    if (self.guideAlertIconPosition == GuideAlertIconPositionTopMiddle) {
        _bgView.top = kGuideAlertImage.size.height / 2.f;
    }
    
    // 警告图标
    _alertImageView.frame = CGRectMake((_bgView.width - kGuideAlertImage.size.width) / 2.f, _bgView.bottom - kGuideAlertImage.size.height, kGuideAlertImage.size.width, kGuideAlertImage.size.height);
    if (self.guideAlertIconPosition == GuideAlertIconPositionTopMiddle) {
        _alertImageView.top = -kGuideAlertImage.size.height / 2.f;
    }
    
    // 引导语
    _guideLabel.frame = CGRectMake(kContentEdgeInsets.left, kContentEdgeInsets.top, titleWidth, titleHeight);
    
    // 内容里面的图片
    _contentImageView.image = kTraverseGesturesImage;
    _contentImageView.frame = CGRectMake(_guideLabel.right + kContentImageEdgeInsets.left, (_bgView.height - kTraverseGesturesImage.size.height) / 2.f, kTraverseGesturesImage.size.width, kTraverseGesturesImage.size.height);
    
    // 箭头
    _arrowImageView.frame = CGRectMake(0, 0, kTriangleBlueUpImage.size.width, kTriangleBlueUpImage.size.height);
    if (self.guideArrowPosition == GuideArrowPositionTopLeft) {
        _arrowImageView.image = kTriangleBlueUpImage;
        _arrowImageView.top = - kTriangleBlueUpImage.size.height + kTriangleOffSet;
        _arrowImageView.left = - kTriangleBlueUpImage.size.width / 2.f;
    }
    else if (self.guideArrowPosition == GuideArrowPositionTopMiddle){
        _arrowImageView.image = kTriangleBlueUpImage;
        _arrowImageView.top = - kTriangleBlueUpImage.size.height + kTriangleOffSet;
        _arrowImageView.left = (_bgView.width - kTriangleBlueUpImage.size.width) / 2.f;

    }
    else if (self.guideArrowPosition == GuideArrowPositionTopRight){
        _arrowImageView.image = kTriangleBlueUpImage;
        _arrowImageView.top = - kTriangleBlueUpImage.size.height + kTriangleOffSet;
        _arrowImageView.left = _bgView.width - kTriangleBlueUpImage.size.width / 2.f;
    }
    else if (self.guideArrowPosition == GuideArrowPositionBottomLeft){
        _arrowImageView.image = kTriangleBlueDownImage;
        _arrowImageView.top = _bgView.height - kTriangleOffSet;
        _arrowImageView.left = - kTriangleBlueDownImage.size.width / 2.f;
    }
    else if (self.guideArrowPosition == GuideArrowPositionBottomMiddle){
        _arrowImageView.image = kTriangleBlueDownImage;
        _arrowImageView.top = _bgView.height - kTriangleOffSet;
        _arrowImageView.left = (_bgView.width - kTriangleBlueDownImage.size.width) / 2.f;
    }
    else if (self.guideArrowPosition == GuideArrowPositionBottomRight){
        _arrowImageView.image = kTriangleBlueDownImage;
        _arrowImageView.top = _bgView.height - kTriangleOffSet;
        _arrowImageView.left = _bgView.width - kTriangleBlueDownImage.size.width / 2.f;
    }else if (self.guideArrowPosition == GuideArrowPositionBottomNone){
        _arrowImageView.hidden = YES;
    }
}
@end
