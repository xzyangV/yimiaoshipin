//
//  UPImageFilterView.h
//  Up
//
//  Created by sup-mac03 on 15/3/20.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPImageFilterView;

@protocol UPImageFilterViewDelegate <NSObject>

- (void)upImageFilterViewCloseBtnDidClicked;
- (void)upImageFilterView:(UPImageFilterView *)filterView didFilterdImage:(UIImage *)image;

@end

@interface UPImageFilterView : UIView

@property (nonatomic, weak) id<UPImageFilterViewDelegate>delegate;
@property (nonatomic, strong) UIImage *sourceImage;

- (void)closeView;
@end
