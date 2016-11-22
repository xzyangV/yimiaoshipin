//
//  VideoDraftViewController.h
//  Up
//
//  Created by sup-mac03 on 16/4/8.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "ParentViewController.h"

@class VideoObject;
@class VideoDraftViewController;

@protocol VideoDraftViewContollerDelegate <NSObject>

- (void)videoDraftViewController:(VideoDraftViewController *)videoDraftController didSelectedVideoObject:(VideoObject *)videoObject;
- (void)videoDraftViewController:(VideoDraftViewController *)videoDraftController didCreatNewVideoObject:(VideoObject *)videoObject;
- (void)videoDraftViewController:(VideoDraftViewController *)videoDraftController willDeleteVideoObject:(VideoObject *)videoObject;

@end

@interface VideoDraftViewController : ParentViewController

@property (nonatomic, weak) id <VideoDraftViewContollerDelegate> delegate;

@end
