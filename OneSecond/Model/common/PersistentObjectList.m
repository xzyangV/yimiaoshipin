//
//  PersistentObjectList.m
//  Up
//
//  Created by An Mingyang on 13-1-24.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//

#import "PersistentObjectList.h"
#import "PersistentObject.h"

#define kHomePageNo 1

@interface PersistentObjectList ()
@property (nonatomic, retain) id filterWhereObject;
@end

@implementation PersistentObjectList

+ (Class)transformedObjectClass
{
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _objectArray = [[NSMutableArray alloc] initWithCapacity:1];
        _pageNo = kHomePageNo;
        _refreshBeforeRemoveAllObjects = YES;
        _persistentObjectClass = [self.class transformedObjectClass];
    }
    return self;
}

- (void)dealloc
{
    self.completedBlock = nil;
}

- (Class)persistentObjectClass
{
    return _persistentObjectClass;
}

- (NSUInteger)count
{
    return self.objectArray.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return self.objectArray[index];
    }
    return nil;
}

- (void)clearObjects
{
    [self.objectArray removeAllObjects];
   
}

- (void)setObjectListForArray:(NSArray *)dictArray
{
    [self clearObjects];
    [self addObjectListForArray:dictArray];
}

- (void)addObjectListForArray:(NSArray *)dictArray
{
    if (dictArray == nil || _persistentObjectClass == NULL)
        return;
    for (id objectDic in dictArray) {
        if ([objectDic isKindOfClass:[NSDictionary class]]) {
            //向上转型 创建_persistentObjectClass类型的对象, _persistentObjectClass的类型需要在子类中指定
            PersistentObject *tempObject = [[_persistentObjectClass alloc] init];
            //设置对象属性的值通过字典
            [tempObject setValuesForDictionary:objectDic];
            //将对象加到数组中
            [self.objectArray addObject:tempObject];
        }
    }
}

- (void)insertObjectListForArray:(NSArray *)dictArray atIndex:(NSUInteger)index
{
    if (dictArray == nil || _persistentObjectClass == NULL)
        return;
    for (int i = (int)dictArray.count - 1; i >= 0; i--) {
        id objectDic = [dictArray objectAtIndex:i];
        if ([objectDic isKindOfClass:[NSDictionary class]]) {
            //向上转型 创建_persistentObjectClass类型的对象, _persistentObjectClass的类型需要在子类中指定
            PersistentObject *tempObject = [[_persistentObjectClass alloc] init];
            //设置对象属性的值通过字典
            [tempObject setValuesForDictionary:objectDic];
            //将对象加到数组中
            [self.objectArray insertObject:tempObject atIndex:0];
        }
    }
}

- (void)loadFromFile:(NSString *)fileName
{
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[self defaultFilePathForFileName:fileName]];
    if (dataArray)
        [self setObjectListForArray:dataArray];
}

- (void)saveToFile:(NSString *)fileName
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:1];
    for (PersistentObject *po in self.objectArray) {
        [dataArray addObject:[po dictionaryWithAllValue]];
    }
    if (dataArray) {
        [dataArray writeToFile:[self defaultFilePathForFileName:fileName] atomically:YES];
    }
}

- (void)deleteFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self defaultFilePathForFileName:fileName]]) {
        NSError *error;
        if (![fileManager removeItemAtPath:[self defaultFilePathForFileName:fileName] error:&error]) {
            NSLog(@"delete file error = %@",error);
        }
    }
}

- (NSArray *)arrayWithAllObjectInDictionary
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (id subObject in self.objectArray)
        [tempArray addObject:[subObject dictionaryWithAllValue]];
    return tempArray;
}

- (NSString *)defaultFilePathForFileName:(NSString *)fileName
{
    if (fileName == nil)
        fileName = NSStringFromClass([self class]);
    return [[PublicObject systemCachesPath] stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.plist", fileName]];
}

- (void)refreshDataWithObject:(id)object completedBlock:(PersistentListBlock)block
{
    [self refreshDataWithObject:object clearObjects:YES completedBlock:block];
}

- (void)refreshDataWithObject:(id)object clearObjects:(BOOL)clearObjects
               completedBlock:(PersistentListBlock)block
{
    self.completedBlock = block;
    self.filterWhereObject = object;
    _pageNo = kHomePageNo;
    
    if (clearObjects && _refreshBeforeRemoveAllObjects) {
        [self clearObjects];
    }
    [self buildDataWithPageNo:_pageNo object:self.filterWhereObject];
}

- (void)loadMoreDataCompletedBlock:(PersistentListBlock)block
{
    self.completedBlock = block;
    
    [self buildDataWithPageNo:_pageNo object:self.filterWhereObject];
//    _pageNo++;   在加载完成后再执行加1操作
}

- (void)buildDataWithPageNo:(int)pageNo object:(id)object
{
    //创建数据的方法，由子类重写完成
}

- (void)deleteObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self.objectArray removeObjectAtIndex:index];
    }
}

- (void)deleteObject:(id)anObject
{
    [self.objectArray removeObject:anObject];
}

- (void)replaceObject:(PersistentObject *)object atIndex:(NSInteger)index
{
    [self.objectArray replaceObjectAtIndex:index withObject:object];
}

- (void)insertObject:(PersistentObject *)object atIndex:(NSUInteger)index
{
    if (object) {
        @try {
            [self.objectArray insertObject:object atIndex:index];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

- (void)addObject:(PersistentObject *)object
{
    [self.objectArray addObject:object];
}

- (id)firstObject
{
    if (self.objectArray.count > 0) {
        return self.objectArray.firstObject;
    }
    return nil;
}

- (id)lastObject
{
    if (self.objectArray.count > 0) {
        return self.objectArray.lastObject;
    }
    return nil;
}

- (void)cancelRequest
{
    
}

@end
