////
//  TTimer.m
//  Up
//
//  Created by amy on 13-11-7.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "TTimer.h"

@interface TTimer ()
{
    id _target;
    SEL _action;
}
@property (nonatomic, strong) NSTimer *timer;
@end


@implementation TTimer

+ (id)timerWithTarget:(id)target action:(SEL)action timerInterval:(NSTimeInterval)timerInterval
{
    TTimer *tTimer = [[TTimer alloc] initWithTarget:target action:action timerInterval:timerInterval];
    return tTimer;
}

- (id)initWithTarget:(id)target action:(SEL)action timerInterval:(NSTimeInterval)timerInterval
{
    self = [super init];
    if (self) {
        _target = target;
        _action = action;
        self.timerInterval = timerInterval;
    }
    return self;
}

- (void)dealloc
{
    _target = nil;
    _action = nil;
    self.enabled = NO;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    if (enabled) {
        if (self.timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_timerInterval
                                                          target:self
                                                        selector:@selector(onTimerChange)
                                                        userInfo:nil
                                                         repeats:YES];
        }
    }
    else {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)onTimerChange
{
    if ([_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:nil];
#pragma clang diagnostic pop

    }
}

@end
