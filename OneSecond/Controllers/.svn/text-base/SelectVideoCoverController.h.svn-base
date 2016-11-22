//
//  PlayViewController.h
//  videoCapture
//
//  Created by zhangyx on 13-8-7.
//  Copyright (c) 2013年 zhangyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ThumbnailPickerView.h"
#import "ParentViewController.h"

@protocol SelectedVideoCover <NSObject>

- (void)selectedVideoCoverWithThumbnail:(UIImage *)thumbnail videoUrl:(NSURL *)videoUrl videoSecond:(double)second;

@end

@interface SelectVideoCoverController : ParentViewController <ThumbnailPickerViewDataSource,ThumbnailPickerViewDelegate>

@property (nonatomic, weak) id<SelectedVideoCover> delegate;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) BOOL needSaveToAlbum;
- (id)initWithFileUrl:(NSURL *)file_url;

@end
  