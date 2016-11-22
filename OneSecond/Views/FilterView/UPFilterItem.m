//
//  UPFilterItem.m
//  Up
//
//  Created by sup-mac03 on 15/3/20.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPFilterItem.h"
#import "UPImageFilter.h"

#define kSelectedIconSize 18
#define kSampleImageSize CGSizeMake(20.f, 20.f)
#define kItemHeight 60

//#define kTitleBGImage [UIImage imageNamed:@"filter_title_bg"]
//#define kTitleBGImageH [UIImage imageNamed:@"filter_title_bgH"]

@interface UPFilterItem ()
{
//    UIImageView *_sampleImageView;
    UIImageView *_titleBGImageView;
    UILabel *_titleLabel;
}
@end

@implementation UPFilterItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//ColorForHex(0x2e99e7);
        
        _titleBGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, kItemHeight)];
        _titleBGImageView.backgroundColor = [UIColor clearColor];
        _titleBGImageView.layer.cornerRadius = 5.0;
        _titleBGImageView.layer.masksToBounds = YES;
        [self addSubview:_titleBGImageView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleBGImageView.bottom+2, self.width, 11)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:11.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setFilterInfo:(NSDictionary *)filterInfo
{
    if (_filterInfo != filterInfo) {
        _filterInfo = filterInfo;
    }
    _titleLabel.text = [filterInfo objectForKey:UPFILTER_NAME];
    _titleBGImageView.image = [UIImage imageNamed:[_filterInfo objectForKey:UPFILTER_IMAGE]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _titleBGImageView.layer.masksToBounds = YES;
        _titleBGImageView.layer.cornerRadius = 5.0f;
        _titleBGImageView.layer.borderWidth = 2.0f;
        _titleBGImageView.layer.borderColor = ColorForHex(0xffffff).CGColor;
    }
    else {
        _titleBGImageView.layer.borderWidth = 0;
        _titleBGImageView.layer.borderColor = nil;
    }

}

@end
