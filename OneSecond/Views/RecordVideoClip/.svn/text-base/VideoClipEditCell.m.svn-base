//
//  VideoClipEditCell.m
//  Up
//
//  Created by sup-mac03 on 16/4/8.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipEditCell.h"

#define kEditIcon [UIImage imageNamed:@"video_clip_edit"]

@interface VideoClipEditCell ()
{
    UIImageView *_editIcon;
    UILabel *_editLabel;
}
@end

@implementation VideoClipEditCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ColorForHex(0x777777);
        
        CGFloat editIconHeight = kEditIcon.size.height;
        CGFloat editaLabelHeight = 11;
        
        _editIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - kEditIcon.size.width) / 2.f, (self.height - (editIconHeight + editaLabelHeight)) / 2.f,kEditIcon.size.width , kEditIcon.size.height)];
        _editIcon.image = kEditIcon;
        [self addSubview:_editIcon];
        
        _editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _editIcon.bottom, self.width, editaLabelHeight)];
        _editLabel.textAlignment = NSTextAlignmentCenter;
        _editLabel.backgroundColor = [UIColor clearColor];
        _editLabel.font = [UIFont systemFontOfSize:11];
        _editLabel.textColor = [UIColor whiteColor];
        [self addSubview:_editLabel];
        _editLabel.text = SVLocalizedString(@"edit", nil);
    }
    return self;
}


@end
