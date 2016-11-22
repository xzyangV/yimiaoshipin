//
//  RecordVideoDefine.h
//  Up
//
//  Created by zhangyx on 13-8-14.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>

// 可配置参数
#define kAVCaptureSessionPreset AVCaptureSessionPreset640x480//AVCaptureSessionPresetMedium
#define kAudioAssetBitRate 44100
#define kTimeScale [PublicObject isNeedLongTransitionTime] ? 24.0 : 30.0 // 每秒帧数

#define kSeconds 1 //[PublicObject isNeedLongTransitionTime] ? 15.5 : 15.4     // 最大秒数

#define kMixRecordSeconds 0.5                                    // 最少录制时间
#define kMixSegRecordSeconds 1                                // 每段最少录制时间

#define kPreviewWidth [[UIScreen mainScreen] bounds].size.width //320.0f                                    // 摄像画面宽度
#define kPreviewHeight [[UIScreen mainScreen] bounds].size.width //320.0f                                   // 摄像画面高度

#define kFolderName @"recordVideo"                              // document文件夹下 缓存的录制视频文件夹名称
#define kFinishVideoFoldreName @"finishVideo"


#define kMixSecondAlertString [NSString stringWithFormat:@"最短录制%d秒",5]//最短录制%d秒！
//#define kMaxSecondAlertString [NSString stringWithFormat:UPLocalizedString(@"record finished!", nil)]//录制完成！
#define kMaxSecondAlertString UPLocalizedString(@"record finished!", nil)//录制完成！

#define kBackGroundColor ColorForHex(0x1e1d1d)//[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1]
#define kBolderColor [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
