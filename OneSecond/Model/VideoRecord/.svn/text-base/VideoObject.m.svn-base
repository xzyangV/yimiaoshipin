//
//  VideoObject.m
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoObject.h"
#import "VideoClipObject.h"
//#import "UserObject.h"
#import "DBManager.h"
#import "VideoObjectList.h"
#import "UIImage+Blur.h"

#define kVideoFormat @"yyyy.MM.dd"

@implementation VideoObject

- (NSInteger)videoClipCount
{
    return self.videoClips.count;
}

+ (instancetype)unFinishedVideoInstance
{
    static VideoObject *unFinishedVideoInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unFinishedVideoInstance = [[VideoObject alloc] init];
        [unFinishedVideoInstance loadFromFile:nil];
    });
    return unFinishedVideoInstance;
}

- (void)deleteUnfinishedVideoInfo
{
    self.videoId = nil;
    self.videoClips = nil;
    self.videoName = nil;
}

- (UIImage *)imageFromLastFrame
{
    VideoClipObject *clip = [self.videoClips lastObject];
    UIImage *lastFrameImage = [PublicObject videoThumbnailForLastFrame:YES withVideoUrl:clip.videoUrl];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lastFrameImage.size.width,lastFrameImage.size.height)];
    aView.backgroundColor = ColorForHexAlpha(0x000000, 0.4);
    
    UIImage *blurImage = [lastFrameImage applyBlurWithRadius:3 tintColor:ColorForHexAlpha(0x000000, 0.3) saturationDeltaFactor:1 maskImage:nil];

    UIImageView *backImageView = [[UIImageView alloc] initWithImage:blurImage];
    backImageView.frame = aView.bounds;
    backImageView.backgroundColor = [UIColor clearColor];
    [aView addSubview:backImageView];
    
    CGFloat textWidth = [PublicObject widthForString:@"one second video" font:[UIFont boldSystemFontOfSize:20]];
    UIImage *lastImage = [UIImage imageNamed:@"endingLogo"];
    UIImageView *lasticonImgView = [[UIImageView alloc] initWithImage:lastImage];
    lasticonImgView.frame = CGRectMake((aView.width - lastImage.size.width * 1.5) / 2.f, (aView.height - lastImage.size.height * 1.5) / 2.f, lastImage.size.width * 1.5, lastImage.size.height * 1.5);
    lasticonImgView.backgroundColor = [UIColor clearColor];
    [aView addSubview:lasticonImgView];
    
    

    UIImage *oneSecondVideIcon = [UIImage imageNamed:@"video_record_endingLogo"];
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:oneSecondVideIcon];
    iconImgView.frame = CGRectMake((aView.width - oneSecondVideIcon.size.width * 2 - 22 - textWidth) / 2.f, (aView.height - oneSecondVideIcon.size.height * 2) / 2.f, oneSecondVideIcon.size.width * 2, oneSecondVideIcon.size.height * 2);
    iconImgView.backgroundColor = [UIColor clearColor];
//    [aView addSubview:iconImgView];

    
    CGFloat enTitleHeight = 20;
    CGFloat cnTitleHeight = 28;
    CGFloat nameLabelHeight = 20;
    CGFloat labelGap = 8;
    CGFloat enTitleLabelY = (aView.height - (enTitleHeight + cnTitleHeight + nameLabelHeight + 2 * labelGap)) / 2.f;
//    UILabel *enTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImgView.right + 10, enTitleLabelY, aView.width / 2.f - 2 * 10, enTitleHeight)];
//    enTitleLabel.backgroundColor = [UIColor clearColor];
//    enTitleLabel.textAlignment = NSTextAlignmentLeft;
//    enTitleLabel.textColor = [UIColor whiteColor];
//    enTitleLabel.font = [UIFont systemFontOfSize:20];
//    [aView addSubview:enTitleLabel];
//    enTitleLabel.text = @"one second video";

    UILabel *cnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImgView.right + 10, enTitleLabelY, aView.width / 2.f - 2 * 10, cnTitleHeight)];
    cnTitleLabel.backgroundColor = [UIColor clearColor];
    cnTitleLabel.textAlignment = NSTextAlignmentLeft;
    cnTitleLabel.textColor = [UIColor whiteColor];
    cnTitleLabel.font = [UIFont boldSystemFontOfSize:48];
//    [aView addSubview:cnTitleLabel];
    cnTitleLabel.text = @"一秒视频";

    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(cnTitleLabel.left, iconImgView.bottom - 22, cnTitleLabel.width, nameLabelHeight)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.textColor = [UIColor whiteColor];
    aLabel.font = [UIFont boldSystemFontOfSize:20];
//    [aView addSubview:aLabel];
    aLabel.text = @"one second video";
//    NSString *userName = [[UserObject loginUserObject] nick_name];
//    aLabel.text = userName.length <= 10 ? userName : [userName substringToIndex:9];
    
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(aView.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return image;

}

+ (instancetype)newVideo
{
    VideoObject *video = [[VideoObject alloc] init];
    video.videoId = [PublicObject generateNoLineUUID];
    video.videoName = [[NSDate date] stringWithFormat:kVideoFormat];
    video.createTime = [[NSDate date] stringWithFormat:kVideoFormat];
    video.lastModificationTime = [[NSDate date] dateString];
    video.videoClips = [[VideoClipObjectList alloc] init];
    return video;
}

- (void)deleteVideoClipObject:(VideoClipObject *)videoClipObject
{
    if (!videoClipObject) {return;}
    
    if ([self.videoClips.objectArray containsObject:videoClipObject]) {
        [self deleteFileWithPath:videoClipObject.videoUrl];
        [self.videoClips deleteObject:videoClipObject];
    }
}

- (void)deleteFileWithPath:(NSString *)filePath
{
    [[DBManager getInstance] deleteWithFilePath:filePath];
}

- (void)updateLastModificationTime
{
    self.lastModificationTime = [[NSDate date] stringWithFormat:kVideoFormat];

}
@end
