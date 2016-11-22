//
//  ContentToShare.m
//  TestShareDemo
//
//  Created by EdwardShao on 4/20/13.
//  Copyright (c) 2013 zhangyx. All rights reserved.
//

#import "ShareContent.h"


@interface ShareContent () {
    
//    NSURLConnection *connection;
//	NSMutableData *data;
}

@end

@implementation ShareContent


+ (ShareContent *)buildNewsContentObject:(NSString *)title
                             description:(NSString *)description
                                     url:(NSString *)url
                              thumbimage:(UIImage *)thumbImage
                          thumbimageData:(NSData *)thumbImageData
                               mediaType:(PublishContentMediaType)mediaType
{
    ShareContent *publishContent = [[ShareContent alloc] init];
    [publishContent setTitle:title];
    [publishContent setUrl:url];
    [publishContent setDesc:description];
    [publishContent setMediaType:mediaType];
    [publishContent setThumbImage:thumbImage];
    [publishContent setThumbImageData:thumbImageData];

    return publishContent;
}

+ (ShareContent *)buildImageAndTextContentObject:(NSString *)content
                                           image:(UIImage *)image
                                       imageData:(NSData *)imageData
                                       mediaType:(PublishContentMediaType)mediaType
{
    ShareContent *publishContent = [[ShareContent alloc] init];
    [publishContent setContent:content];
    [publishContent setMediaType:mediaType];
    [publishContent setShareImage:image];
    [publishContent setShareImageData:imageData];
    
    return publishContent;
}

+ (NSString *)formatShareURL:(NSString *)work_share_url shareType:(ShareType)type
{
    NSString *formatUrl = kShareToSNSDefaultLinkUrl;
    if (![PublicObject isEmpty:work_share_url]) {
        if (type == ShareTypeFaceBook) {
            formatUrl = [NSString stringWithFormat:@"%@facebook",work_share_url];
        }
        else if (type == ShareTypeTwitter) {
            formatUrl = [NSString stringWithFormat:@"%@twitter",work_share_url];
        }
        else if (type == ShareTypeQQSpace || type == ShareTypeQQ) {
            formatUrl = [NSString stringWithFormat:@"%@qq",work_share_url];
        }
        else if (type == ShareTypeSinaWeibo) {
            formatUrl = [NSString stringWithFormat:@"%@sina",work_share_url];
        }
        else if (type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline) {
            formatUrl = [NSString stringWithFormat:@"%@wx",work_share_url];
        }
    }
    return formatUrl;
}


@end
