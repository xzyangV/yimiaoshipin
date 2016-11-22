//
//  DBManager.m
//  
//
//  Created by zhangyx on 2/22/12.
//  Copyright (c) 2012 sub. All rights reserved.
//

#import "DBManager.h"
#import "SqliteConstantsDetined.h"

static DBManager *singletonInstance = nil;

@implementation DBManager
@synthesize db;
@synthesize gloubDB;


+(void)initialize{
    static BOOL initialized = NO;
    if (!initialized) {
        singletonInstance = [[DBManager alloc]init];
    }
}

+(DBManager *)getInstance {
    
    return singletonInstance;
}

#pragma mark
#pragma mark get db

- (FMDatabase *)getAccountDb {

    return self.db;
}
-(FMDatabase *)getGloubalDB{
    return self.gloubDB;
}

#pragma mark -
#pragma mark  openDb methods

- (void)openDb:(NSString *)databaseFileFullName {
	
//	db = [[FMDatabase alloc] initWithPath:databaseFileFullName];
    self.db = [FMDatabase databaseWithPath:databaseFileFullName];
	if (![db open]) {
		NSLog(@"Database open failed!");
	}
}

- (void)openGloubDb:(NSString *)gloubDataBaseFile {
    
    self.gloubDB = [FMDatabase databaseWithPath:gloubDataBaseFile];

	if (![self.gloubDB open]) {
		NSLog(@"Database open failed!");
	}	
}

#pragma mark -
#pragma mark database utils

- (NSString *)getDatabaseFileFullName {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDbFileName];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:dataPath]) {
		NSError *err;
		BOOL ret = [fm createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
	}
	return dataPath;
}

#pragma mark 
#pragma mark Gloub db path

- (void)createGlobalDatabaseFile {
	
    // 获取数据库缓存路径
	NSString *databaseFilename = [self getDatabaseFileFullName];
    // 获取数据库完整路径
	NSString *realPath = [NSString stringWithFormat:@"%@%@%@",databaseFilename,@"/",kGlobalDatabase];
    //	NSLog(@"realPath = %@", realPath);
    // 文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	BOOL success = [fileManager fileExistsAtPath:realPath];
    
    // 判断路径是否存在
	if (!success) {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kGlobalDatabase];
		NSError *error = nil;
		success = [fileManager copyItemAtPath:defaultDBPath toPath:realPath error:&error];
		if (!success) {
			NSLog(@"Failed to create database file with message: %@", [error localizedDescription]);
		}
	}
	// 打开数据库
	[self openGloubDb:realPath];
}

#pragma mark 
#pragma mark user db path
- (void)createUserDatabaseFile:(NSString *)userAccount {
	
	NSString *databaseFilename = [self getDatabaseFileFullName];
    //	NSLog(@"databaseFilename = %@",databaseFilename);
	NSString *realPath = [NSString stringWithFormat:@"%@%@%@%@",databaseFilename,@"/",userAccount,@".sqlite"];
	NSLog(@"realPath = %@", realPath);
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	BOOL success = [fileManager fileExistsAtPath:realPath];
    /*
	if (!success) {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseFilename];

		NSError *error = nil;
		success = [fileManager copyItemAtPath:defaultDBPath toPath:realPath error:&error];
		if (!success) {
			NSLog(@"Failed to create database file with message: %@", [error localizedDescription]);
		}
//		NSError *err;
//		BOOL ret = [fileManager createDirectoryAtPath:realPath withIntermediateDirectories:YES attributes:nil error:&err];
//		NSLog(@"%d",ret);
	}
     */
	// 打开数据库
	[self openDb:realPath];
}

// 获取cacheDic根目录
- (NSString *)getCachesDirectoryPath
{
    NSArray *cacheDicPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheMainPath = [cacheDicPathList objectAtIndex:0];
    return cacheMainPath;
}


// 获取图片缓存路径
- (NSString *)getCacheImagesFilePath {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDbFileName_image];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:dataPath]) {
		NSError *err;
		BOOL ret = [fm createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
	}
	return dataPath;
}

// 获取文件缓存路径
- (NSString *)getCacheFilePath {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kFilesData];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:dataPath]) {
		NSError *err;
		BOOL ret = [fm createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
	}
	return dataPath;
}

// 获取指定文件夹缓存路径
- (NSString *)getCacheFolderPathWithFolderName:(NSString *)folder
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:dataPath]) {
		NSError *err;
		BOOL ret = [fm createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
	}
    
	return dataPath;
}

// 判断制定缓存文件是否存在
- (BOOL)isExistFilePath:(NSString *)filePath
{
 	NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

// 删除指定路径文件
- (void)deleteWithFilePath:(NSString *)filePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    // 是否存在
    BOOL isExistsOk = [fm fileExistsAtPath:filePath];
    
    if (isExistsOk) {
        [fm removeItemAtPath:filePath error:nil];
//        NSLog(@"file deleted:%@",filePath);
    }
    else {
//        NSLog(@"file not exists:%@",filePath);
    }
    
}

// 获取sever ip
- (NSString *)serverConfig {
    
    NSString *returnString = nil;
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"ServerConfig" ofType:@"plist"];
    NSDictionary *serverConfig = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
    if (serverConfig != nil) {
        NSString *serverIP = [serverConfig objectForKey:@"serverIP"];
        NSString *serverPort = [serverConfig objectForKey:@"serverPort"];
        NSString *appPath = [serverConfig objectForKey:@"appPath"];
        
//        returnString = [[serverIP stringByAppendingString:serverPort] stringByAppendingString:appPath];
        
        if (serverPort == nil || [serverPort isEqualToString:@""]) {
            returnString = [NSString stringWithFormat:@"%@%@",serverIP,appPath];
        }
        else {
            returnString = [NSString stringWithFormat:@"%@:%@%@",serverIP,serverPort,appPath];
        }
        
    }

    if (returnString == nil) {
        returnString = @"";
    }
    return returnString;
}

@end
