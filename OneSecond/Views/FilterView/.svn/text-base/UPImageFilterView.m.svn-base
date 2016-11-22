//
//  UPImageFilterView.m
//  Up
//
//  Created by sup-mac03 on 15/3/20.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageFilterView.h"
#import "TranslucentButton.h"
#import "UPImageFilter.h"
#import "UPFilterItem.h"
#import "UPFilterToolBar.h"
//#import "UPCounting.h"

#define kFilterViewHeight 85.f

#define kBaseTag 100

#define kBackgroundColor ColorForHex(0x1e1d1d)

@interface UPImageFilterView ()<UPFilterToolBarDelegate>
{
    GPUImageView *_imageView;
    UIImageView *_imageViewAferFilter;
    GPUImagePicture *_sourcePic;
    UPImageFilterType _currentFilterType;
    UPFilterToolBar *_toolBar;
    
    UIImageView *_originalImageView;
    UIView *_picBGView;
}
@end

@implementation UPImageFilterView

- (void)dealloc
{
    [_sourcePic removeAllTargets];
    _sourcePic = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        [self creatTitleView];
        [self creatImageView];
        [self creatFilterItemsView];
        [self showView];
        [self addGestureRecognizer];
    }
    return self;
}
- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [_picBGView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [_picBGView addGestureRecognizer:rightSwipe];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.1;
    [_picBGView addGestureRecognizer:longPress];
}
- (void)longPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _originalImageView.hidden = NO;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        _originalImageView.hidden = YES;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        _originalImageView.hidden = YES;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        _originalImageView.hidden = YES;
    }
}

#pragma mark- view
- (void)creatTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kNavBarHeight)];
    titleView.backgroundColor = kTabBarBackgroundColor;
    [self addSubview:titleView];
    
    // 返回按钮
    TranslucentButton *backButton = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0, 0,60, titleView.height);
    [backButton setImage:kWhiteCloseBtnImage forState:UIControlStateNormal];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    //    backButton.userInteractionEnabled = NO;
    [titleView addSubview:backButton];
    
    // 标题
    UIFont *labelFont = [UIFont systemFontOfSize:15.f];
    CGFloat titleLabelWidth = titleView.width - backButton.right * 2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(backButton.right, 0, titleLabelWidth, titleView.height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = labelFont;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = MYTextAlignmentCenter;
    label.text = UPLocStr(@"photoFilter");
    [titleView addSubview:label];
    
    // 完成按钮
    TranslucentButton *doneBtn = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    doneBtn.backgroundColor = [UIColor clearColor];
    doneBtn.frame = CGRectMake(self.width - 60, 0,60, titleView.height);
    [doneBtn setTitle:UPLocStr(@"apply") forState:UIControlStateNormal];
    doneBtn.titleLabel.font = labelFont;
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [doneBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [titleView addSubview:doneBtn];
}

- (void)creatImageView
{
    _picBGView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.width, self.height - kNavBarHeight)];
    _picBGView.backgroundColor = [UIColor clearColor];
    [self addSubview:_picBGView];
    
    _imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.width, self.height - kNavBarHeight)];
    [_picBGView addSubview:_imageView];
    
    _imageViewAferFilter = [[UIImageView alloc] initWithFrame:_imageView.frame];
    [_picBGView addSubview:_imageViewAferFilter];
    
    _originalImageView = [[UIImageView alloc] initWithFrame:_imageView.frame];
    [_picBGView addSubview:_originalImageView];
    _originalImageView.hidden = YES;
}

- (void)creatFilterItemsView
{
    _toolBar = [[UPFilterToolBar alloc] initWithFrame:CGRectMake(0, self.height, self.width, kFilterViewHeight)];
    _toolBar.delegate = self;
    _toolBar.filters = [UPImageFilter UPImageFilters];
    _toolBar.backgroundColor = [UIColor blackColor];//kBackgroundColor;
    [self addSubview:_toolBar];
}

#pragma mark - gestureRecognizer

- (void)leftSwipe
{
    NSInteger index = _currentFilterType + 1;
    if (index == [UPImageFilter UPImageFilters].count) {
        return;
    }
    [_toolBar setSelectedItemWithIndex:index];
    [self filterImageForType:(UPImageFilterType)index];
    _currentFilterType = (UPImageFilterType)index;
}
- (void)rightSwipe
{
    NSInteger index = _currentFilterType - 1;
    if (index < 0) {
        return;
    }
    [_toolBar setSelectedItemWithIndex:index];
    [self filterImageForType:(UPImageFilterType)index];
    _currentFilterType = (UPImageFilterType)index;

}
#pragma mark - sourceImage

- (void)setSourceImage:(UIImage *)sourceImage
{
    if (_sourceImage != sourceImage) {
        _sourceImage = sourceImage;
    }
    // 给图片加滤镜时，GPUImage会自动读取图片的方向，并按照原来的图片方向显示出来，所以这里先进行图片的方向调整，使得图片方向一致
    _sourceImage = [PublicObject fixOrientationForImage:_sourceImage];
    [self adjustImageView:_imageView];
    _sourcePic = [[GPUImagePicture alloc] initWithImage:_sourceImage];
    [self filterImageForType:UPImageFilter_normal];
}

- (void)adjustImageView:(GPUImageView *)imageView
{
    CGFloat bWidth = self.width;
    CGFloat bHeight = self.height - kNavBarHeight;
    UIImage *image = self.sourceImage;
    CGSize tSize = [PublicObject sizeWithImage:image adjustToSize:CGSizeMake(bWidth, bHeight)];
    imageView.frame = CGRectMake((bWidth - tSize.width) / 2.0,
                                 (bHeight - tSize.height) / 2.0, tSize.width, tSize.height);
    
    //滤镜后的图片
    _imageViewAferFilter.image = self.sourceImage;
    _imageViewAferFilter.frame = imageView.frame;
    
    // 原始图片
    _originalImageView.image = self.sourceImage;
    _originalImageView.frame = imageView.frame;
}

#pragma mark - filter

- (void)done
{
//    NSDictionary *dict = [[UPImageFilter UPImageFilters] objectAtIndex:_currentFilterType];
//    NSString *filterName = [dict objectForKey:UPFILTER_NAME];
//    [UPCounting countEvent:kEvent_AddfilterToImage label:filterName labelKey:kKeyAddFilteToImage];
//    [UPCounting countEvent:kEvent_FilterUserNumber label:filterName labelKey:kFlurryFilterUserNumberKey];
    
    UIImage *filterdImage = [UPImageFilter filteredImageWithSourcePicture:_sourcePic filterType:_currentFilterType];
    if (self.delegate && [self.delegate respondsToSelector:@selector(upImageFilterView:didFilterdImage:)]) {
        [self.delegate upImageFilterView:self didFilterdImage:filterdImage];
    }
    [self closeView];
}

- (void)filterImageForType:(UPImageFilterType)type
{
    UIImage *filterdImage = [UPImageFilter filteredImageWithSourcePicture:_sourcePic filterType:type];
    _imageViewAferFilter.image = filterdImage;
}

#pragma mark- UPFilterToolBar Delegate Method

- (void)filterToolBar:(UPFilterToolBar *)toolBar didSelctedFilterWithIndex:(NSInteger)index
{
    NSDictionary *dict = [[UPImageFilter UPImageFilters] objectAtIndex:index];
    _currentFilterType = [[dict objectForKey:UPFILTER_TYPE] integerValue];
    [self filterImageForType:_currentFilterType];
}

#pragma mark view control method

- (void)showView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
        _toolBar.frame = CGRectMake(0, self.height - kFilterViewHeight, self.width, kFilterViewHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)hideView
{
    [UIView animateWithDuration:0.1 animations:^{
        _toolBar.frame = CGRectMake(0, self.height, self.width, kFilterViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)closeView
{
    [self hideView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(upImageFilterViewCloseBtnDidClicked)]) {
        [self.delegate upImageFilterViewCloseBtnDidClicked];
    }
}
@end
