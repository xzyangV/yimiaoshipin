//
//  UperAPI.h
//  OneSecond
//
//  Created by sup-mac03 on 16/6/6.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UperAPIObject;
@class UperAPIResponse;

@protocol UperAPIDelegate <NSObject>

-(void) onResp:(UperAPIResponse*)resp;

@end

@interface UperAPI : NSObject

+ (BOOL) isUperAppInstalled;

+ (BOOL) sendReq:(UperAPIObject *)object;

+ (BOOL) handleOpenURL:(NSURL *) url delegate:(id<UperAPIDelegate>) delegate;

@end
