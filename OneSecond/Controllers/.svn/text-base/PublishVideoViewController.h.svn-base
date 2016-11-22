//
//  PublishVideoViewController.h
//  OneSecond
//
//  Created by uper on 16/5/20.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FinishVideoObject;

typedef enum
{
    PublishOnlySave = 1, //保存
    PublishBothSaveAndShare = 2 //保存/分享
} PublishType;

typedef enum
{
    UploadQualityTypeHeight = 0, //高清
    UploadQualityTypeNormal = 1 //普通
} UploadQualityType;

@interface PublishVideoViewController : UIViewController

@property(nonatomic,strong) FinishVideoObject *finishVideo;
@property(nonatomic,assign) PublishType publishType;
@property(nonatomic,assign) UploadQualityType uploadQualityType;
@property(nonatomic,strong) NSString *finishVideoUrlStr;
@property(nonatomic,strong) NSString *coverImagePath;
@end
