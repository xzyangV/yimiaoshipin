//
//  PullRefreshTableView.m
//  Up
//
//  Created by amy on 13-6-20.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "PullRefreshTableView.h"

@interface PullRefreshTableView ()

@end

@implementation PullRefreshTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _pullTableViewState = PullTableViewStateNone;
    }
    return self;
}

- (void)reloadData
{
    [super reloadData];
    
    if (self.showLoadMore) {
        self.isNoMoreData = NO;

        if (self.contentSize.height - self.tableHeaderView.height > self.height) {
            self.tableFooterView = _loadMoreView;
        }
        else {
            self.tableFooterView = nil;
        }
    }
}

- (void)setShowPullRefresh:(BOOL)showPullRefresh
{
    if (_showPullRefresh != showPullRefresh) {
        _showPullRefresh = showPullRefresh;
    }
    if (_showPullRefresh) {
        [self createPullRefreshControl];
    }
    else {
        [_pullRefreshControl removeFromSuperview];
        _pullRefreshControl = nil;
    }
}

- (void)setShowLoadMore:(BOOL)showLoadMore
{
    if (_showLoadMore != showLoadMore) {
        _showLoadMore = showLoadMore;
    }
    if (_showLoadMore) {
        [self createLoadMoreFooterView];
    }
    else {
        self.tableFooterView = nil;
        _loadMoreView = nil;
    }
}

- (void)createPullRefreshControl
{
    if (_pullRefreshControl == nil) {
        _pullRefreshControl = [[QBSimpleSyncRefreshControl alloc] init];
        _pullRefreshControl.delegate = self;
        _pullRefreshControl.showUpdateTime = NO;
        [self addSubview:_pullRefreshControl];
    }
}

- (void)createLoadMoreFooterView
{
    if (_loadMoreView == nil) {
        _loadMoreView = [[LoadMoreFooterView alloc] init];
        _loadMoreView.delegate = self;
    }
}

- (void)setLoadMoreTextAttributes:(NSDictionary *)loadMoreTextAttributes
{
    if (_loadMoreTextAttributes != loadMoreTextAttributes) {
        _loadMoreTextAttributes = loadMoreTextAttributes;
    }
    if (_loadMoreView) {
        _loadMoreView.textAttributes = _loadMoreTextAttributes;
    }
}

- (void)setIsNoMoreData:(BOOL)isNoMoreData
{
    _isNoMoreData = isNoMoreData;
    _loadMoreView.isEnd = _isNoMoreData;
}

- (void)beginRefreshing
{
    [self beginRefreshingWithAnimated:YES];
}

- (void)beginRefreshingWithAnimated:(BOOL)animated
{
    if (_pullTableViewState == PullTableViewStateRefreshing) {
        return;
    }
    [self endLoadMore];
    [_pullRefreshControl beginRefreshingWithAnimated:animated];
}

- (void)endRefreshing
{
    [_pullRefreshControl endRefreshing];
}

- (void)beginLoadMore
{
    if (_pullTableViewState != PullTableViewStateNone) {
        return;
    }
    [_loadMoreView beginLoadMore];
}

- (void)endLoadMore
{
    [_loadMoreView endLoadMore];
    if (self.isHiddenNoDataText) {
        _loadMoreView.noDataText = @"";
    }
}

- (void)didBeginRefresh
{
    [self.pullRefreshDelegate tableViewDidBeginRefreshing:self];
}


- (void)setLastUpdateTime:(NSString *)lastUpdateTime
{
    _pullRefreshControl.lastUpdateTime = lastUpdateTime;
}

- (NSString *)lastUpdateTime
{
    return _pullRefreshControl.lastUpdateTime;
}

- (void)setShowPullRefreshDate:(BOOL)showPullRefreshDate
{
    _showPullRefreshDate = showPullRefreshDate;
    if (_pullRefreshControl) {
        _pullRefreshControl.showUpdateTime = showPullRefreshDate;
    }
}

- (void)setIsDiscoveryPullRefresh:(BOOL)isDiscoveryPullRefresh
{
    _isDiscoveryPullRefresh = isDiscoveryPullRefresh;
    if (_pullRefreshControl) {
        _pullRefreshControl.isDiscovery = _isDiscoveryPullRefresh;
    }
}

- (void)setLoadMoreColor:(UIColor *)loadMoreColor
{
    if (_loadMoreColor != loadMoreColor) {
        _loadMoreColor = loadMoreColor;
    }
    if (_loadMoreColor && _loadMoreView) {
        _loadMoreView.backgroundColor = _loadMoreColor;
    }
}


#pragma mark - QBRefreshControlDelegate

- (BOOL)refreshControlCanRefresh:(QBRefreshControl *)refreshControl
{
    return (self.pullTableViewState == PullTableViewStateNone);
}

- (void)refreshControlWillBeginRefreshing:(QBRefreshControl *)refreshControl
{
    _pullTableViewState = PullTableViewStateRefreshing;
}

- (void)refreshControlDidBeginRefreshing:(QBRefreshControl *)refreshControl
{
    self.isNoMoreData = NO;
    if ([self.pullRefreshDelegate respondsToSelector:@selector(tableViewDidBeginRefreshing:)]) {
        [self didBeginRefresh];
    }
}

- (void)refreshControlDidEndRefreshing:(QBRefreshControl *)refreshControl
{
    _pullTableViewState = PullTableViewStateNone;
}

#pragma mark - LoadMoreFooterViewDelegate

- (BOOL)loadMoreFooterViewCanLoadMore:(LoadMoreFooterView *)loadMoreFooterView
{
    return (self.pullTableViewState == PullTableViewStateNone);
}

- (void)loadMoreFooterViewDidBeginLoadMore:(LoadMoreFooterView *)loadMoreFooterView
{
    _pullTableViewState = PullTableViewStateLoadingMore;
    if ([self.pullRefreshDelegate respondsToSelector:@selector(tableViewDidBeginLoadMore:)]) {
        [self.pullRefreshDelegate tableViewDidBeginLoadMore:self];
    }
}

- (void)loadMoreFooterViewDidEndLoadMore:(LoadMoreFooterView *)loadMoreFooterView
{
    _pullTableViewState = PullTableViewStateNone;
//    if ([self.pullRefreshDelegate respondsToSelector:@selector(tableViewDidEndLoadMore:)]) {
//        [self.pullRefreshDelegate tableViewDidEndLoadMore:self];
//    }
}

@end
