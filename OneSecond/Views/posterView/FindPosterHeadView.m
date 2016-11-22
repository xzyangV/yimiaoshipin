//
//  FindPosterHeadView.m
//  Up
//
//  Created by sup-mac03 on 15/9/9.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "FindPosterHeadView.h"
#import "UIImageView+SDUPCache.h"
#import "iCarousel.h"
#import "TTimer.h"
#import "PosterTopicList.h"
#import "PosterObject.h"
#import "SMPageControl.h"

@interface FindPosterHeadView ()<iCarouselDataSource,iCarouselDelegate>
{
    iCarousel *_posterView;
    BOOL _canAutoScroll;
    SMPageControl *_pageControl;
}
@property (nonatomic, strong) TTimer *timer;


@end

@implementation FindPosterHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _canAutoScroll = YES;
//        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
//        [self addGestureRecognizer:tapGR];
        
        _posterView = [[iCarousel alloc] initWithFrame:self.bounds];
        _posterView.delegate = self;
        _posterView.dataSource = self;
        _posterView.type = iCarouselTypeLinear;
        _posterView.pagingEnabled = YES;
        [self addSubview:_posterView];
        
        _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, self.height-15-8, kScreenWidth, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = self.topicList.count;
        _pageControl.currentPage = 0;
        [_pageControl setPageIndicatorImage:[UIImage imageNamed:@"GrayPoint"]];
        [_pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"bluePoint"]];
//        [self addSubview:_pageControl];

    
        self.timer = [TTimer timerWithTarget:self action:@selector(onTimer) timerInterval:3.0];
        self.timer.enabled = YES;
    }
    return self;
}

- (void)dealloc
{
    [self stopAnimation];
}

//- (void)tapGR:(UIGestureRecognizer *)sender
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(findPosterHeadView:didClickedItem:)]) {
//        [self.delegate findPosterHeadView:self didClickedItem:@"a"];
//    }
//}


- (void)setTopicList:(PosterTopicList *)topicList
{
    if (_topicList != topicList) {
        _topicList = topicList;
    }
    _pageControl.numberOfPages = _topicList.count;
    [_posterView reloadData];
}

- (void)startAnimation
{
    _canAutoScroll = YES;
    self.timer.enabled = YES;
}

- (void)stopAnimation
{
    self.timer.enabled = NO;
    _canAutoScroll = NO;
}

- (void)onTimer
{
    if (self.window) {
        [self autoScrollPoster];
    }
}

- (void)autoScrollPoster
{
    if (!_canAutoScroll) {
        return;
    }
    if (_posterView.numberOfItems > 1 && !_posterView.dragging && !_posterView.decelerating) {
        NSInteger index = _posterView.currentItemIndex;
        index = (index == _posterView.numberOfItems - 1) ? 0 : index + 1;
        [_posterView scrollToItemAtIndex:index animated:YES];
        _pageControl.currentPage = index;
    }
}



#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.topicList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *mView = (UILabel *)view;
    if (mView == nil) {
        mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_posterView.width , _posterView.height)];
        mView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mView.width, mView.height)];
        mainImageView.backgroundColor = [UIColor clearColor];
        mainImageView.clipsToBounds = YES;
        mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        mainImageView.tag = 100;
        [mView addSubview:mainImageView];

        
        UILabel * topicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (mView.height - 20) / 2, mView.width, 20)];
        topicTitleLabel.backgroundColor = [UIColor clearColor];
        topicTitleLabel.textAlignment = NSTextAlignmentCenter;
        topicTitleLabel.textColor = [UIColor whiteColor];
        topicTitleLabel.font = [UIFont boldSystemFontOfSize:20];
        topicTitleLabel.center = mView.center;
        topicTitleLabel.tag = 200;
       // [mView addSubview:topicTitleLabel];
    }

    PosterObject *posterObject = [self.topicList objectAtIndex:index];
    UIImageView *imageView = (UIImageView *)[mView viewWithTag:100];
    imageView.image = nil;
    [imageView cancelCurrentImageLoad];
    UILabel *label = (UILabel *)[mView viewWithTag:200];
    [imageView setImageWithURL:[NSURL URLWithString:posterObject.img_url] placeholderImage:nil];
    label.text = posterObject.title;

    return mView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    _pageControl.currentPage= carousel.currentItemIndex;
}
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    _pageControl.currentPage= carousel.currentItemIndex;
}
- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    return (option == iCarouselOptionWrap) ? YES : value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    PosterObject *posterObject = [self.topicList objectAtIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(findPosterHeadView:didClickedItem:)]) {
        [self.delegate findPosterHeadView:self didClickedItem:posterObject];
    }
}

@end
