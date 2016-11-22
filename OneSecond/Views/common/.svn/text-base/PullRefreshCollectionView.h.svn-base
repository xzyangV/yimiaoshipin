//
//  PullRefreshCollectionView.h
//  Up
//
//  Created by amy on 14/12/3.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PullCollectionViewStateNone,
    PullCollectionViewStateRefreshing
} PullCollectionViewState;


@interface PullRefreshCollectionView : UICollectionView

- (void)beginRefreshing;
- (void)beginRefreshingWithAnimated:(BOOL)animated;
- (void)endRefreshing;

@property (nonatomic, assign) BOOL showPullRefresh;

@property (nonatomic, assign, readonly) PullCollectionViewState pullCollectionViewState;
@property (nonatomic, weak) NSString *lastUpdateTime;

@end


@protocol PullRefreshCollectionViewDelegate <UICollectionViewDelegate>
@optional
- (void)collectionViewDidBeginRefreshing:(PullRefreshCollectionView *)collectionView;
- (void)collectionViewDidEndRefreshing:(PullRefreshCollectionView *)collectionView;
@end