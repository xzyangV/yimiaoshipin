//
//  UserInfo.h
//  TestShareDemo
//
//  Created by EdwardShao on 4/20/13.
//  Copyright (c) 2013 zhangyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareTypeDef.h"

@interface ShareUserInfo : NSObject

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *upID;
@property (nonatomic,assign) NSInteger gender;                  // 0 男 1 女 2 未知
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) UIImage *userHeadImg;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *verify;
@property (nonatomic,assign) NSInteger verifyType;
@property (nonatomic,assign) NSInteger fansCount;
@property (nonatomic,assign) NSInteger idolCount;
@property (nonatomic,assign) NSInteger statusCount;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,strong) NSString *education;
@property (nonatomic,strong) NSString *school;
@property (nonatomic,strong) NSString *career;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,assign) ShareType type;
@property (nonatomic,assign) BOOL isVerified;                   // 是否认证
@property (nonatomic,strong) NSString *verified_info;           // 认证信息

// ui 使用
@property (nonatomic,assign) BOOL isSelectedCancelBtn; // 选择了取消按钮


+ (NSArray *)getPostParameterSnsUserList:(NSArray *)snsUserList;


@end
