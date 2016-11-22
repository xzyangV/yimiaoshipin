//
//  MusicObject.h
//  Up
//
//  Created by sup-mac03 on 16/4/15.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "PersistentObject.h"

@class MPMediaItem;
@interface MusicObject : PersistentObject

@property (nonatomic, strong) NSString *url;           // mp3地址
@property (nonatomic, strong) NSString *name;          // 名称
@property (nonatomic, strong) NSString *singer;        // 作者
@property (nonatomic, strong) NSString *icon;           // 封面
@property (nonatomic, strong) NSString *kind;           // 封面
@property (nonatomic, assign) BOOL is_itunes_music;     // 是否是本地音乐

- (NSString *)musicFilePath;

/*
 * @brief 转换model,耗时操作,用时请开多线程解决转化问题
 */
+ (MusicObject *)musicObjectForMediaItem:(MPMediaItem *)mediaItem;
- (BOOL)musicIsExist;
@end
