//
//  FinishVideoObjectList.h
//  OneSecond
//
//  Created by uper on 16/5/24.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "PersistentObjectList.h"
#import "FinishVideoObject.h"
@interface FinishVideoObjectList : PersistentObjectList


+ (instancetype)sharedFinishVideoList;
- (void)saveFinishVideoObject:(FinishVideoObject *)finishVideoObject;
- (BOOL)isExistFinishVideoObject:(FinishVideoObject *)finishVideoObject;
- (void)addFinishVideoObject:(FinishVideoObject *)finishVideoObject;
- (void)deleteFinishVideoObject:(FinishVideoObject *)finishVideoObject;
- (void)updateFinishVideObject:(FinishVideoObject *)finishVideoObject;

@end
