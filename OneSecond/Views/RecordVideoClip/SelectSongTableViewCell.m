//
//  SelectSongTableViewCell.m
//  Up
//
//  Created by uper on 16/4/15.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "SelectSongTableViewCell.h"
#import "UPDownloadManager.h"
#import "RMDownloadIndicator.h"

@interface SelectSongTableViewCell ()
{
//    UILabel *_songNameLabel;
    UILabel *_autherLabel;
    UIView *_bjView;
    UIView *_line;

    UIImageView *_arrowImageView;
    UILabel *_kindLabel;
    UIButton *_downLoad;
    RMDownloadIndicator *_filledIndicator;
}
@end
@implementation SelectSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 if (self) {
     _bjView = [[UIView alloc] initWithFrame:CGRectZero];
     _bjView.backgroundColor = ColorForHex(0x1e1d1d);
     [self.contentView addSubview:_bjView];
     
     _songNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
     _songNameLabel.backgroundColor = [UIColor clearColor];
     _songNameLabel.font = [UIFont systemFontOfSize:15];
     _songNameLabel.textColor = ColorForHex(0xffffff);
     _songNameLabel.textAlignment = NSTextAlignmentLeft;
     [_bjView addSubview:_songNameLabel];
     
     _line = [[UIView alloc] initWithFrame:CGRectZero];
     _line.backgroundColor = ColorForHex(0x303030);
     [self.contentView addSubview:_line];
     
     _kindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
     _kindLabel.backgroundColor = [UIColor clearColor];
     _kindLabel.font = [UIFont systemFontOfSize:15];
     _kindLabel.textColor = ColorForHex(0xb2b1b1);
     _kindLabel.textAlignment = NSTextAlignmentLeft;
     [_bjView addSubview:_kindLabel];
     
     _filledIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectZero type:kRMClosedIndicator lineWidth:2];
     [_filledIndicator setBackgroundColor:ColorForHex(0x1e1d1d)];
     [_filledIndicator setFillColor:ColorForHex(0xf2e216)];
     [_filledIndicator setStrokeColor:ColorForHex(0xf2e216)];
     _filledIndicator.closedIndicatorBackgroundStrokeColor = ColorForHex(0x777777);
     _filledIndicator.radiusPercent = 0.45;
     [_bjView addSubview:_filledIndicator];
     [_filledIndicator setIndicatorAnimationDuration:1.0];
     _filledIndicator.hidden = YES;
     [_filledIndicator loadIndicator];
     
     _downLoad = [UIButton buttonWithType:UIButtonTypeCustom];
     _downLoad.backgroundColor = ColorForHex(0x1e1d1d);
     _downLoad.layer.cornerRadius = 13.5;
     _downLoad.layer.masksToBounds = YES;
     _downLoad.layer.borderWidth = 1.0f;
     _downLoad.layer.borderColor = ColorForHex(0xf2e216).CGColor;
     _downLoad.titleLabel.font = [UIFont systemFontOfSize:11];
     [_downLoad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [_downLoad setTitle:SVLocalizedString(@"download", nil) forState:UIControlStateNormal];
     [_downLoad addTarget:self action:@selector(downLoadMusic) forControlEvents:UIControlEventTouchUpInside];
     [_bjView addSubview:_downLoad];
    
     
 }
    return self;
}

- (void)prepareForReuse{
    [_downLoad setTitle:nil forState:UIControlStateNormal];
    _songNameLabel.textColor = ColorForHex(0xffffff);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bjView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    _line.frame = CGRectMake(25, 49, kScreenWidth-50, SINGLE_LINE_WIDTH);
    _kindLabel.frame = CGRectMake(25, 0, 35, 50);
    _songNameLabel.frame = CGRectMake(_kindLabel.right + 15, 0, kScreenWidth - 160, 50);
    _downLoad.frame = CGRectMake(kScreenWidth-25-55, 22/2, 55, 28);
    _filledIndicator.frame = CGRectMake(kScreenWidth-25-42, 11, 28, 28);
}

- (void)setMusicObject:(MusicObject *)musicObject{
    if (_musicObject != musicObject) {
        _musicObject = musicObject;
    }
    _songNameLabel.text = [NSString stringWithFormat:@"%@%@",_musicObject.name,_musicObject.singer];
    _kindLabel.text = _musicObject.kind;
    [self updateDownLoadState];
}

- (void)downLoadMusic{
    
    if ([_downLoad.titleLabel.text isEqualToString:SVLocalizedString(@"use", nil)]) {
        if (self.useMusicBlock) {
            self.useMusicBlock (_musicObject);
        }
    }else{
        if (![PublicObject networkIsReachableForShowAlert:YES]) {
            return;
        }
        NSLog(@"开始下载");
        if (_musicObject.url.length > 0) {
            _downLoad.hidden = YES;
            _filledIndicator.hidden = NO;
            [UPDownloadManager downloadFileWithURLStr:_musicObject.url outputPath:[_musicObject musicFilePath] rewrite:NO completionBlock:^(BOOL isSuccess, NSString *errorStr) {
                [self updateDownLoadState];
                NSLog(@"下载完成");
                _filledIndicator.hidden = YES;
                _downLoad.hidden = NO;
                
            } progressChangedBlock:^(double progress) {
                [_filledIndicator updateWithTotalBytes:1 downloadedBytes:progress];
                
            }];
        }

    }
    
    
    
}

- (void)updateDownLoadState{
    if ([_musicObject musicIsExist]) {
        [_downLoad setTitle:SVLocalizedString(@"use", nil) forState:UIControlStateNormal];
        _downLoad.backgroundColor = ColorForHex(0xf2e216);
        _downLoad.titleLabel.font = [UIFont systemFontOfSize:12];
        [_downLoad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }else{
        [_downLoad setTitle:SVLocalizedString(@"download", nil) forState:UIControlStateNormal];
        _downLoad.backgroundColor = ColorForHex(0x1e1d1d);
        _downLoad.layer.borderWidth = 1.0f;
        _downLoad.layer.borderColor = ColorForHex(0xf2e216).CGColor;
        _downLoad.titleLabel.font = [UIFont systemFontOfSize:11];
        [_downLoad setTitleColor:ColorForHex(0xf2e216) forState:UIControlStateNormal];
    }
}
@end
