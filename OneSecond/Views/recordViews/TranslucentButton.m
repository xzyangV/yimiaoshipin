//
//  TranslucentButton.m
//  Up
//
//  Created by amy on 13-10-23.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "TranslucentButton.h"

@interface TranslucentButton ()

@end

@implementation TranslucentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        self.adjustsImageWhenHighlighted = NO;
        [self addTarget:self action:@selector(touchBeginTranslucent) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchEndTranslucent) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchEndTranslucent) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(touchEndTranslucent) forControlEvents:UIControlEventTouchCancel];
    }
    return self;
}

- (void)touchBeginTranslucent
{
    if (self.alpha != 0.5) {
        [UIView animateWithDuration:0.05 animations:^{
            self.alpha = 0.5;
        }];
    }
    
}

- (void)touchEndTranslucent
{
    if (self.alpha != 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }
}

@end
