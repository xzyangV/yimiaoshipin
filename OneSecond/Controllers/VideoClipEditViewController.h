//
//  VideoClipEditViewController.h
//  Up
//
//  Created by sup-mac03 on 16/4/12.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "ParentViewController.h"

@class VideoObject;

@protocol VideoClipEditViewControllerDelegate <NSObject>

- (void)videoClipEditViewControllerDidCancelEdit;
- (void)videoClipEditViewControllerDidDoneEdit;

@end

@interface VideoClipEditViewController : ParentViewController

@property (nonatomic, strong) VideoObject *videoObject;
@property (nonatomic, weak) id <VideoClipEditViewControllerDelegate> delegate;

@end
