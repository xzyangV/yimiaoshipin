//
//  DBManager.h
//  
//
//  Created by zhangyx on 2/22/12.
//  Copyright (c) 2012 zhangyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBManager : NSObject {
        
    FMDatabase *db;         // 用户数据库
    FMDatabase *gloubDB;    // 全局数据库
}
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) FMDatabase *gloubDB;

// 单例
+(DBManager*)getInstance;
+ (void)initialize;

// 获取数据库缓存文件夹路径
- (NSString *)getDatabaseFileFullName;
// 创建全局数据库完整路径
- (void)createGlobalDatabaseFile;
// 创建用户数据库完整路径
- (void)createUserDatabaseFile:(NSString *)userAccount;
// 获取cacheDic根目录
- (NSString *)getCachesDirectoryPath;
// 获取用户数据库
- (FMDatabase *)getAccountDb;
// 获取全局数据库
- (FMDatabase *)getGloubalDB;
// 获取图片缓存路径
- (NSString *)getCacheImagesFilePath;
// 获取文件缓存路径
- (NSString *)getCacheFilePath;
// 获取指定文件夹缓存路径
- (NSString *)getCacheFolderPathWithFolderName:(NSString *)folder;


// 判断制定缓存文件是否存在
- (BOOL)isExistFilePath:(NSString *)filePath;

// 删除指定路径文件
- (void)deleteWithFilePath:(NSString *)filePath;

// 获取sever ip
- (NSString *)serverConfig;

@end
