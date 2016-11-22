//
//  UPLoadMoreView.m
//  Up
//
//  Created by amy on 13-7-5.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "LoadMoreFooterView.h"
#import "PSCollectionView.h"

@interface LoadMoreFooterView ()
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) BOOL isEndDragging;
@property (nonatomic, assign) BOOL isScrollingLoadMore;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton *titleButton;
@end

@implementation LoadMoreFooterView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.threshold = 10;
        self.backgroundColor = [UIColor clearColor];
        self.state = LoadMoreFooterViewStateHidden;
        self.dragging = NO;
        self.isEnd = NO;
        self.isEndDragging = YES;
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleButton.frame = self.bounds;
        self.titleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.titleButton setTitle:UPLocalizedString(@"more...", nil) forState:UIControlStateNormal];

//        [self.titleButton setTitle:@"更多..." forState:UIControlStateNormal];
        UIImage *btnBgImage = [UIImage imageNamed:@"whiteOnePixelBg"];
        [self.titleButton setBackgroundImage:btnBgImage forState:UIControlStateHighlighted];
        self.titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.titleButton addTarget:self action:@selector(buttonClick)
                   forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.titleButton];
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - 20) / 2, 10, 20, 20)];
//        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 10, 20, 20)];
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityView.hidden = YES;
        [self addSubview:self.activityView];
    }
    return self;
}

- (void)setTextAttributes:(NSDictionary *)textAttributes
{
    if (_textAttributes != textAttributes) {
        _textAttributes = textAttributes;
    }
    [PublicObject setButton:self.titleButton
             textAttributes:_textAttributes
               controlState:UIControlStateNormal];
}

- (void)setIsEnd:(BOOL)isEnd
{
    _isEnd = isEnd;
    [self setTitleForEnable];
}

- (void)buttonClick
{
    [self performSelector:@selector(beginLoadMore) withObject:nil afterDelay:0.1];
}

- (void)setTitleForEnable
{
    if (_isEnd) {
//        [self.titleButton setTitle:@"已经拉不动咯!" forState:UIControlStateNormal];
        if (self.noDataText) {
            [self.titleButton setTitle:self.noDataText forState:UIControlStateNormal];
        }
        else {
            [self.titleButton setTitle:@"" forState:UIControlStateNormal];
//            [self.titleButton setTitle:UPLocalizedString(@"The End!", nil) forState:UIControlStateNormal];
        }

        self.titleButton.enabled = NO;
    }
    else {
        [self.titleButton setTitle:UPLocalizedString(@"more...", nil) forState:UIControlStateNormal];
//        [self.titleButton setTitle:@"更多..." forState:UIControlStateNormal];

        self.titleButton.enabled = YES;
    }
}

- (void)beginLoadMore
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginLoadMore) object:nil];
    self.state = LoadMoreFooterViewStateStopping;
    self.titleButton.enabled = NO;
    [self.titleButton setTitle:@"" forState:UIControlStateNormal];/*@"加载中..."*/

//    [self.titleButton setTitle:UPLocalizedString(@"loading...", nil) forState:UIControlStateNormal];/*@"加载中..."*/
    self.activityView.hidden = NO;

    [self.activityView startAnimating];
    if ([self.delegate respondsToSelector:@selector(loadMoreFooterViewDidBeginLoadMore:)]) {
        [self.delegate loadMoreFooterViewDidBeginLoadMore:self];
    }
}

- (void)endLoadMore
{
    [self actualEndLoadMore];
}

- (void)actualEndLoadMore
{
    self.titleButton.enabled = YES;
    [self setTitleForEnable];
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    self.state = LoadMoreFooterViewStateHidden;
    if ([self.delegate respondsToSelector:@selector(loadMoreFooterViewDidEndLoadMore:)]) {
        [self.delegate loadMoreFooterViewDidEndLoadMore:self];
    }
    self.isScrollingLoadMore = NO;
}

- (UIScrollView *)scrollView
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)self.superview;
    }
    return nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
        [self.superview removeObserver:self forKeyPath:@"contentSize"];
    }
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];

    }
    [super willMoveToSuperview:newSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (object == nil) {
        return;
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = (UIScrollView *)object;
        if (self.dragging != scrollView.dragging) {
            if (!scrollView.dragging) {
                [self scrollViewDidEndDragging:scrollView willDecelerate:NO];
            }
            self.dragging = scrollView.dragging;
        }
        [self scrollViewDidScroll:scrollView];
    }
    
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGFloat contentHeight = self.scrollView.contentSize.height;
//        if ([self.scrollView isKindOfClass:[UITableView class]]) {
//            contentHeight-= ((UITableView *)self.scrollView).tableHeaderView.height;
//        }
//        if ([self.scrollView isKindOfClass:[PSCollectionView class]]) {
//            contentHeight = ((PSCollectionView *)self.scrollView).actualContentHeight;
//        }
//        self.hidden = contentHeight < self.scrollView.frame.size.height;
////        self.top = MAX(self.scrollView.contentSize.height, self.sc)
//    }
}


#pragma mark - UIScrollViewDelegate (Detected by observing value changes)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.state == LoadMoreFooterViewStateStopping || self.isEnd) {
        return;
    }
    if (self.scrollView.contentSize.height < self.scrollView.frame.size.height) {
        return;
    }
    CGFloat offsetValue = self.scrollView.contentOffset.y + self.scrollView.frame.size.height;
    
    if (!self.hidden && offsetValue > self.scrollView.contentSize.height) {
        self.state = LoadMoreFooterViewStateOveredThreshold;
        CGFloat offsetValue = self.scrollView.contentOffset.y + self.scrollView.frame.size.height;
        if (!self.hidden && offsetValue > self.scrollView.contentSize.height + self.threshold) {
            if (self.isEnd) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(loadMoreFooterViewCanLoadMore:)]) {
                if (![self.delegate loadMoreFooterViewCanLoadMore:self]) {
                    return;
                }
            }
            if (!self.isScrollingLoadMore && self.isEndDragging) {
                self.isEndDragging = NO;
                self.isScrollingLoadMore = YES;
                [self beginLoadMore];
//                [self performSelector:@selector(beginLoadMore) withObject:nil afterDelay:0.0];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isEndDragging = YES;
//    if (self.state == LoadMoreFooterViewStateStopping)
//        return;
//    if (self.state == LoadMoreFooterViewStateOveredThreshold) {
//        CGFloat offsetValue = self.scrollView.contentOffset.y + self.scrollView.frame.size.height;
//        if (!self.hidden && offsetValue > self.scrollView.contentSize.height + self.threshold) {
//
//            if (self.isEnd) {
//                return;
//            }
//            
//            if ([self.delegate respondsToSelector:@selector(loadMoreFooterViewCanLoadMore:)]) {
//                if (![self.delegate loadMoreFooterViewCanLoadMore:self]) {
//                    return;
//                }
//            }
//            [self performSelector:@selector(beginLoadMore) withObject:nil afterDelay:0.5];
//        }
//    }
}

@end
