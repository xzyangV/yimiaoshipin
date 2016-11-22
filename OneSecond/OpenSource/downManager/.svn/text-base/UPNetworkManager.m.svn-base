//
//  UPNetworkManager.m
//  Up
//
//  Created by amy on 14-5-14.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "UPNetworkManager.h"
#import "AFDownloadRequestOperation.h"
#import "ConfigureObject.h"

@implementation UPNetworkManager

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/", [ConfigureObject upServerHost]]];
}

+ (NSURL *)videoURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/", [ConfigureObject upVideoServerHost]]];
}

+ (AFHTTPResponseSerializer *)responseSerializer
{
    AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:jsonSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];

    jsonSerializer.acceptableContentTypes = contentTypes;
    AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonSerializer]];
    return serializer;
}

static AFHTTPRequestOperationManager *kAFRequestManager = nil;
+ (AFHTTPRequestOperationManager *)sharedRequestManager
{
    if (!kAFRequestManager) {
        kAFRequestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[self baseURL]];
        // 使AFNetworking支持https安全连接
        kAFRequestManager.securityPolicy.allowInvalidCertificates = YES;
        kAFRequestManager.securityPolicy.validatesDomainName = NO;
        kAFRequestManager.responseSerializer = [self responseSerializer];
    }
    return kAFRequestManager;
}

static AFHTTPRequestOperationManager *kAFNotUPServerRequestManager = nil;
+ (AFHTTPRequestOperationManager *)sharedNotUPServerRequestManager
{
    if (!kAFNotUPServerRequestManager) {
        kAFNotUPServerRequestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        kAFNotUPServerRequestManager.responseSerializer = [self responseSerializer];
    }
    return kAFNotUPServerRequestManager;
}


+ (void)notUPServerRequesPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
            completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
                 errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
{
    [[self sharedNotUPServerRequestManager] GET:path parameters:parameters success:completionHandler failure:errorHandler];
}

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
            requestType:(UPRequestType)type
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
{
    if (type == UPRequestTypePost) {
        [self requestWithPath:path parameters:parameters completionHandler:completionHandler errorHandler:errorHandler downloadProgressBlock:NULL];
    }
    else if (type == UPRequestTypeGet) {
        AFHTTPRequestOperationManager *manager = [self sharedRequestManager];
        AFHTTPRequestOperation *op = [manager GET:path
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              if (completionHandler) {
                                                  completionHandler(operation, responseObject);
                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if (![operation isCancelled]) {
//                                                  DDLogError(@"AF path:%@, param:%@, error:%@", path, parameters, error);
                                                  if (errorHandler) {
                                                      errorHandler(operation, error);
                                                  }
                                              }
                                          }];
        [op setShouldExecuteAsBackgroundTaskWithExpirationHandler:NULL];
    }
}


+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
{
    [self requestWithPath:path parameters:parameters completionHandler:completionHandler errorHandler:errorHandler downloadProgressBlock:NULL];
}

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
{
    [self requestWithPath:path parameters:parameters completionHandler:completionHandler errorHandler:errorHandler
    downloadProgressBlock:downloadProgressBlock formDataBlock:NULL uploadProgressBlock:NULL];
}

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
          formDataBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock
    uploadProgressBlock:(void (^)(double progress))uploadProgressblock
{
    [self requestWithPath:path parameters:parameters completionHandler:completionHandler errorHandler:errorHandler downloadProgressBlock:downloadProgressBlock formDataBlock:formDataBlock uploadProgressBlock:uploadProgressblock userInfo:nil];
}

+ (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
          formDataBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock
    uploadProgressBlock:(void (^)(double progress))uploadProgressblock
               userInfo:(NSDictionary *)userInfo
{
    AFHTTPRequestOperationManager *manager = [self sharedRequestManager];
    AFHTTPRequestOperation *op = [manager POST:path parameters:parameters constructingBodyWithBlock:formDataBlock success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionHandler) {
            completionHandler(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //取消请求不回调
        if (![operation isCancelled]) {
//            DDLogError(@"AF path:%@, param:%@, error:%@", path, parameters, error);
            if (errorHandler) {
                errorHandler(operation, error);
            }
        }
    }];
    op.userInfo = userInfo;
    [op setShouldExecuteAsBackgroundTaskWithExpirationHandler:NULL];
    if (uploadProgressblock) {
        [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            uploadProgressblock(totalBytesWritten / (totalBytesExpectedToWrite * 1.0f));
        }];
    }
    
    if (downloadProgressBlock) {
        [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            downloadProgressBlock(totalBytesRead / (totalBytesExpectedToRead * 1.0f));
        }];
    }
}

+ (void)requestWithPath:(NSString *)path
             targetPath:(NSString *)targetPath
           shouldResume:(BOOL)shouldResume
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
{
    [self requestWithPath:path targetPath:targetPath shouldResume:shouldResume completionHandler:completionHandler errorHandler:errorHandler downloadProgressBlock:downloadProgressBlock userInfo:nil];
}

+ (void)requestWithPath:(NSString *)path
             targetPath:(NSString *)targetPath
           shouldResume:(BOOL)shouldResume
      completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completionHandler
           errorHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))errorHandler
  downloadProgressBlock:(void (^)(double progress))downloadProgressBlock
               userInfo:(NSDictionary *)userInfo
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:targetPath shouldResume:YES];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionHandler) {
            completionHandler(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //取消请求不回调
        if (![operation isCancelled]) {
//            DDLogError(@"AF path:%@, targetPath:%@, error:%@", path, targetPath, error);
            if (errorHandler) {
                errorHandler(operation, error);
            }
        }
    }];
    operation.userInfo = userInfo;
    if (downloadProgressBlock) {
        [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            downloadProgressBlock(((float)totalBytesReadForFile) / totalBytesExpectedToReadForFile);
        }];
    }
    
    [[self sharedRequestManager].operationQueue addOperation:operation];
}

+ (void)cancelRequestWithPath:(NSString *)path
{
    NSOperationQueue *queue = [[UPNetworkManager sharedRequestManager] operationQueue];
    for (AFHTTPRequestOperation *operation in [queue operations]) {
        if ([[[[operation request] URL] absoluteString] rangeOfString:path].location != NSNotFound) {
            [operation cancel];
        }
    }
}

+ (void)cancelAllRequest
{
    NSArray *operations = [[[UPNetworkManager sharedRequestManager] operationQueue] operations];
    [operations makeObjectsPerformSelector:@selector(cancel)];
}

+ (void)resetRequestURL
{
    kAFRequestManager = nil;
}

@end
