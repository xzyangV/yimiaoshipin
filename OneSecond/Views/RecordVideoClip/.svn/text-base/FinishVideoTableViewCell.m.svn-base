//
//  FinishVideoTableViewCell.m
//  OneSecond
//
//  Created by uper on 16/5/24.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "FinishVideoTableViewCell.h"

@interface FinishVideoTableViewCell ()
{
    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    UIImageView *_shareImageView;
}
@end

@implementation FinishVideoTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = ColorForHex(0x1e1d1d);
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        _subTitleLabel.textColor = ColorForHex(0xb2b1b1);
        [self.contentView addSubview:_subTitleLabel];
        
        _shareImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shareImageView.backgroundColor = [UIColor clearColor];
        _shareImageView.image = [UIImage imageNamed:@"shareIcon"];
        [self.contentView addSubview:_shareImageView];
        
        
    }
    return self;
}

- (void)setFinishObject:(FinishVideoObject *)finishObject{
    if (_finishObject != finishObject) {
        _finishObject = finishObject;
    }
    [self updataUI];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleHeight = 20;
    CGFloat subTitleHeight = 15;
    CGFloat labelSpace = 11;
    UIImage *shareImage = [UIImage imageNamed:@"shareIcon"];
    _imgView.frame = CGRectMake(0, 0, 110, 110);
      _titleLabel.frame = CGRectMake(_imgView.right + 20, (self.height - titleHeight - subTitleHeight - labelSpace) / 2.f, 60, titleHeight);
    _subTitleLabel.frame = CGRectMake(_imgView.right + 20, _titleLabel.bottom + labelSpace, self.width - _imgView.right - 20, subTitleHeight);
    _shareImageView.frame = CGRectMake(kScreenWidth - 20 - shareImage.size.width, (self.height - shareImage.size.height) / 2-5, shareImage.size.width, shareImage.size.height);
}

- (void)updataUI
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *countStr = [NSString stringWithFormat:@"%@_clips_count",[NSURL fileURLWithPath:[_finishObject finishVideoFilePath].lastPathComponent]];
    _imgView.image = [UIImage imageWithContentsOfFile:[_finishObject coverfinishVideoFilePath]];
    _titleLabel.text = SVLocalizedString(@"Browse", nil);
    _subTitleLabel.text = [NSString stringWithFormat:@"%@ %@   %@-%@",[user objectForKey:countStr],SVLocalizedString(@"a videos", nil),_finishObject.videoObject.createTime,_finishObject.videoObject.lastModificationTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
