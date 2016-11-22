//
//  VideoClipEditDragCell.h
//  Up
//
//  Created by sup-mac03 on 16/4/12.
//  Copyright © 2016年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoClipObject;

typedef void(^VideoClipEditDragCellClickDeleteBlock)(VideoClipObject *videoClipObject);

@interface VideoClipEditDragCell : UICollectionViewCell

+ (CGFloat)defaultSize;

@property (nonatomic, strong) VideoClipObject *videoClipObject;
@property (nonatomic, copy) VideoClipEditDragCellClickDeleteBlock deleteBlock;

@end
