//
//  UploadVideoWithQiNiuObject.m
//  OneSecond
//
//  Created by uper on 16/5/19.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "SVUploadFileManager.h"
#import "DeviceObject.h"
@implementation SVUploadFileManager

+ (void)uploadFileWithFileURL:(NSString *)filePath
                     fileType:(SVUploadFileType)fileType
                progressBlock:(SVUploadFileProgressBlock)progressBlock
               completedBlock:(SVUploadFileCompletedBlock)completedBlock
{
    [self getQiNiuTokenForFileType:fileType withCompletedBlock:^(NSString *token, NSString *domain,NSString *key_prefix) {
        NSString *fileExtention = fileType == SVUploadFileTypeVideo ? @".mp4" : @".jpg";
        NSString *fileKey = [NSString stringWithFormat:@"%@%@",key_prefix,fileExtention];
        // 错误判断
        if (token.length == 0 || domain.length == 0 || key_prefix.length == 0) {
            if (completedBlock) {
                completedBlock(NO,nil);
            }
            if (progressBlock) {
                progressBlock(0.0001);
            }
            return ;
        }
        
        __block  BOOL isCancel = NO;
        // 开始上传文件
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if ([PublicObject isEmpty:[user objectForKey:kNotificationQiNiuCanacelUpload]]) {
                isCancel = NO;
            }else{
                isCancel = YES;
                [user setObject:@"" forKey:kNotificationQiNiuCanacelUpload];
                [user synchronize];
            }
            
            if (progressBlock) {
                progressBlock(percent);
            }
            
        } params:nil checkCrc:NO cancellationSignal:^BOOL{
            
            return isCancel;
        }];
        
        
        [uploadManager putFile:filePath key:fileKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",domain, resp[@"key"]]];
            if (completedBlock) {
                if (resp) {
                    completedBlock(1,videoUrl);
                }else{
                    completedBlock(0,videoUrl);
                }
            }
            
        }option:uploadOption];
        
    }];
}

// 从一秒视频服务器获取七牛 token 和 domain
+ (void)getQiNiuTokenForFileType:(SVUploadFileType)fileType withCompletedBlock:(void(^)(NSString *token,NSString *domain,NSString *key_prefix))completedBlock
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"user_id"];
    [dict setObject:@(fileType) forKey:@"category"];
    [dict setObject:[PublicObject getCurrentDate] forKey:@"login_uuid"];
    NSDictionary *formatParam = [PublicObject formatParameters:dict secondKey:@"login_uuid"];

    [UPNetworkManager requestWithPath:kgetUploadToken
                           parameters:formatParam
                    completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (completedBlock)
                completedBlock(nil, nil,nil);
            return;
        }
        int code = [[responseObject objectForKey:kUPNetworkKeyCode] intValue];
        if (code == UPNetworkCodeSuccess)
        {
            NSDictionary *dict = [responseObject objectForKey:kUPNetworkKeyData];
            NSString *domain = dict[@"domain_name"];
            NSString *token = dict[@"token"];
            NSString *key_prefix = dict[@"key_prefix"];
            if (completedBlock) {
                completedBlock(token,domain,key_prefix);
            }
        }
        else{
            if (completedBlock) {
                completedBlock(nil,nil,nil);
            }
        }
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completedBlock) {
            completedBlock(nil,nil,nil);
        }
    }];
}

+ (void)setUploadServerResultWithFinishUrl:(NSString *)finishUrl
                              video_length:(float)video_length
                            main_image_url:(NSString *)main_image_url
                          main_image_width:(float)main_image_width
                         main_image_height:(float)main_image_height
                            completedBlock:(SVSetUploadServerResultCompletedBlock)completedBlock
{
    int timelength = (int)(video_length) - 1;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"user_id"];
    [dict setObject:[PublicObject getCurrentDate] forKey:@"login_uuid"];
    [dict setObject:[DeviceObject sharedDeviceObject].device_info_id forKey:@"device_info_id"];
    [dict setObject:finishUrl forKey:@"source_url"];
    [dict setObject:main_image_url forKey:@"main_img_url"];
    [dict setObject:@(timelength) forKey:@"video_length"];
    [dict setObject:@(main_image_width) forKey:@"main_img_width"];
    [dict setObject:@(main_image_height) forKey:@"main_img_height"];
    NSDictionary *formatParam = [PublicObject formatParameters:dict secondKey:@"login_uuid"];
    
    [UPNetworkManager requestWithPath:ksubmitUploadResult
                           parameters:formatParam
                    completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (![responseObject isKindOfClass:[NSDictionary class]]) {
                            if (completedBlock)
                                completedBlock(0, nil,nil);
                            return;
                        }
                        int code = [[responseObject objectForKey:kUPNetworkKeyCode] intValue];
                        if (code == UPNetworkCodeSuccess)
                        {
                            NSDictionary *dict = [responseObject objectForKey:kUPNetworkKeyData];
                            NSString *video_info_id = dict[@"video_info_id"];
                            NSString *share_url  = dict[@"share_url"];
                            if (completedBlock) {
                                completedBlock(1,share_url,video_info_id);
                            }
                        }
                        else{
                            if (completedBlock) {
                                completedBlock(0,nil,nil);
                            }
                        }
                    }errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (completedBlock) {
                            completedBlock(0,nil,nil);
                        }
                    }];

    
    
    
}

+ (void)cancelUploadFileWithFileURL:(NSString *)filePath
                           fileType:(SVUploadFileType)fileType
{
    [self getQiNiuTokenForFileType:fileType withCompletedBlock:^(NSString *token, NSString *domain,NSString *key_prefix) {
        NSString *fileExtention = fileType == SVUploadFileTypeVideo ? @".mp4" : @".jpg";
        NSString *fileKey = [NSString stringWithFormat:@"%@%@",key_prefix,fileExtention];
        // 错误判断
        if (token.length == 0 || domain.length == 0 || key_prefix.length == 0) {
            
            return ;
        }
        
        // 开始上传文件
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:^BOOL{
            return YES;
        }];
        
        [uploadManager putFile:filePath key:fileKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        }option:uploadOption];
        
    }];
}

@end
