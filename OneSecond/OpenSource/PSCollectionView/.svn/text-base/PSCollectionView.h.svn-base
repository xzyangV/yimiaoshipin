//
// PSCollectionView.h
//
// Copyright (c) 2012 Peter Shih (http://petershih.com)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "PSCollectionViewCell.h"

#define kPSCollectionViewDidRelayoutNotification @"kPSCollectionViewDidRelayoutNotification"

typedef enum {
    PSCollectionViewStateNone,
    PSCollectionViewStateRefreshing,
    PSCollectionViewStateLoadingMore
}PSCollectionViewState;

@class PSCollectionViewCell;

@protocol PSCollectionViewDelegate, PSCollectionViewDataSource;

@interface PSCollectionView : UIScrollView

#pragma mark - Public Properties

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign, readonly) CGFloat colWidth;
@property (nonatomic, assign, readonly) NSInteger numCols;
@property (nonatomic, assign) NSInteger numColsLandscape;
@property (nonatomic, assign) NSInteger numColsPortrait;
@property (nonatomic, weak) id <PSCollectionViewDelegate> collectionViewDelegate;
@property (nonatomic, weak) id <PSCollectionViewDataSource> collectionViewDataSource;

//增加纵向和横向间距属性
@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign, readonly) PSCollectionViewState state;
@property (nonatomic, assign) BOOL isNoMoreData;
//显示加载更多
@property (nonatomic, assign) BOOL showLoadMore;
//显示下拉刷新
@property (nonatomic, assign) BOOL showRefreshControl;

@property (nonatomic, assign, readonly) BOOL isRefreshing;
@property (nonatomic, assign) NSString *lastUpdateTime;
@property (nonatomic, assign, readonly) CGFloat actualContentHeight;


- (void)beginRefreshing;
- (void)endRefreshing;
- (void)beginLoadMore;
- (void)endLoadMore;



#pragma mark - Public Methods

/**
 Reloads the collection view
 This is similar to UITableView reloadData)
 */
- (void)reloadData;

/**
 Dequeues a reusable view that was previously initialized
 This is similar to UITableView dequeueReusableCellWithIdentifier
 */
- (PSCollectionViewCell *)dequeueReusableViewForClass:(Class)viewClass;

- (NSArray *)visibleCells; // add by zhangyx

@end

#pragma mark - Delegate

@protocol PSCollectionViewDelegate <NSObject>

@optional
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell
               atIndex:(NSInteger)index;
- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index;

- (void)collectionViewDidBeginLoadMore:(PSCollectionView *)collectionView;
- (void)collectionViewDidBeginRefreshing:(PSCollectionView *)collectionView;
- (void)collectionViewDidEndRefreshing:(PSCollectionView *)collectionView;
@end

#pragma mark - DataSource

@protocol PSCollectionViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView;
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index;
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index;

@end
