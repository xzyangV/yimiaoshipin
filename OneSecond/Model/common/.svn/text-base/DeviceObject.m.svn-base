//
//  DeviceObject.m
//  OneSecond
//
//  Created by 杨晓周 on 16/5/30.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "DeviceObject.h"
#import "PosterTopicList.h"
static DeviceObject *sharedDeviceObjectInstance = nil;

@implementation DeviceObject


+ (instancetype)sharedDeviceObject
{
    if (sharedDeviceObjectInstance == nil) {
        sharedDeviceObjectInstance = [[DeviceObject alloc] init];
    }
    return sharedDeviceObjectInstance;
}


+ (void)appupdateTimestamp
{
    NSTimeInterval tiemInter = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%d",(int)tiemInter];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:timeStr forKey:@"timestamp"];
    [dict setValue:[PublicObject getLocalVerson] forKey:@"app_version"];
    
    NSDictionary *formatParam = [PublicObject formatParameters:dict firstKey:@"timestamp" secondKey:@"app_version"];
    [UPNetworkManager requestWithPath:kgetGlobalParams
                           parameters:formatParam
                    completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (![responseObject isKindOfClass:[NSDictionary class]]) {
                            return;
                        }
                        int code = [[responseObject objectForKey:kUPNetworkKeyCode] intValue];
                        if (code == UPNetworkCodeSuccess)
                        {
                            NSDictionary *dict = [responseObject objectForKey:kUPNetworkKeyData];
                            NSString *banner_list = dict[@"banner_list"];
                            if (![PublicObject isEmpty:banner_list]) {
                                NSData *jsonData = [banner_list dataUsingEncoding:NSUTF8StringEncoding];
                                NSArray *posterArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                       options:NSJSONReadingMutableContainers
                                                                                         error:nil];
                                
                                [[PosterTopicList sharedPosterList] setObjectListForArray:posterArray];
                            }
                           
                            [[DeviceObject sharedDeviceObject] setValuesForDictionary:dict];
                        }
                        else{
                            
                        }
                    }errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@",error.description);
                    }];
    
}
@end
