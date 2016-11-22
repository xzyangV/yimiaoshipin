//
//  MusicObjectList.m
//  Up
//
//  Created by sup-mac03 on 16/4/15.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "MusicObjectList.h"
#import "MusicObject.h"
//#import "UserObject.h"


@interface MusicObjectList ()

@property (nonatomic, strong) NSString *next_id;
@end

@implementation MusicObjectList

+ (instancetype)sharedList
{
    static MusicObjectList *instanceMusicList = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instanceMusicList = [[ MusicObjectList alloc] init];
    });
    return instanceMusicList;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _persistentObjectClass = [MusicObject class];
    }
    return self;

}

- (void)buildDataWithPageNo:(int)pageNo object:(id)object
{
    
    if (![PublicObject networkIsReachableForShowAlert:YES]) {
        if (self.completedBlock)
            self.completedBlock(-1, nil);
        return;
    }
    NSString *next_object_id = (pageNo == 1) ? @"" : self.next_id;
    if (next_object_id == nil) {
        next_object_id = @"";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"user_id"];
    [dict setValue:[PublicObject getCurrentDate] forKey:@"login_uuid"];
    [dict setValue:next_object_id forKey:@"next_id"];
    
    NSDictionary *formatParameters = [PublicObject formatParameters:dict secondKey:@"login_uuid"];
    [UPNetworkManager requestWithPath:kgetMusicInfosList parameters:formatParameters completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (self.completedBlock)
                self.completedBlock(-1, nil);
            return;
        }
        NSInteger itemCount = 0;
        
        NSString *errorStr = nil;
        int code = [[responseObject objectForKey:kUPNetworkKeyCode] intValue];
        if (code == UPNetworkCodeSuccess)
        {
            
            NSDictionary *dict = [responseObject objectForKey:kUPNetworkKeyData];

            NSArray *objectArray = [dict objectForKey:@"musicInfos"];
            itemCount = objectArray.count;
            if (itemCount > 0) {
                if (_pageNo == 1) {
                    [self clearObjects];
                }
                [self addObjectListForArray:objectArray];
                _pageNo ++;
                self.next_id = [dict objectForKey:@"next_id"];

            }
        }
        else {
            errorStr = [responseObject objectForKey:kUPNetworkKeyMessage];
            if (pageNo == 1) {
                [self clearObjects];
            }
        }
        if (self.completedBlock)
            self.completedBlock(itemCount, errorStr);
        
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.completedBlock)
            self.completedBlock(-1, kRequestError);
        
    }];


}

@end
