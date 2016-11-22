//
//  UperAPIResponse.h
//  OneSecond
//
//  Created by sup-mac03 on 16/6/6.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UperAPIResponse : NSObject

//success=1&res_msg=Success
@property (nonatomic, strong) NSString *success;
@property (nonatomic, strong) NSString *res_msg;
@end
