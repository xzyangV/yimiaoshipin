//
//  SecondBusinessDefine.h
//  一秒视频UP
//
//  Created by uper on 16/5/11.
//  Copyright © 2016年 uper. All rights reserved.
//

#ifndef SecondBusinessDefine_h
#define SecondBusinessDefine_h

typedef void (^ExecCompletedBlock) (BOOL isSuccess, NSString *errorStr);
typedef void (^ExecCompletedResultBlock) (BOOL isSuccess, id result, NSString *errorStr);
typedef void (^ExecVoidBlock)();

typedef void (^ExecAlertCompletedResultBlock) (BOOL cancelled, NSInteger buttonIndex);

// 终端类型
typedef enum : NSInteger {
    ClientTypeIphone=0,
    ClientTypeAndroid=1
}ClientType;

//接口

static NSString * const kgetMusicInfosList = @"/osv/f/app/getMusicInfos";//配乐列表

static NSString * const kupdateDeviceInfo = @"/osv/f/app/updateDeviceInfo";//更新用户设备信息

static NSString * const kgetGlobalParams = @"/osv/f/app/getGlobalParams";//App全局参数

static NSString * const kgetUploadToken = @"/osv/f/file/getUploadToken";//获取上传七牛的token

static NSString * const ksubmitUploadResult = @"/osv/f/file/submitUploadResult";//将从七牛获得的视频地址传回服务器
//NSUserDefaults字段保存


//字体颜色
#define kBarBtnFont [UIFont systemFontOfSize:15]
#define kBarTitleFont [UIFont systemFontOfSize:15]
#define kBarBtnFontColor ColorForHex(0x3365fd)//ColorForRGB(255, 255, 255, 1)
#define kBarBtnFontHColor ColorForHexAlpha(0x3365fd, 0.5)//ColorForRGB(255, 255, 255, 0.5)
#define kMainTitleTitleColor ColorForRGB(0, 97, 137, 1)
#define kTabBarBackgroundColor [UIColor blackColor]


#define kStayTime 1.0
#define kAllTwitterInputCount 70


#define kWhiteCloseBtnImage [UIImage imageNamed:@"white_close"]
// 播放按钮
#define kVideoPlayIcon60 [UIImage imageNamed:@"videoPlayIcon60.png"]
#define kVideoPlayIcon80 [UIImage imageNamed:@"videoPlayIcon80.png"]
#define kVideoPlayIcon100 [UIImage imageNamed:@"videoPlayIcon100.png"]

#define kShareToSNSDefaultLinkUrl @"http://mupup.com"
#define kChannelStatistic @"ChannelStatistic"
#define kFinishResignPushNotification  @"FinishResignPushNotification"
#define kNotificationQiNiuCanacelUpload @"kNotificationQiNiuCanacelUpload"
#define kRecordVideoCompressRatio AVAssetExportPresetMediumQuality

#endif /* SecondBusinessDefine_h */
