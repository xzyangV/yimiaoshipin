//
//  RecordVideoButton.m
//  videoRecord
//
//  Created by zhangyx on 13-8-2.
//  Copyright (c) 2013年 田立彬. All rights reserved.
//

#import "RecordVideoButton.h"
#import "RecordVideoDefine.h"

#define kRecordVideoBtnImage [UIImage imageNamed:@"recordVideoBtn"]
#define kRecordVideoBtnImageHi [UIImage imageNamed:@"recordVideoBtnHi"]

@interface RecordVideoButton() <UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *_longpressGesutre;
}

@property (nonatomic,weak) id delegate;
@property (nonatomic,assign) SEL longPressEvent;


@end

@implementation RecordVideoButton


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
        [self setBackgroundImage:kRecordVideoBtnImage forState:UIControlStateNormal];
        
        // 长按手势
        _longpressGesutre = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleLongpressGesture:)];
        _longpressGesutre.delegate = self;
        // 长按时间为0秒
        _longpressGesutre.minimumPressDuration = 0;
        // 允许15秒中运动
        _longpressGesutre.allowableMovement = 15;
        [self addGestureRecognizer:_longpressGesutre];
    }
    return self;
}

// 长按手势
-(void)handleLongpressGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 开始录制
        [self setBackgroundImage:kRecordVideoBtnImageHi forState:UIControlStateNormal];
    }
    else {
        // 结束录制
        [self setBackgroundImage:kRecordVideoBtnImage forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.recordDelegate respondsToSelector:@selector(recordVideoBtn:recognizer:)]) {
            [self.recordDelegate recordVideoBtn:self recognizer:sender];
        }
    });
}

@end
