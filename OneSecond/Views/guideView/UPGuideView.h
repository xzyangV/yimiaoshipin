//
//  UPGuideView.h
//  Up
//
//  Created by sup-mac03 on 14-4-30.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPGuide.h"

@interface UPGuideView : UIView

@property (nonatomic,assign) UPGuideType upGuideType;
@property (nonatomic,assign) UPGuideType currentupGuideType;
@property (nonatomic,strong) UIView *customeView;
@end
