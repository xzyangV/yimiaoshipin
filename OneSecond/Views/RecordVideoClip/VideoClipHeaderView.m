//
//  VideoClipHeaderView.m
//  Up
//
//  Created by uper on 16/4/22.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipHeaderView.h"

@implementation VideoClipHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorForHex(0x1e1d1d);
        
        UIView*  _holdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _holdView.backgroundColor = ColorForHex(0x1e1d1d);
        [self addSubview:_holdView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (30-12)/2, kScreenWidth, _holdView.height)];
        label.text = SVLocalizedString(@"Long press to move video sequence", nil);
        label.textColor = ColorForHex(0x777777);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [_holdView addSubview:label];
        
    }
    return self;
}
@end
