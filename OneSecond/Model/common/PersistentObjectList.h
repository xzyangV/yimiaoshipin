//
//  PersistentObjectList.h
//  Up
//
//  Created by An Mingyang on 13-1-24.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//

/*  持久化对象数组管理基类
    实现了对数组的封装和json与对象数组的转换
 */

#import <Foundation/Foundation.h>

typedef enum {
    PersistentListRefreshData,
    PersistentListLoadMoreData
} PersistentListOperationType;

typedef void (^PersistentListBlock) (NSInteger aCount, NSString *aError);

@class PersistentObject;
@interface PersistentObjectList : NSObject
{
    //管理的对象的类型，既数组中的对象的类型
    Class _persistentObjectClass;
    //页码1-N
    int _pageNo;
    //刷新数据之前删除所有对象 默认Yes
    BOOL _refreshBeforeRemoveAllObjects;
}

+ (Class)transformedObjectClass;

//创建数据的抽象方法，由子类重写 外部不直接调用
- (void)buildDataWithPageNo:(int)pageNo object:(id)object;

//返回管理对象的类型
- (Class)persistentObjectClass;

//刷新数据 object为刷新条件对象 调用了buildDataWithPageNo方法
- (void)refreshDataWithObject:(id)object completedBlock:(PersistentListBlock)block;
//同上 刷新前是否要清空数据 调用了buildDataWithPageNo方法
- (void)refreshDataWithObject:(id)object clearObjects:(BOOL)clearObjects
               completedBlock:(PersistentListBlock)block;
//加载更多数据 调用了buildDataWithPageNo方法
- (void)loadMoreDataCompletedBlock:(PersistentListBlock)block;

//将数组字典数据转换成对象
- (void)addObjectListForArray:(NSArray *)dictArray;
- (void)setObjectListForArray:(NSArray *)dictArray;
- (void)insertObjectListForArray:(NSArray *)dictArray atIndex:(NSUInteger)index;

//将对象反转成数组
- (NSArray *)arrayWithAllObjectInDictionary;

//数组对象相关操作
- (id)objectAtIndex:(NSUInteger)index;
- (void)clearObjects;
- (void)deleteObjectAtIndex:(NSUInteger)index;
- (void)deleteObject:(id)anObject;
- (void)replaceObject:(PersistentObject *)object atIndex:(NSInteger)index;
- (void)insertObject:(PersistentObject *)object atIndex:(NSUInteger)index;
- (void)addObject:(PersistentObject *)object;

@property (nonatomic, readonly) id firstObject;
@property (nonatomic, readonly) id lastObject;

//取消请求 由子类实现
- (void)cancelRequest;

//对象数组
@property (nonatomic, retain, readonly) NSMutableArray *objectArray;
@property (nonatomic, readonly) NSUInteger count;

//完成加载数据回调
@property (nonatomic, copy) PersistentListBlock completedBlock;

//持久化数据 fileName为nil时文件名默认为"类名.plist" 根目录为NSCachesDirectory
- (void)loadFromFile:(NSString *)fileName;
- (void)saveToFile:(NSString *)fileName;
- (void)deleteFile:(NSString *)fileName;

@end

