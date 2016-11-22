//
//  CameraCoverView.h
//  FirstJJ
//
//  Created by sup-mac03 on 13-9-26.
//  Copyright (c) 2013年 sup-mac03. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CameraCoverTypeVideo,
    CameraCoverTypePhoto,
}CameraCoverType;

@interface CameraCoverView : UIView
{
    BOOL open;
    float _viewHeightDifference;
}
@property (nonatomic, strong) UIImageView *upImageView;
@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, assign) CameraCoverType cameraCoverType;
- (void)startAnimate;

@end
