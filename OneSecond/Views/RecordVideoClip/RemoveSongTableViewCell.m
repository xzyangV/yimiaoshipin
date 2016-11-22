//
//  RemoveSongTableViewCell.m
//  OneSecond
//
//  Created by uper on 16/5/23.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "RemoveSongTableViewCell.h"

@implementation RemoveSongTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        backView.backgroundColor = ColorForHex(0x1e1d1d);
        [self.contentView addSubview:backView];
        
        UIImage *songImage = [UIImage imageNamed:@"noSong"];
        UIImageView *songImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, (50-songImage.size.height)/2, songImage.size.width, songImage.size.height)];
        songImageView.image = songImage;
        [backView addSubview:songImageView];
        
        _noSongLabel = [[UILabel alloc]initWithFrame:CGRectMake(songImageView.right + 11,0 , 130, 50)];
        _noSongLabel.text = SVLocalizedString(@"no soundtrack", nil);
        _noSongLabel.textAlignment = NSTextAlignmentLeft;
        _noSongLabel.textColor = ColorForHex(0xffffff);
        _noSongLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:_noSongLabel];
        
        UIButton* downLoad = [UIButton buttonWithType:UIButtonTypeCustom];
        downLoad.frame = CGRectMake(kScreenWidth-25-55, 22/2, 55, 28);
        downLoad.backgroundColor = ColorForHex(0xf2e216);
        downLoad.layer.cornerRadius = 13.5;
        downLoad.layer.masksToBounds = YES;
        downLoad.titleLabel.font = [UIFont systemFontOfSize:11];
        [downLoad setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [downLoad setTitle:SVLocalizedString(@"use", nil) forState:UIControlStateNormal];
        [downLoad addTarget:self action:@selector(useNoSong) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:downLoad];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(25, 49, kScreenWidth-50, SINGLE_LINE_WIDTH)];
        line.backgroundColor = ColorForHex(0x303030);
        [backView addSubview:line];
        
    
    }
    return self;
}

- (void)useNoSong{
    MusicObject *musicObject = [[MusicObject alloc]init];
    if (self.noMusicBlock) {
        self.noMusicBlock (musicObject);
    }
}

@end
