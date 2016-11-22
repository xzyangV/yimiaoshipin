//
//  CameraCoverView.m
//  FirstJJ
//
//  Created by sup-mac03 on 13-9-26.
//  Copyright (c) 2013年 sup-mac03. All rights reserved.
//

#import "CameraCoverView.h"

#define kSpShangImage [UIImage imageNamed:@"sp_shang.png"]
#define kSpXiaImage [UIImage imageNamed:@"sp_xia.png"]

#define kSpShangImage5 [UIImage imageNamed:@"sp_shang5.png"]
#define kSpXiaImage5 [UIImage imageNamed:@"sp_xia5.png"]

#define kSpShangImage6P [UIImage imageNamed:@"sp_shang6P"]
#define kSpXiaImage6P [UIImage imageNamed:@"sp_xia6P"]

@interface CameraCoverView()

@property (nonatomic, strong) UIImage *upImage;
@property (nonatomic, strong) UIImage *downImage;

@end

@implementation CameraCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCameraCoverType:(CameraCoverType)cameraCoverType
{
    _cameraCoverType = cameraCoverType;
    self.upImage = kSpShangImage;
    self.downImage = kSpXiaImage;
    
//    if ([PublicObject isiPhone5] && self.cameraCoverType == CameraCoverTypePhoto) {
//        self.upImage = kSpShangImage5;
//        self.downImage = kSpXiaImage5;
//    }
    
    if (kScreenHeight == 568) {
        self.upImage = kSpShangImage5;
        self.downImage = kSpXiaImage5;
    }
    else if (kScreenHeight > 568) {
        self.upImage = kSpShangImage6P;
        self.downImage = kSpXiaImage6P;
    }
    
    [self setCoverView];
}


- (void)setCoverView
{
    _viewHeightDifference = fabs((self.downImage.size.height-self.upImage.size.height));

    CGFloat upViewHeight = self.upImage.size.height;//(self.height)/2;
    if (self.cameraCoverType == CameraCoverTypeVideo) {
        upViewHeight = (self.height / 2.);
    }
    _upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, upViewHeight)];
    _upImageView.backgroundColor = [UIColor clearColor];
    _upImageView.image = self.upImage;
    [self addSubview:_upImageView];
    
    CGFloat top = self.downImage.size.height/2.; // 顶端盖高度
    CGFloat bottom = self.downImage.size.height/2. ; // 底端盖高度
    CGFloat left = 0; // 左端盖宽度
    CGFloat right = 0; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    self.downImage = [self.downImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

    CGFloat downViewOrginY = _upImageView.bottom-_viewHeightDifference;
    _downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, downViewOrginY, self.frame.size.width, self.height-downViewOrginY)];
    _downImageView.backgroundColor = [UIColor clearColor];
    _downImageView.image = self.downImage;
    [self addSubview:_downImageView];

}

- (void)startAnimate
{
    open = !open;
    if (open) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect upImgViewRect = _upImageView.frame;
            upImgViewRect.origin.y = upImgViewRect.origin.y - upImgViewRect.size.height;
            _upImageView.frame = upImgViewRect;
            
            CGRect downImgViewRect = _downImageView.frame;
            downImgViewRect.origin.y = downImgViewRect.origin.y + downImgViewRect.size.height;
            _downImageView.frame = downImgViewRect;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect upImgViewRect = _upImageView.frame;
            upImgViewRect.origin.y = upImgViewRect.origin.y + upImgViewRect.size.height;
            _upImageView.frame = upImgViewRect;
            
            CGRect downImgViewRect = _downImageView.frame;
            downImgViewRect.origin.y = downImgViewRect.origin.y - downImgViewRect.size.height;
            downImgViewRect.size.height = downImgViewRect.size.height;
            _downImageView.frame = downImgViewRect;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
