//
//  UINavigationItem+Support_ios7.m
//  Up
//
//  Created by amy on 13-9-28.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "UINavigationItem+Support_ios7.h"

@implementation UINavigationItem (Support_ios7)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = -10;
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
        
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
        
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setRightBarButtonItem:rightBarButtonItem];
    }
}
@end
