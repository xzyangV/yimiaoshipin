//
//  UIImageView+SDUPCache.h
//  TestSD
//
//  Created by amy on 15/3/31.
//  Copyright (c) 2015年 Up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

/**
    对UIImageView+WebCache的扩展补充
 */
@interface UIImageView (SDUPCache)


- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs;

- (void)cancelCurrentArrayLoad;
- (void)cancelCurrentImageLoad;



- (void)setImageWithURL:(NSURL *)url animated:(BOOL)animated;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animated:(BOOL)animated progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;


- (void)setImageWithURL:(NSURL *)url imageManager:(SDWebImageManager *)imageManager;
- (void)setImageWithURL:(NSURL *)url imageManager:(SDWebImageManager *)imageManager placeholderImage:(UIImage *)placeholder animated:(BOOL)animated cornerRadius:(CGFloat)cornerRadius;
- (void)setImageWithURL:(NSURL *)url imageManager:(SDWebImageManager *)imageManager placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animated:(BOOL)animated cornerRadius:(CGFloat)cornerRadius progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
@end
