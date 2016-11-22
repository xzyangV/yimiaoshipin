//
//  UPDownloadManager.h
//  Up
//
//  Created by amy on 14-4-24.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UPDownloadManagerCompletionBlock) (BOOL isSuccess, NSString *errorStr);
typedef void (^UPDownloadManagerProgressChangedBlock) (double progress);


@interface UPDownloadManager : NSObject

+ (void)downloadFileWithURLStr:(NSString *)urlStr outputPath:(NSString *)outputPath rewrite:(BOOL)rewrite
               completionBlock:(UPDownloadManagerCompletionBlock)completionBlock
          progressChangedBlock:(UPDownloadManagerProgressChangedBlock)progressChangedBlock;

+ (void)cancelDownloadWithURLStr:(NSString *)urlStr;
@end
