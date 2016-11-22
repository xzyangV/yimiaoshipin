//
//  UPNetworkManager.h
//  Up
//
//  Created by amy on 14-5-14.
//  Copyright (c) 2014年 amy. All rights reserved.
//

/**
 网络请求类
 实现功能：
 对AFNetworking库的封装，实现了基本的网络接口请求
 访问接口页面responseObject对象为JSON转换后的字典类型
 访问其它页面responseObject对象为NSData类型
 operation对象包含responseString和responseData方法
 
 未解决的问题：
 下载文件断点续传，由于和MK框架的receiveData方式不同断点续传只能重写或使用某些第三方文件，如：AFDownloadRequestOperation
 对ios7新版Session的支持
 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSUInteger {
    UPNetworkCodeSignError = 97,
    UPNetworkCodeDecryptError = 98,
    UPNetworkCodeLackParameter = 99,
    UPNetworkCodeSuccess = 100,
    UPNetworkCodeRepeatJoinActivity = 4004
} UPNetworkCode;

typedef enum : NSUInteger {
    UPRequestTypePost,
    UPRequestTypeGet
} UPRequestType;

#define kUPNetworkKeyCode @"code"
#define kUPNetworkKeyMessage @"msg"
#define kUPNetworkKeyData @"data"


@interface UPNetworkManager : NSObject

+ (void)notUPServerRequesPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
            completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
                 errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler;

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
            requestType:(UPRequestType)type
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler;
//经常用的
+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler;

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock;

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
          formDataBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock
    uploadProgressBlock:(void (^)(double progress))uploadProgressblock;

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
          formDataBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock
    uploadProgressBlock:(void (^)(double progress))uploadProgressblock
               userInfo:(NSDictionary *)userInfo;

+ (void)requestWithPath:(NSString *)path
             targetPath:(NSString *)targetPath
           shouldResume:(BOOL)shouldResume
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock;

+ (void)requestWithPath:(NSString *)path
             targetPath:(NSString *)targetPath
           shouldResume:(BOOL)shouldResume
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
               userInfo:(NSDictionary *)userInfo;

+ (void)cancelRequestWithPath:(NSString *)path;
+ (void)cancelAllRequest;
+ (void)resetRequestURL;

@end
