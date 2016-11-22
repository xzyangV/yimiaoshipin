//
//  FindPosterHeadView.h
//  Up
//
//  Created by sup-mac03 on 15/9/9.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFindPosterHeadViewHeight kScreenWidth/(1242.f/506.f)//168.f

@class FindPosterHeadView;
@class PosterTopicList;
@class TopicObject;
@class PosterObject;

@protocol FindPosterHeadViewDelegate <NSObject>

- (void)findPosterHeadView:(FindPosterHeadView *)findPosterView didClickedItem:(PosterObject *)posterObject;

@end

@interface FindPosterHeadView : UIView

@property (nonatomic, strong) PosterTopicList *topicList;
@property (nonatomic, weak) id <FindPosterHeadViewDelegate>delegate;
@end
