//
//  RecordVideoButton.h
//  videoRecord
//
//  Created by zhangyx on 13-8-2.
//  Copyright (c) 2013年 田立彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordVideoBtnDelegate;

@interface RecordVideoButton : UIButton

@property (nonatomic,weak) id<RecordVideoBtnDelegate> recordDelegate;

@end

@protocol RecordVideoBtnDelegate <NSObject>

-(void)recordVideoBtn:(RecordVideoButton *)recordBtn recognizer:(UIGestureRecognizer *)recognizer;

@end