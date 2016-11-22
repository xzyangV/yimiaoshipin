//
//  UIImageView+SDUPCache.m
//  TestSD
//
//  Created by amy on 15/3/31.
//  Copyright (c) 2015年 Up. All rights reserved.
//

#import "UIImageView+SDUPCache.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"


@implementation UIImageView (SDUPCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self sd_setImageWithURL:url];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs
{
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}

- (void)cancelCurrentArrayLoad
{
    [self sd_cancelCurrentAnimationImagesLoad];
}

- (void)cancelCurrentImageLoad
{
    [self sd_cancelCurrentImageLoad];
}


#pragma mark - animated

- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated
{
    [self setImageWithURL:url placeholderImage:nil animated:animated];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 animated:animated progress:NULL completed:NULL];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animated:(BOOL)animated progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    __weak typeof(self) wSelf = self;
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (animated && image && cacheType == SDImageCacheTypeNone) {
            CATransition *fadeAnimation = [CATransition animation];
            fadeAnimation.duration = 0.3;
            fadeAnimation.type = kCATransitionFade;
            fadeAnimation.subtype = kCATransitionFromTop;
            [wSelf.layer addAnimation:fadeAnimation forKey:nil];
        }
        if (completedBlock) {
            completedBlock(image, error, cacheType, url);
        }
    }];
}



#pragma mark - imageManager/animated/cornerRadius

- (void)setImageWithURL:(NSURL *)url imageManager:(SDWebImageManager *)imageManager
{
    [self setImageWithURL:url imageManager:imageManager placeholderImage:nil animated:NO cornerRadius:0];
}

- (void)setImageWithURL:(NSURL *)url imageManager:(SDWebImageManager *)imageManager placeholderImage:(UIImage *)placeholder animated:(BOOL)animated cornerRadius:(CGFloat)cornerRadius
{
    [self setImageWithURL:url imageManager:imageManager placeholderImage:placeholder options:0 animated:animated cornerRadius:cornerRadius progress:NULL completed:NULL];
}

- (void)setImageWithURL:(NSURL *)url imageManager:(SDWebImageManager *)imageManager placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animated:(BOOL)animated cornerRadius:(CGFloat)cornerRadius progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    if (imageManager == nil) {
        imageManager = [SDWebImageManager sharedManager];
    }
    [self sd_cancelCurrentImageLoad];    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        // 圆角裁切是否有缓存
        if (cornerRadius > 0) {
            NSString *key = [self cornerImageKeyWithURL:url cornerRadius:cornerRadius];
            if (key) {
                UIImage *cornerImage = [imageManager.imageCache imageFromMemoryCacheForKey:key];
                if (cornerImage) {
                    self.image = cornerImage;
                    [self setNeedsLayout];
                    if (completedBlock) {
                        completedBlock(cornerImage, nil, SDImageCacheTypeMemory, url);
                    }
                    return;
                }
            }
        }
        
        __weak __typeof(self)wself = self;
        __weak SDWebImageManager *wImageManager = imageManager;
        id <SDWebImageOperation> operation = [imageManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                UIImage *resultImage = image;
                if (resultImage) {
                    // 生成圆角图片并缓存至内存
                    if (cornerRadius > 0) {
                        NSString *key = [self cornerImageKeyWithURL:url cornerRadius:cornerRadius];
                        resultImage = [self imageWithRoundedCornerRadius:cornerRadius usingImage:resultImage scale:resultImage.scale];
                        [wImageManager.imageCache storeImage:resultImage forKey:key toDisk:NO];
                    }
                    wself.image = resultImage;
                    [wself setNeedsLayout];
                    
                    // 淡入淡出动画
                    if (animated && resultImage && cacheType == SDImageCacheTypeNone) {
                        CATransition *fadeAnimation = [CATransition animation];
                        fadeAnimation.duration = 0.3;
                        fadeAnimation.type = kCATransitionFade;
                        [wself.layer addAnimation:fadeAnimation forKey:nil];
                    }
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(resultImage, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}


#pragma mark - 圆角相关

- (UIImage *)imageWithRoundedCornerRadius:(float)cornerRadius usingImage:(UIImage *)original scale:(CGFloat)scale
{
    if (!original) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(original.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, original.size.width, original.size.height) cornerRadius:cornerRadius] addClip];
    [original drawInRect:CGRectMake(0, 0, original.size.width, original.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)cornerImageKeyWithURL:(NSURL *)url cornerRadius:(CGFloat)cornerRadius
{
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    if (url) {
        return [NSString stringWithFormat:@"Corner%d%@", (int)cornerRadius, url.absoluteString];
    }
    return nil;
}

@end
