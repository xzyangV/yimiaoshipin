//
//  RemoveSongTableViewCell.h
//  OneSecond
//
//  Created by uper on 16/5/23.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicObject.h"
typedef void(^noMusicBlock)(MusicObject *musicObject);

@interface RemoveSongTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *noSongLabel;
@property (nonatomic, strong) noMusicBlock noMusicBlock;

@end
