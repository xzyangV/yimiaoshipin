//
//  VideoRecordCreatCell.m
//  Up
//
//  Created by sup-mac03 on 16/4/11.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoRecordCreatCell.h"
#import "VideoObject.h"
#import "VideoClipObject.h"

#define kEditImg [UIImage imageNamed:@"video_record_new"]
#define kCreatNewIcon [UIImage imageNamed:@"video_record_creat"]

@interface VideoRecordCreatCell ()
{
    UIImageView *_iconBgView;
//    UIView *_iconBgView;
    UIImageView *_imgView;
    UIImageView *_editIconImgView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}
@end

@implementation VideoRecordCreatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)defaultHeight
{
    return 110;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
//        _iconBgView = [[UIView alloc] initWithFrame:CGRectZero];
//        _iconBgView.backgroundColor = ColorForHex(0x777777);
//        [self.contentView addSubview:_iconBgView];
        
        _iconBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconBgView.contentMode = UIViewContentModeCenter;
        _iconBgView.backgroundColor = [UIColor clearColor];
        _iconBgView.image = [BizCommon imageWithColor:ColorForHex(0x777777) defaultWidth:110 defaultHeight:110];
        _iconBgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconBgView];
        
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.image = kCreatNewIcon;
        _imgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgView];
        
        _editIconImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _editIconImgView.image = kEditImg;
        _editIconImgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_editIconImgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = SVLocalizedString(@"new", nil);
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        _subTitleLabel.textColor = ColorForHex(0xb2b1b1);
        _subTitleLabel.text = SVLocalizedString(@"A second a lens Can record up to 60 lens", nil);
        [self.contentView addSubview:_subTitleLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleHeight = 20;
    CGFloat subTitleHeight = 15;
    CGFloat labelSpace = 11;
    _iconBgView.frame = CGRectMake(0, 0, 110, 110);
//    _iconBgView.frame = CGRectMake(0, 0, 110, 110);
    _imgView.frame = CGRectMake((_iconBgView.width - kCreatNewIcon.size.width) / 2.f, (_iconBgView.height - kCreatNewIcon.size.height) / 2.f, kCreatNewIcon.size.width, kCreatNewIcon.size.height);
    _editIconImgView.frame = CGRectMake(_iconBgView.right + 20, (self.height - kEditImg.size.height - subTitleHeight - labelSpace) / 2.f, kEditImg.size.width, kEditImg.size.height);
    _titleLabel.frame = CGRectMake(_editIconImgView.right + 5, _editIconImgView.top, self.width - _editIconImgView.right - 5, titleHeight);
    _subTitleLabel.frame = CGRectMake(_iconBgView.right + 20, _titleLabel.bottom + labelSpace, self.width - _iconBgView.right - 20, subTitleHeight);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
