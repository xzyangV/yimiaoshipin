//
//  UPFilterToolBar.h
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPFilterToolBar;

@protocol UPFilterToolBarDelegate <NSObject>

- (void)filterToolBar:(UPFilterToolBar *)toolBar didSelctedFilterWithIndex:(NSInteger)index;

@end
@interface UPFilterToolBar : UIView

@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, assign) id<UPFilterToolBarDelegate>delegate;
- (void)setSelectedItemWithIndex:(NSInteger)index;
@end
