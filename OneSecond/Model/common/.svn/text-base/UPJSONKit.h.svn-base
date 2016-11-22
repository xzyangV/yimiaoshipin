//
//  UPJSONKit.h
//  Up
//
//  Created by sup-mac03 on 15/11/5.
//  Copyright © 2015年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Deserializing methods

@interface NSString (JSONKitDeserializing)

- (id)objectFromJSONString;
- (id)objectFromJSONStringWithOptions:(NSJSONReadingOptions)options;
- (id)objectFromJSONStringWithOptions:(NSJSONReadingOptions)options error:(NSError **)error;

@end

@interface NSData (JSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;
- (id)objectFromJSONDataWithOptions:(NSJSONReadingOptions)options;
- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options error:(NSError **)error;
@end


#pragma mark Serializing methods

@interface NSArray (JSONKitSerializing)
- (NSData *)JSONData;
- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;
- (NSString *)JSONString;
@end

@interface NSDictionary (JSONKitSerializing)
- (NSData *)JSONData;
- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error;
- (NSString *)JSONString;
@end
