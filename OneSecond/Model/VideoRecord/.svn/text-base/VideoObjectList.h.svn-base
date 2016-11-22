//
//  VideoObjectList.h
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "PersistentObjectList.h"

@class VideoObject;
@interface VideoObjectList : PersistentObjectList

+ (instancetype)sharedVideoList;

- (VideoObject *)videoObjectWithVideoID:(NSString *)videoID;
- (void)saveVideoObject:(VideoObject *)videoObject;
- (BOOL)isExistVideoObject:(VideoObject *)videObject;
- (void)addVideoObject:(VideoObject *)videoObject;
- (void)deleteVideoObject:(VideoObject *)videoObject;
- (void)updateVideObject:(VideoObject *)videoObject;

@end
