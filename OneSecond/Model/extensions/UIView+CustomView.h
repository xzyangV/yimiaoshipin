//
//  UIView+CustomView.h
//  Up
//
//  Created by amy on 13-4-28.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomView)

@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign, readonly) CGFloat right;
@property(nonatomic, assign, readonly) CGFloat bottom;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@end
