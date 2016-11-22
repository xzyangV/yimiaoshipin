//
//  UPDownloadManager.m
//  Up
//
//  Created by amy on 14-4-24.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "UPDownloadManager.h"
#import "UPNetworkManager.h"
@implementation UPDownloadManager

+ (void)downloadFileWithURLStr:(NSString *)urlStr outputPath:(NSString *)outputPath rewrite:(BOOL)rewrite
               completionBlock:(UPDownloadManagerCompletionBlock)completionBlock
          progressChangedBlock:(UPDownloadManagerProgressChangedBlock)progressChangedBlock
{
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:outputPath]) {
        //重新下载
        if (rewrite) {
            [fm removeItemAtPath:outputPath error:&error];
            if (error) {NSLog(@"remove outputPath error: %@", error);}
        }
        else {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
            return;
        }
    }

    [UPNetworkManager requestWithPath:urlStr targetPath:outputPath shouldResume:YES completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionBlock) {
            completionBlock(YES, nil);
        }
    } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(NO, [error localizedDescription]);
        }
    } downloadProgressBlock:^(double progress) {
        if (progressChangedBlock) {
            progressChangedBlock(progress);
        }
    }];

    /*
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];

    if ([fm fileExistsAtPath:outputPath]) {
        //重新下载
        if (rewrite) {
            [fm removeItemAtPath:outputPath error:&error];
            if (error) {NSLog(@"remove outputPath error: %@", error);}
        }
        else {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
            return;
        }
    }
    
    NSDictionary *headerDict = nil;

    NSString *tempName = [[PublicObject MD5ForString:outputPath] stringByAppendingString:@".tempdl"];
    NSString *tempPath = [[PublicObject systemCachesPath] stringByAppendingPathComponent:tempName];
    
    if ([fm fileExistsAtPath:tempPath]) {
        //重新下载
        if (rewrite) {
            [fm removeItemAtPath:tempPath error:&error];
            if (error) {NSLog(@"remove tempPath error: %@", error);}
        }
        else {
            unsigned long long fileSize = [[fm attributesOfItemAtPath:tempPath error:&error] fileSize];
            if (error) {NSLog(@"attributes path error: %@", error);}

            NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
            headerDict = @{@"Range": headerRange};
        }
    }
    
    MKNetworkEngine *engine = [BizCommon defaultEngine];
    MKNetworkOperation *op = [engine operationWithURLString:urlStr];
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:tempPath append:YES]];
    if (headerDict) {
        [op addHeaders:headerDict];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSError *err = nil;
        [fm moveItemAtPath:tempPath toPath:outputPath error:&err];
        if (error) {NSLog(@"moveItemAtPath path error: %@", err);}
        
        if (completionBlock) {
            completionBlock(YES, NO);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (completionBlock) {
            completionBlock(NO, [error localizedDescription]);
        }
    }];
    
    [op onDownloadProgressChanged:^(double progress) {
        if (progressChangedBlock) {
            progressChangedBlock(progress);
        }
    }];
    [engine enqueueOperation:op];
    
    */
}

+ (void)cancelDownloadWithURLStr:(NSString *)urlStr
{
//    [MKNetworkEngine cancelOperationsContainingURLString:urlStr];
    [UPNetworkManager cancelRequestWithPath:urlStr];
}

@end
