//
//  PosterObject.h
//  Up
//
//  Created by amy on 13-7-9.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "PersistentObject.h"

typedef enum {
    PosterTypeOther = -1,       // 其他
    PosterTypeNone = 0,
} PosterType;

@interface PosterObject : PersistentObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;




- (void)showPostDetailWithRootVC:(UIViewController *)rootViewController;

@end
