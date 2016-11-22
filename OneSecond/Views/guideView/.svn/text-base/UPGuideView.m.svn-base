//
//  UPGuideView.m
//  Up
//
//  Created by sup-mac03 on 14-4-30.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "UPGuideView.h"
#import "UIView+Screenshot.h"
#import "UIImage+Blur.h"
#import "GuideContentView.h"
#import "TranslucentButton.h"
#import "YLZHoledView.h"
#import "VideoClipEditDragCell.h"
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIntroduceString UPLocStr(@"paste guide string")
#define kShowPictureGuide UPLocStr(@"showPictureGuide")
#define kLeftMargin 40
#define kMargin 20
#define kTitleColor ColorForHex(0x17a5fc)
#define kBGBackColor ColorForHexAlpha(0x000000, 0.7)

#define kTriangleBlueUpImage [UIImage imageNamed:@"TriangleBlueUp"]
#define kTriangleBlueDownImage [UIImage imageNamed:@"TriangleBlueDown"]
#define kremindSignBigImage    [UIImage imageNamed:@"bulbIcon"]
#define kremindSignSmallImage     [UIImage imageNamed:@"remindSignSmall"]
#define kTraverseGesturesImage     [UIImage imageNamed:@"TraverseGestures"]


@interface UPGuideView ()<YLZHoledViewDelegate>
{
    YLZHoledView *_holeView;
}



@end
@implementation UPGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGuideView)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}


- (void)setUpGuideType:(UPGuideType)upGuideType
{
    self.currentupGuideType = upGuideType;
    switch (upGuideType) {
        case UPGuideTypeExitSecondVideoAndBeginRecord:[self setUPGuideTypeExitSecondVideoAndBeginRecordGuideView];break;
        case UPGuideTypeCreatMoreSecondVideo:[self setCreatMoreSecondVideoGuideView];break;
        case UPGuideTypePreviewAndEditSecondVideo:[self setUPGuideTypePreviewAndEditSecondVideoGuideView];break;
        case UPGuideTypeMoveSecondVideo:[self setUPGuideTypeMoveSecondVideoGuideView];break;
        case UPGuideTypeNextLensSecondVideo:[self setUPGuideTypeNextLensSecondVideo];break;
        case UPGuideTypePreviewSecondVideo:[self setUPGuideTypePreviewSecondVideo];break;
        default:break;
    }
}


//开始录制
- (void)setUPGuideTypeExitSecondVideoAndBeginRecordGuideView
{
    UIImage *image = [UIImage imageNamed:@"recordVideoBtn"];
    _holeView = [[YLZHoledView alloc]initWithFrame:self.frame];
    _holeView.holeViewDelegate = self;
    [self addSubview:_holeView];
    [_holeView addHoleRoundedRectOnRect:CGRectMake((self.frame.size.width-image.size.width) / 2, 68+kScreenWidth + 68 + (kScreenHeight-kScreenWidth-68-66-image.size.height)/2, image.size.width, image.size.height) withCornerRadius:image.size.width/2];
    
    UIImage *recordImage = [UIImage imageNamed:@"recordClick"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-recordImage.size.width) / 2+10,  68+kScreenWidth + 68 + (kScreenHeight-kScreenWidth-68-66-image.size.height)/2 - recordImage.size.height, recordImage.size.width, recordImage.size.height)];
    imageView.image = recordImage;
    [_holeView addSubview:imageView];

    
    
}
//创建更多一秒视频
- (void)setCreatMoreSecondVideoGuideView
{
    _holeView = [[YLZHoledView alloc]initWithFrame:self.frame];
    _holeView.holeViewDelegate = self;
    [self addSubview:_holeView];
    [_holeView addHoleRoundedRectOnRect:CGRectMake(8, 5, 40, 40) withCornerRadius:20];
    
    UIImage *creatImage = [UIImage imageNamed:@"creatMoreVideo"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 44, creatImage.size.width, creatImage.size.height)];
    imageView.image = creatImage;
    [_holeView addSubview:imageView];
    
}
//编辑按钮引导
- (void)setUPGuideTypePreviewAndEditSecondVideoGuideView
{
    _holeView = [[YLZHoledView alloc]initWithFrame:self.frame];
    _holeView.holeViewDelegate = self;
    [self addSubview:_holeView];
    [_holeView addHoleRectOnRect:CGRectMake(0, self.customeView.top + 44, self.customeView.width, self.customeView.height)];
    
    UIImage *creatImage = [UIImage imageNamed:@"editCameal"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, kScreenWidth+64-creatImage.size.height + 5 , creatImage.size.width, creatImage.size.height)];
    imageView.image = creatImage;
    [_holeView addSubview:imageView];
    
}

//长按移动编辑一秒视频引导
- (void)setUPGuideTypeMoveSecondVideoGuideView
{
    CGFloat itemSize = [VideoClipEditDragCell defaultSize];
    CGFloat space = (kScreenWidth - 4 * itemSize) / 5.f;
    UIImage *image = [UIImage imageNamed:@"video_record_edit_delete"];
    _holeView = [[YLZHoledView alloc]initWithFrame:self.frame];
    _holeView.holeViewDelegate = self;
    [self addSubview:_holeView];
    [_holeView addHoleRoundedRectOnRect:CGRectMake(2 * space + itemSize + 12, 30 + 42 + 10 + image.size.height / 2, 60, 60) withCornerRadius:0];
    
    UIImage *creatImage = [UIImage imageNamed:@"pressToMove"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + space + itemSize / 2,30 + 10 + 42 + itemSize, creatImage.size.width, creatImage.size.height)];
    imageView.image = creatImage;
    [_holeView addSubview:imageView];
}

//在按一下 录制下一个镜头引导
- (void)setUPGuideTypeNextLensSecondVideo{
    UIImage *image = [UIImage imageNamed:@"recordVideoBtn"];
    _holeView = [[YLZHoledView alloc]initWithFrame:self.frame];
    _holeView.holeViewDelegate = self;
    [self addSubview:_holeView];
    [_holeView addHoleRoundedRectOnRect:CGRectMake((self.frame.size.width-image.size.width) / 2, 68+kScreenWidth + 68 + (kScreenHeight-kScreenWidth-68-66-image.size.height)/2, image.size.width, image.size.height) withCornerRadius:image.size.width/2];
    
    UIImage *recordImage = [UIImage imageNamed:@"nextRecordClick"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-recordImage.size.width) / 2+10,  68+kScreenWidth + 68 + (kScreenHeight-kScreenWidth-68-66-image.size.height)/2 - recordImage.size.height, recordImage.size.width, recordImage.size.height)];
    imageView.image = recordImage;
    [_holeView addSubview:imageView];
}

//预览视频
- (void)setUPGuideTypePreviewSecondVideo{
    
    _holeView = [[YLZHoledView alloc]initWithFrame:self.frame];
    _holeView.holeViewDelegate = self;
    [self addSubview:_holeView];
    [_holeView addHoleRoundedRectOnRect:CGRectMake(kScreenWidth - 62, 0, 50, 50) withCornerRadius:25];
    
    UIImage *nextPreviewImage = [UIImage imageNamed:@"nextPreview"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - nextPreviewImage.size.width - 5, 44, nextPreviewImage.size.width, nextPreviewImage.size.height)];
    imageView.image = nextPreviewImage;
    [_holeView addSubview:imageView];
    
}

- (void)setUpImageFilterGuideView
{
    GuideContentView *guideView = [[GuideContentView alloc] initWithFrame:CGRectZero];
    guideView.backgroundColor = [UIColor clearColor];
    guideView.guideArrowPosition = GuideArrowPositionBottomMiddle;
    guideView.guideAlertIconPosition = GuideAlertIconPositionTopMiddle;
    guideView.guideContentImagePosition = GuideContentImagePositionRight;
    guideView.guideTitle = UPLocalizedString(@"slide to switch filter", nil);//@"左右滑动切换滤镜";
    [self addSubview:guideView];
    guideView.frame = CGRectMake((self.width - guideView.width) / 2.f, 20, guideView.width, guideView.height);

}
- (void)hideGuideView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.currentupGuideType == UPGuideTypeExitSecondVideoAndBeginRecord) {//当录制视频结束后展现创建更多视频
            [UPGuide showGuideWithType:UPGuideTypeCreatMoreSecondVideo completed:NULL];
        }
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    [self setUpGuideView];
}

- (void)holedView:(YLZHoledView *)holedView didSelectHoleAtIndex:(NSUInteger)index
{
    NSLog(@"%s %ld", __PRETTY_FUNCTION__,(long)index);
    [_holeView removeHoles];
    [_holeView removeFromSuperview];
    [self hideGuideView];
}

@end
