//
//  UPJSONKit.m
//  Up
//
//  Created by sup-mac03 on 15/11/5.
//  Copyright © 2015年 amy. All rights reserved.
//

#import "UPJSONKit.h"

@implementation NSString (JSONKitDeserializing)

- (id)objectFromJSONString
{
    return [self objectFromJSONStringWithOptions:kNilOptions];
}
- (id)objectFromJSONStringWithOptions:(NSJSONReadingOptions)options
{
    return [self objectFromJSONStringWithOptions:options error:nil];
}
- (id)objectFromJSONStringWithOptions:(NSJSONReadingOptions)options error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:options error:error];
}

@end

@implementation NSData (JSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData
{
    return [self objectFromJSONDataWithOptions:kNilOptions];
}
- (id)objectFromJSONDataWithOptions:(NSJSONReadingOptions)options
{
    return [self objectFromJSONDataWithParseOptions:options error:nil];
}
- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)options error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:self options:options error:error];
}
@end

#pragma mark Serializing methods

@implementation NSArray (JSONKitSerializing)

- (NSData *)JSONData
{
    return [self JSONDataWithOptions:NSJSONWritingPrettyPrinted error:nil];
}
- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:self options:options error:error];
}
- (NSString *)JSONString
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end

@implementation NSDictionary (JSONKitSerializing)

- (NSData *)JSONData
{
    return [self JSONDataWithOptions:NSJSONWritingPrettyPrinted error:nil];
}

- (NSData *)JSONDataWithOptions:(NSJSONWritingOptions)options error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:self options:options error:error];

}
- (NSString *)JSONString
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end


