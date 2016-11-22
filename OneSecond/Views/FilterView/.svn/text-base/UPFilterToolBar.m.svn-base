//
//  UPFilterToolBar.m
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPFilterToolBar.h"
#import "UPFilterItem.h"

#define kSpace 7.5f

@interface UPFilterToolBar ()
{
    UIScrollView *_sv;
}
@end

@implementation UPFilterToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        _sv.backgroundColor = [UIColor clearColor];
        [self addSubview:_sv];
    }
    return self;
}

- (void)setFilters:(NSArray *)filters
{
    if (_filters != filters) {
        _filters = filters;
    }
    [self updateUI];
}

- (void)updateUI
{
    _sv.contentSize = CGSizeMake((kSpace + FILTER_ITEM_WIDTH) * self.filters.count + kSpace, self.height);
    for (int i = 0; i < self.filters.count; i++) {
        UPFilterItem *item = [[UPFilterItem alloc] initWithFrame:CGRectMake(kSpace + (i * (FILTER_ITEM_WIDTH + kSpace)), kSpace, FILTER_ITEM_WIDTH, FILTER_ITEM_HEIGHT+15)];
        item.tag = i;
        item.filterInfo = [self.filters objectAtIndex:i];
        item.layer.cornerRadius = 5.0;
        item.layer.masksToBounds = YES;
        [item addTarget:self action:@selector(filterDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sv addSubview:item];
        if (i == 0) {
            item.selected = YES;
        }
    }
}

- (void)filterDidClicked:(id)sender
{
    UPFilterItem *filterBtn = (UPFilterItem *)sender;
    [self setSelectedItemWithIndex:filterBtn.tag];

    if (self.delegate && [self.delegate respondsToSelector:@selector(filterToolBar:didSelctedFilterWithIndex:)]) {
        [self.delegate filterToolBar:self didSelctedFilterWithIndex:filterBtn.tag];
    }
}

- (void)setSelectedItemWithIndex:(NSInteger)index
{
    for (UPFilterItem *tempItem in _sv.subviews) {
        if ([tempItem isKindOfClass:[UPFilterItem class]]) {
            if (tempItem.tag == index) {
                tempItem.selected = YES;
            }
            else{
                tempItem.selected = NO;
            }
        }
    }
    [self adjustItemWithIndex:index];
}

- (void)adjustItemWithIndex:(NSInteger)index
{
    UPFilterItem *item = (UPFilterItem *)[_sv viewWithTag:index];
    CGRect rect = item.frame;
    
    CGFloat targetOffset = rect.origin.x + rect.size.width / 2.f - _sv.width / 2.f;
    
    if (targetOffset <= 0) {
        targetOffset = 0;
    }
    if (targetOffset >= _sv.contentSize.width - _sv.width) {
        targetOffset = _sv.contentSize.width - _sv.width;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        [_sv setContentOffset:CGPointMake(targetOffset, 0)];
    } completion:^(BOOL finished) {
        [_sv setContentOffset:CGPointMake(targetOffset, 0)];
    }];    
}
@end
