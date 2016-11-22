//
//  FinishVideoObjectList.m
//  OneSecond
//
//  Created by uper on 16/5/24.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "FinishVideoObjectList.h"
#import "DBManager.h"
@implementation FinishVideoObjectList

+ (instancetype)sharedFinishVideoList
{
    static FinishVideoObjectList *sharedFinishVideoListInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFinishVideoListInstance = [[FinishVideoObjectList alloc] init];
        [sharedFinishVideoListInstance loadFromFile:nil];
    });
    return sharedFinishVideoListInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _persistentObjectClass = [FinishVideoObject class];
    }
    return self;
}

- (void)saveFinishVideoObject:(FinishVideoObject *)finishVideoObject
{
    if (!finishVideoObject) {return;}
    
    if ([self isExistFinishVideoObject:finishVideoObject]) {
        if (finishVideoObject.videoObject.videoClips.count > 0) {
            [self updateFinishVideObject:finishVideoObject];
        }
        else{
            [self deleteFinishVideoObject:finishVideoObject];
        }
    }
    else{
        if (finishVideoObject.videoObject.videoClips.count > 0) {
            [self addFinishVideoObject:finishVideoObject];
        }
    }
}

- (BOOL)isExistFinishVideoObject:(FinishVideoObject *)finishVideoObject
{
    if (!finishVideoObject) {return NO;}
    
    for (FinishVideoObject *finishvideo in self.objectArray) {
        if ([finishvideo.videoId isEqualToString:finishVideoObject.videoId]) {
            return YES;
        }
    }
    return NO;
}

- (void)addFinishVideoObject:(FinishVideoObject *)finishVideoObject
{
    if (!finishVideoObject) {return;}
    [finishVideoObject updateLastModificationTime];
    [self.objectArray insertObject:finishVideoObject atIndex:0];
    [self saveToFile:nil];

}

- (void)deleteFinishVideoObject:(FinishVideoObject *)finishVideoObject
{
    if (!finishVideoObject) {return;}
        [self.objectArray removeObject:finishVideoObject];
        [self saveToFile:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[finishVideoObject finishVideoFilePath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[finishVideoObject coverfinishVideoFilePath] error:nil];

}

- (void)updateFinishVideObject:(FinishVideoObject *)finishVideoObject
{
    if (!finishVideoObject) {return;}
    
    FinishVideoObject *readyUpdageVideo = nil;
    for (FinishVideoObject *video in self.objectArray) {
        if (finishVideoObject.videoId.length > 0 && [video.videoId isEqualToString:video.videoId]) {
            readyUpdageVideo = video;
            break;
        }
    }
    
    if (readyUpdageVideo) {
        [finishVideoObject updateLastModificationTime];
        NSInteger index = [self.objectArray indexOfObject:readyUpdageVideo];
        [self replaceObject:finishVideoObject atIndex:index];
        [self saveToFile:nil];
    }
}




@end
