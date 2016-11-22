//
//  MusicObject.m
//  Up
//
//  Created by sup-mac03 on 16/4/15.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "MusicObject.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UPDownloadManager.h"

@implementation MusicObject

- (NSString *)musicFilePath
{
    if (self.is_itunes_music) {
        return self.url;
    }
    NSString *musicDor = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Music"];
    BOOL musicPathIsExist =  [[NSFileManager defaultManager] fileExistsAtPath:musicDor];
    if (!musicPathIsExist) {
        NSError *err;
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:musicDor withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ret) {
            NSLog(@"%@",[err description]);
        }
    }
    NSString *mp3File = [musicDor stringByAppendingPathComponent:[self.url lastPathComponent]];
    
    return mp3File;
}


+ (MusicObject *)musicObjectForMediaItem:(MPMediaItem *)mediaItem
{
    MusicObject *musicObj = [[MusicObject alloc] init];
    musicObj.is_itunes_music = YES;
    // 耗时的操作
    // 获取表气
    NSString *soundName = [NSString stringWithFormat:@"  %@  ", [mediaItem valueForProperty:MPMediaItemPropertyTitle]];
    // url
//    NSURL *soundUrl = [NSURL URLWithString:[[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString]];
    musicObj.url = [[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
    musicObj.name = soundName;
    // 封面
//    MPMediaItemArtwork *artwork = [mediaItem valueForProperty: MPMediaItemPropertyArtwork];
//    UIImage *artworkImage = [artwork imageWithSize:self.selectedMusicBtn.frame.size];
    return musicObj;
    
}

- (BOOL)musicIsExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self musicFilePath]];
}

@end
