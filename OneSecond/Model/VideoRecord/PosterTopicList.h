//
//  PosterTopicList.h
//  Up
//
//  Created by sup-mac03 on 15/9/11.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "PersistentObjectList.h"

typedef void (^GetPosterImageComplectedBlock) (BOOL isSuccess);

@interface PosterTopicList : PersistentObjectList

+ (instancetype)sharedPosterList;
+ (void)getPosterImageWithPosterImageCompleted:(GetPosterImageComplectedBlock)completedBlock;
@end
