//
//  GuideContentView.h
//  Up
//
//  Created by sup-mac03 on 15/12/3.
//  Copyright © 2015年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuideArrowPosition){
    GuideArrowPositionTopLeft,
    GuideArrowPositionTopMiddle,
    GuideArrowPositionTopRight,
    GuideArrowPositionBottomLeft,
    GuideArrowPositionBottomMiddle,
    GuideArrowPositionBottomRight,
    GuideArrowPositionBottomNone
};

typedef NS_ENUM(NSInteger,GuideAlertIconPosition) {
    GuideAlertIconPositionTopMiddle,
    GuideAlertIconPositionBottomMiddle
};

typedef NS_ENUM(NSInteger,GuideContentImagePosition) {
    GuideContentImagePositionNone,
    GuideContentImagePositionRight,
};

@interface GuideContentView : UIView

@property (nonatomic, strong) NSString *guideTitle;
@property (nonatomic, assign) GuideArrowPosition guideArrowPosition;//箭头方向
@property (nonatomic, assign) GuideAlertIconPosition guideAlertIconPosition;//叹号位置
@property (nonatomic, assign) GuideContentImagePosition guideContentImagePosition;//内容图片

@end
