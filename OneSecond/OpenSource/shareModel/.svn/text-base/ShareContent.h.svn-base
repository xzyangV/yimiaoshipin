//
//  ContentToShare.h
//  TestShareDemo
//
//  Created by EdwardShao on 4/20/13.
//  Copyright (c) 2013 zhangyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareEventHandlerDef.h"

@interface ShareContent : NSObject

@property (nonatomic,strong) NSString *title;           // 标题
@property (nonatomic,strong) NSString *desc;            // 描述
@property (nonatomic,strong) NSString *content;         // 内容
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,strong) NSData *shareImageData;
@property (nonatomic,strong) NSString *thumbImagePath;  // 目前暂时 只有分享到微信用到
@property (nonatomic,strong) UIImage *thumbImage;
@property (nonatomic,strong) NSData *thumbImageData;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) PublishContentMediaType mediaType;
@property (nonatomic,copy) GetImageData imageDataResult;


//- (void)getImageData:(NSString *)image_path result:(GetImageData)result;


+ (ShareContent *)buildNewsContentObject:(NSString *)title
                             description:(NSString *)description
                                     url:(NSString *)url
                              thumbimage:(UIImage *)thumbImage
                          thumbimageData:(NSData *)thumbImageData
                               mediaType:(PublishContentMediaType)mediaType;

+ (ShareContent *)buildImageAndTextContentObject:(NSString *)content
                                           image:(UIImage *)image
                                       imageData:(NSData *)imageData
                                       mediaType:(PublishContentMediaType)mediaType;

+ (NSString *)formatShareURL:(NSString *)work_share_url shareType:(ShareType)type;

@end
