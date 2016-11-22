//
//  PullRefreshCollectionView.m
//  Up
//
//  Created by amy on 14/12/3.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "PullRefreshCollectionView.h"
#import "QBRefreshControl.h"
#import "QBSimpleSyncRefreshControl.h"

@interface PullRefreshCollectionView()<QBRefreshControlDelegate>
@property (nonatomic, strong) QBSimpleSyncRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;
@end

@implementation PullRefreshCollectionView

- (void)dealloc
{
    if (self.refreshControl) {
        self.refreshControl.delegate = nil;
    }
}

- (void)setShowPullRefresh:(BOOL)showPullRefresh
{
    _showPullRefresh = showPullRefresh;
    
    if (_showPullRefresh && self.refreshControl == nil) {
        self.refreshControl = [[QBSimpleSyncRefreshControl alloc] init];
        self.refreshControl.delegate = self;
        self.refreshControl.showUpdateTime = YES;
        [self addSubview:self.refreshControl];
    }
    else {
        [self.refreshControl removeFromSuperview];
        self.refreshControl = nil;
    }
}

- (void)beginRefreshing
{
    [self beginRefreshingWithAnimated:YES];
}

- (void)beginRefreshingWithAnimated:(BOOL)animated
{
    if (_pullCollectionViewState == PullCollectionViewStateRefreshing) {
        return;
    }
    _isRefreshing = YES;
    [self.refreshControl beginRefreshingWithAnimated:animated];
}

- (void)endRefreshing
{
    [self.refreshControl endRefreshing];
}


#pragma mark - QBRefreshControlDelegate

- (BOOL)refreshControlCanRefresh:(QBRefreshControl *)refreshControl
{
    return (_pullCollectionViewState == PullCollectionViewStateNone);
}

- (void)refreshControlDidBeginRefreshing:(QBRefreshControl *)refreshControl
{
    if ([self.delegate respondsToSelector:@selector(collectionViewDidBeginRefreshing:)]) {
        [(id <PullRefreshCollectionViewDelegate>)self.delegate collectionViewDidBeginRefreshing:self];
    }
}

- (void)refreshControlWillBeginRefreshing:(QBRefreshControl *)refreshControl
{
    _pullCollectionViewState = PullCollectionViewStateRefreshing;
}

- (void)refreshControlDidEndRefreshing:(QBRefreshControl *)refreshControl
{
    _pullCollectionViewState = PullCollectionViewStateNone;
    _isRefreshing = NO;
    if ([self.delegate respondsToSelector:@selector(collectionViewDidEndRefreshing:)]) {
        [(id <PullRefreshCollectionViewDelegate>)self.delegate collectionViewDidEndRefreshing:self];
    }
}

@end


