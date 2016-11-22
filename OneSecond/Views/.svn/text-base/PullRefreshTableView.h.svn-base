//
//  PullRefreshTableView.h
//  Up
//
//  Created by amy on 13-6-20.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBSimpleSyncRefreshControl.h"
#import "LoadMoreFooterView.h"

typedef enum {
    PullTableViewStateNone,
    PullTableViewStateRefreshing,
    PullTableViewStateLoadingMore
}PullTableViewState;

@protocol PullRefreshTableViewDelegate;

@interface PullRefreshTableView : UITableView <QBRefreshControlDelegate, LoadMoreFooterViewDelegate>
{
    QBSimpleSyncRefreshControl *_pullRefreshControl;
    LoadMoreFooterView *_loadMoreView;
}
- (void)beginRefreshing;
- (void)beginRefreshingWithAnimated:(BOOL)animated;
- (void)endRefreshing;
- (void)beginLoadMore;
- (void)endLoadMore;
@property (nonatomic, assign) BOOL isNoMoreData;
@property (nonatomic, assign) BOOL showPullRefresh;
@property (nonatomic, assign) BOOL showPullRefreshDate;
@property (nonatomic, assign) BOOL isDiscoveryPullRefresh;
@property (nonatomic, assign) BOOL showLoadMore;
@property (nonatomic, weak) id <PullRefreshTableViewDelegate> pullRefreshDelegate;
@property (nonatomic, assign, readonly) PullTableViewState pullTableViewState;
@property (nonatomic, strong) NSDictionary *loadMoreTextAttributes;
@property (nonatomic, weak) NSString *lastUpdateTime;
@property (nonatomic, strong) UIColor *loadMoreColor;
@property (nonatomic, assign) BOOL isHiddenNoDataText;

@end

@protocol PullRefreshTableViewDelegate <NSObject>
@optional
- (void)tableViewDidBeginRefreshing:(PullRefreshTableView *)tableView;
- (void)tableViewDidBeginLoadMore:(PullRefreshTableView *)tableView;
@end