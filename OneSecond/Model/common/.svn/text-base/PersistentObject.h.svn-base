//
//  PersistentObject.h
//  Up
//
//  Created by An Mingyang on 13-1-19.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//

/*  持久化对象基类
    实现了类的属性与字典的相互转换
    init时自动初始化非assign非readonly的对象，NSString类型为空字符串，NSNumber为0，其它对象为nil
    dealloc时自动释放非assign非readonly的对象
 */

#import <Foundation/Foundation.h>

@interface PersistentObject : NSObject

+ (NSDictionary *)keyMapping;

+ (instancetype)persistentObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

//返回对象的所有属性的值给字典
- (NSMutableDictionary *)dictionaryWithAllValue;
//将字典的值赋值给对象的所有属性 用来拟补系统的setValuesForKeysWithDictionary方法的不足 该方法不检查属性是否存在
- (void)setValuesForDictionary:(NSDictionary *)aDictionary;

//持久化数据 fileName为nil时文件名默认为"类名.plist" 根目录为NSCachesDirectory
- (void)loadFromFile:(NSString *)fileName;
- (void)saveToFile:(NSString *)fileName;

- (void)propertyInit;

@property (nonatomic, readonly, retain) NSArray *propertyNames;
@property (nonatomic, readonly, retain) NSArray *propertyTypes;

@end
