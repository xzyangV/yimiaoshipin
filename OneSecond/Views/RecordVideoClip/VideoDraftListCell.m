//
//  VideoDraftListCell.m
//  Up
//
//  Created by sup-mac03 on 16/4/11.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoDraftListCell.h"
#import "VideoObject.h"
#import "VideoClipObject.h"
#import "DBManager.h"

#define kEditImg [UIImage imageNamed:@"video_clip_edit"]

@interface VideoDraftListCell ()
{
    UIImageView *_imgView;
    UIImageView *_editIconImgView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}
@end

@implementation VideoDraftListCell

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
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
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
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        _subTitleLabel.textColor = ColorForHex(0xb2b1b1);
        [self.contentView addSubview:_subTitleLabel];
    }
    return self;
}

- (void)setVideoObject:(VideoObject *)videoObject
{
    if (_videoObject != videoObject) {
        _videoObject = videoObject;
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
    
    _imgView.frame = CGRectMake(0, 0, 110, 110);
    _editIconImgView.frame = CGRectMake(_imgView.right + 20, (self.height - titleHeight - subTitleHeight - labelSpace) / 2.f, kEditImg.size.width, kEditImg.size.height);
    _titleLabel.frame = CGRectMake(_editIconImgView.right + 5, _editIconImgView.top, self.width - _editIconImgView.right - 5, titleHeight);
    _subTitleLabel.frame = CGRectMake(_imgView.right + 20, _titleLabel.bottom + labelSpace, self.width - _imgView.right - 20, subTitleHeight);
}

- (void)updataUI
{
    VideoClipObject *videoClip = [self.videoObject.videoClips firstObject];
    if (videoClip.thumbnail) {
        _imgView.image = videoClip.thumbnail;
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (videoClip) {
                UIImage *thumbnailImg = [PublicObject videoThumbnailForLastFrame:NO withVideoUrl:videoClip.videoUrl];
                videoClip.thumbnail = thumbnailImg;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _imgView.image = thumbnailImg;
                });
            }
        });
    }

    _titleLabel.text =  SVLocalizedString(@"Continiu Edit", nil);
    _subTitleLabel.text = [NSString stringWithFormat:@"%lu %@   %@-%@",(unsigned long)_videoObject.videoClips.count,SVLocalizedString(@"a videos", nil),_videoObject.createTime,_videoObject.lastModificationTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
