//
//  PosterTopicList.m
//  Up
//
//  Created by sup-mac03 on 15/9/11.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "PosterTopicList.h"
#import "PosterObject.h"

static PosterTopicList *_posterTopicListInstance = nil;

@implementation PosterTopicList

+ (instancetype)sharedPosterList
{
    static PosterTopicList *instancePosterTopicList = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instancePosterTopicList = [[ PosterTopicList alloc] init];
    });
    return instancePosterTopicList;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _persistentObjectClass = [PosterObject class];
    }
    return self;
    
}

+ (void)getPosterImageWithPosterImageCompleted:(GetPosterImageComplectedBlock)completedBlock
{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"0" forKey:@"user_id"];
//    [dict setValue:[PublicObject getCurrentDate] forKey:@"login_uuid"];
//    NSDictionary *formatParam = [PublicObject formatParameters:dict secondKey:@"login_uuid"];
//    [UPNetworkManager requestWithPath:@"/f/topic/getTopicCategories" parameters:formatParam completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (![responseObject isKindOfClass:[NSDictionary class]]) {
//            if (completedBlock)
//                completedBlock(0);
//            return;
//        }
//        NSString *errorStr = nil;
//        int code = [[responseObject objectForKey:kUPNetworkKeyCode] intValue];
//        if (code == UPNetworkCodeSuccess) {
//            NSDictionary *dataInfo = [responseObject objectForKey:kUPNetworkKeyData];
//            if ([dataInfo isKindOfClass:[NSDictionary class]]) {
//                    NSArray * posterArray = [dataInfo objectForKey:@"poster"];
//                    [[PosterTopicList sharedPosterList] setObjectListForArray:posterArray];
//                
//                if (completedBlock)
//                    completedBlock(1);
//            }
//        }
//        else {
//            errorStr = [responseObject objectForKey:kUPNetworkKeyMessage];
//        }
//    
//    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (completedBlock) {
//            completedBlock(0);
//        }
//    }];
//
    
    
}

@end
