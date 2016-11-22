//
//  TTimer.h
//  Up
//
//  Created by amy on 13-11-7.
//  Copyright (c) 2013年 amy. All rights reserved.
//
//  仿Delphi的TTimer类实现的时间控件

#import <Foundation/Foundation.h>

@interface TTimer : NSObject

+ (id)timerWithTarget:(id)target action:(SEL)action timerInterval:(NSTimeInterval)timerInterval;
- (id)initWithTarget:(id)target action:(SEL)action timerInterval:(NSTimeInterval)timerInterval;

//default NO
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@end
