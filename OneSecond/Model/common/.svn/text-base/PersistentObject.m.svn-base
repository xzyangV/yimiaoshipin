//
//  PersistentObject.m
//  Up
//
//  Created by An Mingyang on 13-1-19.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//

#import "PersistentObject.h"
#import "PersistentObjectList.h"
#import <objc/runtime.h>

#define kTypeNSString @"NSString"
#define kTypeNSNumber @"NSNumber"

//缓存类的属性 名称 和 类型
static NSMutableDictionary *kSharedClassNameDict = nil;
static NSMutableDictionary *kSharedClassTypeDict = nil;

@interface PersistentObject ()
{
    NSDictionary *_keyMapping;
}

//属性的名称数组
@property (nonatomic, retain) NSArray *propertyNameArray;
//属性的类型数组
@property (nonatomic, retain) NSArray *propertyTypeArray;

@end

@implementation PersistentObject

+ (NSDictionary *)keyMapping
{
    return nil;
}

+ (instancetype)persistentObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (id)init
{
    self = [super init];
    if (self) {
        _keyMapping = [self.class keyMapping];
        
        // 获得属性名称和属性类型
        [self buildPropertyNameAndType];
        
        // 初始化全部属性 如果不给初始值,转成字典数据为空值保存时会失败
        [self propertyInit];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        [self setValuesForDictionary:dict];
    }
    return self;
}

- (NSMutableDictionary *)dictionaryWithAllValue
{
    // 递归写入字典
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    for (int i =0; i < self.propertyNameArray.count; i++) {
        NSString *propertyName = [self.propertyNameArray objectAtIndex:i];
        NSString *propertyType = [self.propertyTypeArray objectAtIndex:i];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue == nil || propertyValue == [NSNull null]) {
            continue;
        }
        Class aClass = NSClassFromString(propertyType);
        
        if (aClass == [UIImage class]) {//不写入图片类型
            continue;
        }

        if ([aClass isSubclassOfClass:[PersistentObject class]]) {
            [resultDict setObject:[propertyValue dictionaryWithAllValue] forKey:propertyName];
        }
        else if ([aClass isSubclassOfClass:[PersistentObjectList class]]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (id subObject in [propertyValue objectArray])
                [tempArray addObject:[subObject dictionaryWithAllValue]];
            [resultDict setObject:tempArray forKey:propertyName];
        }
        else {
            [resultDict setObject:propertyValue forKey:propertyName];
        }
    }
    return resultDict;
}

- (void)setValuesForDictionary:(NSDictionary *)aDictionary
{
/*  系统的方法[self setValuesForKeysWithDictionary:aDictionary] 
    如果传入的字典的key的值在当前对象的属性中不存在,则会出错.
 */
    if (aDictionary == nil || aDictionary.allKeys.count == 0 ||
            self.propertyNameArray.count != self.propertyNameArray.count)
        return;

    for (int i = 0; i < self.propertyNameArray.count; i++) {
        NSString *propertyName = [self.propertyNameArray objectAtIndex:i];
        NSString *propertyType = [self.propertyTypeArray objectAtIndex:i];
        
        // 查找属性名称在字典中是否存在
        id propertyValue = nil;
        NSString *mappingName = nil;
        if (_keyMapping && _keyMapping.count > 0) {
            mappingName = [_keyMapping objectForKey:propertyName];
        }
        if (mappingName) {
            @try {
                propertyValue = [aDictionary valueForKeyPath:mappingName];
            }
            @catch (NSException *exception) {
                propertyValue = nil;
            }
        }
        else {
            propertyValue = [aDictionary objectForKey:propertyName];
        }

        if (!propertyValue) {
            continue;
        }
        
        //设置属性的值
        Class aClass = NSClassFromString(propertyType);

        //JSON是字典并且对象是PersistentObject类型
        if ([propertyValue isKindOfClass:[NSDictionary class]] &&
            [aClass isSubclassOfClass:[PersistentObject class]])
        {
            PersistentObject *subObject = [[aClass alloc] init];
            [subObject setValuesForDictionary:propertyValue];
            [self setValue:subObject forKey:propertyName];
        }
        //JSON是数组
        else if ([propertyValue isKindOfClass:[NSArray class]])
        {
            if ([aClass isSubclassOfClass:[PersistentObjectList class]]) {
                PersistentObjectList *subList = [[aClass alloc] init];
                if ([subList persistentObjectClass] != NULL) {
                    [subList setObjectListForArray:propertyValue];
                }
                [self setValue:subList forKey:propertyName];
            }
            else if ([aClass isSubclassOfClass:[NSArray class]]) {
                [self setValue:propertyValue forKey:propertyName];
            }
        }
        else {
            if ([aClass isSubclassOfClass:[NSString class]]) {
                if ([propertyValue isKindOfClass:[NSString class]]) {
                    [self setValue:propertyValue forKey:propertyName];
                }
                else if ([propertyValue isKindOfClass:[NSNumber class]]) {
                    [self setValue:[NSString stringWithFormat:@"%@",propertyValue] forKey:propertyName];
                }
                else {
                    [self setValue:@"" forKey:propertyName];
                }
//                [self setValue:[propertyValue isKindOfClass:[NSString class]] ? propertyValue : @"" forKey:propertyName];
            }
            else if ([aClass isSubclassOfClass:[NSNumber class]]) {
                if ([propertyValue isKindOfClass:[NSNumber class]]) {
                    [self setValue:propertyValue forKey:propertyName];
                }
                else if ([propertyValue isKindOfClass:[NSString class]]) {
                    [self setValue:propertyValue forKey:propertyName];
                }
                else {
                    [self setValue:@(0) forKey:propertyName];
                }
//                [self setValue:[propertyValue isKindOfClass:[NSNumber class]] ? propertyValue : @(0) forKey:propertyName];
            }
        }
    }
}


- (NSString *)defaultFilePathForFileName:(NSString *)fileName
{
    if (fileName == nil)
        fileName = NSStringFromClass([self class]);
        return [[PublicObject systemDocumentPath] stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%@.plist", fileName]];
}

- (void)loadFromFile:(NSString *)fileName
{
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[self defaultFilePathForFileName:fileName]];
    if (dataDict)
        [self setValuesForDictionary:dataDict];
}

- (void)saveToFile:(NSString *)fileName
{
    NSDictionary *dataDict = [self dictionaryWithAllValue];
    if (dataDict) {
        [dataDict writeToFile:[self defaultFilePathForFileName:fileName] atomically:YES];
    }
}

- (NSArray *)propertyNames
{
    return self.propertyNameArray;
}

- (NSArray *)propertyTypes
{
    return self.propertyTypeArray;
}

#pragma mark -
#pragma mark 私有方法
- (void)setStringPropertyValue:(id)strValue
           numberPropertyValue:(id)numValue
            otherPropertyValue:(id)otherValue
{
    if (self.propertyNameArray.count != self.propertyNameArray.count)
        return;
    for (int i = 0; i < self.propertyTypeArray.count; i++) {
        NSString *propertyNameStr = [self.propertyNameArray objectAtIndex:i];
        NSString *propertyTypeStr = [self.propertyTypeArray objectAtIndex:i];
        if (propertyTypeStr.length < 2) {
            continue;
        }
        if ([propertyTypeStr isEqualToString:kTypeNSString])
            [self setValue:strValue forKey:propertyNameStr];
        else if ([propertyTypeStr isEqualToString:kTypeNSNumber])
            [self setValue:numValue forKey:propertyNameStr];
        else
            [self setValue:otherValue forKey:propertyNameStr];
    }
}

- (void)propertyInit
{
    [self setStringPropertyValue:@"" numberPropertyValue:[NSNumber numberWithInt:0] otherPropertyValue:nil];
}

- (void)propertyRelease
{
    [self setStringPropertyValue:nil numberPropertyValue:nil otherPropertyValue:nil];
}

- (void)buildPropertyNameAndType
{
    if (kSharedClassTypeDict == nil)
        kSharedClassTypeDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    if (kSharedClassNameDict == nil)
        kSharedClassNameDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    NSMutableArray *proTypeArray = [kSharedClassTypeDict objectForKey:NSStringFromClass([self class])];
    NSMutableArray *proNameArray = [kSharedClassNameDict objectForKey:NSStringFromClass([self class])];
    // 是否缓存过
    if (proTypeArray && proNameArray) {
        self.propertyNameArray = proNameArray;
        self.propertyTypeArray = proTypeArray;
        return;
    }

    proTypeArray = [NSMutableArray array];
    proNameArray = [NSMutableArray array];
    Class class = [self class];

    while (class != [PersistentObject class]) {
        // 获得所有属性类型名称
        unsigned int nCount = 0;
        objc_property_t *properties = class_copyPropertyList(class, &nCount);
        for (int i = 0; i < nCount; i++) {
            NSString *propertyNameStr = [NSString stringWithUTF8String:property_getName(properties[i])];
            NSString *propertyAttrStr = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
            NSArray *typeArray = [propertyAttrStr componentsSeparatedByString:@","];
            if (typeArray.count < 3)
                continue;
            
            // 判断是否只读
            if ([typeArray containsObject:@"R"])
                continue;
            // 判断是否weak
            if ([typeArray containsObject:@"W"]) {
                continue;
            }
            // 属性类型字符串
            NSString *typeStr = [typeArray objectAtIndex:0];
            
            // 属性类型判断只处理对象类型
            if ([typeStr characterAtIndex:0] == 'T' && [typeStr characterAtIndex:1] == '@') {
                if (typeStr.length == 2)
                    [proTypeArray addObject:@"id"];
                else {
                    NSString *tempStr = [typeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    [proTypeArray addObject:[tempStr substringFromIndex:2]];
                }
                //添加属性名字
                [proNameArray addObject:propertyNameStr];
            }
        }
        free(properties);
        
        // next super class
        class = [class superclass];
    }
    self.propertyNameArray = proNameArray;
    self.propertyTypeArray = proTypeArray;
    [kSharedClassNameDict setObject:proNameArray forKey:NSStringFromClass([self class])];
    [kSharedClassTypeDict setObject:proTypeArray forKey:NSStringFromClass([self class])];
}

@end
