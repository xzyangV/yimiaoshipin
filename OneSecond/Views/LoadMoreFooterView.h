//
//  LoadMoreFooterView.h
//  Up
//
//  Created by amy on 13-7-5.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LoadMoreFooterViewStateHidden,
    LoadMoreFooterViewStatePullingDown,
    LoadMoreFooterViewStateOveredThreshold,
    LoadMoreFooterViewStateStopping
} LoadMoreFooterViewState;

@protocol LoadMoreFooterViewDelegate;

@interface LoadMoreFooterView : UIView

- (void)beginLoadMore;
- (void)endLoadMore;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, weak) id <LoadMoreFooterViewDelegate> delegate;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, assign) LoadMoreFooterViewState state;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *textAttributes;
@property (nonatomic, copy) NSString *noDataText;
@end

@protocol LoadMoreFooterViewDelegate <NSObject>
@optional
- (BOOL)loadMoreFooterViewCanLoadMore:(LoadMoreFooterView *)loadMoreFooterView;
- (void)loadMoreFooterViewDidBeginLoadMore:(LoadMoreFooterView *)loadMoreFooterView;
- (void)loadMoreFooterViewDidEndLoadMore:(LoadMoreFooterView *)loadMoreFooterView;
@end
