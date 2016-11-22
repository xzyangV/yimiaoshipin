//
//  NSData+AES256.h
//  Up
//
//  Created by amy on 14-5-4.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end
