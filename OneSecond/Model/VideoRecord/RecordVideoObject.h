//
//  RecordVideoObject.h
//  Up
//
//  Created by zhangyx on 13-8-9.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordVideoObject : NSObject

@property (nonatomic,assign) Float64 startFrame;
@property (nonatomic,assign) CMTime endFrame;


@end
