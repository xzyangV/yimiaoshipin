//
//  WelcomeObject.h
//  OneSecond
//
//  Created by uper on 16/5/19.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "PersistentObject.h"

@interface WelcomeObject : PersistentObject


@property (nonatomic, strong) NSString *url;           // 视频地址
@property (nonatomic, strong) NSString *imageUrl;          // 背景图片

@end
