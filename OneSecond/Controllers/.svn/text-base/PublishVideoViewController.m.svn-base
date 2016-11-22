//
//  PublishVideoViewController.m
//  OneSecond
//
//  Created by uper on 16/5/20.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "PublishVideoViewController.h"
#import "VideoRecordViewController.h"
#import "FinishVideoObject.h"
#import "ShareObject.h"
#import <AVFoundation/AVFoundation.h>
#import "EventCounting.h"
#import "SVUploadFileManager.h"
#import "UIImageView+WebCache.h"
#import "GiFHUD.h"
#import "UIImage-Extension.h"
#import "UperAPI.h"
#import "UperAPIObject.h"
#import "CustomAlertView.h"
#import "RMDownloadIndicator.h"
#import "Reachability.h"
#import "CMActionSheet.h"
#define KPlayVideoWidth  240
#define KPlayVideoHeight  240
#define imgHeight  40
#define AlertShareViewWidth 240
#define AlertShareViewHeight 240


@interface PublishVideoViewController ()
{
    UIView *_backView;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    UIImageView *_thumbnailImageView;
    UIImageView *_videoPlayMarkView;
    UIButton *_saveToLocal;
    UILabel *_shareToLabel;
    UIView *_shareView;
    UIImageView *_shareImageView;
    UILabel *_shareLabel;
    UILabel *_percentLabel;
    UIView *_alertshareView;
    UIButton * _shareBtn;
    UITapGestureRecognizer *_tapSender;
    UIView * _backgroundView;
    RMDownloadIndicator *_filledIndicator;
    UIImageView *_activityImageView;

}
@property (nonatomic,strong) NSURL *shareFinishVideoUrlStr;
@property (nonatomic,strong) NSURL *shareVideoImageUrlStr;
@property (nonatomic,strong) NSString *share_url;//H5是地址
@property (nonatomic,strong) NSString *normalVideoQualityPath;//普通视频质量存储路径
@end

@implementation PublishVideoViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [self monitorNetState];//启动网络监控
        self.navigationController.navigationBar.barTintColor = ColorForHex(0x1e1d1d);
    }
    return self;
}

//- (void)monitorNetState
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
//     Reachability* hostReach =[Reachability reachabilityForInternetConnection];
//    [hostReach startNotifier]; //开始监听,会启动一个run loop
//}

//- (void)networkStateChange
//{
//    NSLog(@"网络变化了");
//    if (![PublicObject networkIsReachable] && _backgroundView.hidden == NO) {
//        [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:@"当前网络异常" afterDelay:2];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user setObject:@"" forKey:kNotificationQiNiuCanacelUpload];//设此值是为了监控是否取消上传了
//        [user synchronize];
//        _backgroundView.hidden = YES;
//        return;
//    }
//}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorForHex(0x1e1d1d);
    
    [self creatVideoPlayView];

    if (self.publishType == PublishBothSaveAndShare) {
        self.navigationItem.leftBarButtonItem = [BizCommon barBtnWithImage:[UIImage imageNamed:@"closeBtn"] title:nil titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:15] target:self action:@selector(btnCancelClick)];
        self.navigationItem.title = SVLocalizedString(@"save/share", nil);
        [self creatSaveLocalText];
    }
    else{
         self.navigationItem.leftBarButtonItem = [BizCommon barBtnWithImage:[UIImage imageNamed:@"picback"] title:nil titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:15] target:self action:@selector(btnCancelClick)];
        self.navigationItem.title = SVLocalizedString(@"share", nil);
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self creatShareLabel];
    [self creatShareView];
    [self creatUploadView];
    
 
}

#pragma mark  构建视图
//创建上传视图
- (void)creatUploadView
{
    _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.hidden = YES;
    [kKeyWindow addSubview:_backgroundView];
    
    _alertshareView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - AlertShareViewWidth) / 2, 60 + 44, AlertShareViewWidth, AlertShareViewHeight)];
    _alertshareView.backgroundColor = ColorForHex(0xffffff);
    _alertshareView.layer.masksToBounds = YES;
    _alertshareView.layer.cornerRadius = 5;
    [_backgroundView addSubview:_alertshareView];
    
//    _filledIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((_alertshareView.width - 100) / 2, 30, 100, 100) type:kRMClosedIndicator];
    _filledIndicator  = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((_alertshareView.width - 100) / 2, 30, 100, 100) type:kRMClosedIndicator lineWidth:4];
    [_filledIndicator setBackgroundColor:[UIColor clearColor]];
    [_filledIndicator setFillColor:ColorForHex(0xf2e216)];
    [_filledIndicator setStrokeColor:ColorForHex(0xf2e216)];
    _filledIndicator.radiusPercent = 0.45;
    [_alertshareView addSubview:_filledIndicator];
    [_filledIndicator setIndicatorAnimationDuration:1.0];
    [_filledIndicator loadIndicator];

    
    NSArray *imageArr = @[[UIImage imageNamed:@"upload1"],[UIImage imageNamed:@"upload2"],[UIImage imageNamed:@"upload3"],[UIImage imageNamed:@"upload4"],[UIImage imageNamed:@"upload5"],[UIImage imageNamed:@"upload6"],[UIImage imageNamed:@"upload7"]];
    _activityImageView = [[UIImageView alloc]initWithFrame:CGRectMake((_filledIndicator.width - 40) / 2 + 3, (_filledIndicator.height - 60) / 2, 40, 60)];
    _activityImageView.image = [UIImage imageNamed:@"upload1"];
    [_activityImageView setAnimationImages:imageArr];
    [_activityImageView setAnimationRepeatCount:0];
    [_activityImageView setAnimationDuration:7*0.1];
    [_activityImageView startAnimating];
    [_filledIndicator addSubview:_activityImageView];
    
    _percentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, _filledIndicator.bottom + 24, AlertShareViewWidth, 20)];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.textColor = ColorForHex(0x777777);
    _percentLabel.backgroundColor = [UIColor clearColor];
    _percentLabel.font = [UIFont systemFontOfSize:15];
    _percentLabel.text=[NSString stringWithFormat:@"%@%@",SVLocalizedString(@"video handling", nil),@"%0"];
    [_alertshareView addSubview:_percentLabel];
   
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _alertshareView.height - 45, _alertshareView.width, 1)];
    line1.backgroundColor = ColorForHex(0xf2f2f2);
    [_alertshareView addSubview:line1];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, _alertshareView.height - 44, _alertshareView.width, 44);
    [cancelBtn setTitle:SVLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    [_alertshareView addSubview:cancelBtn];
    
//    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_alertshareView.width / 2, _alertshareView.height - 44, 1, 44)];
//    line2.backgroundColor = ColorForHex(0xf2f2f2);
//    [_alertshareView addSubview:line2];
//    
//    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _shareBtn.frame = CGRectMake(_alertshareView.width / 2, _alertshareView.height - 44, _alertshareView.width / 2, 44);
//    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_shareBtn setTitle:SVLocalizedString(@"share", nil) forState:UIControlStateNormal];
//    _shareBtn.userInteractionEnabled = NO;
//    [_shareBtn setTitleColor:ColorForHex(0xd7d7d7d) forState:UIControlStateNormal];
//    [_shareBtn addTarget:self action:@selector(ShareOneVideo) forControlEvents:UIControlEventTouchUpInside];
//    [_alertshareView addSubview:_shareBtn];
    
}

- (void)creatShareView{
    
    _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, _shareToLabel.bottom + 20, kScreenWidth, kScreenHeight- _shareToLabel.bottom - 20 - 44)];
    if ([PublicObject isiPhone6plus]) {
        _shareView.frame = CGRectMake(0, _shareToLabel.bottom + 40, kScreenWidth, kScreenHeight- _shareToLabel.bottom - 20 - 44);
    }
    _shareView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_shareView];
    
    NSMutableArray* imageArr = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"uper"],[UIImage imageNamed:@"Timeline"],[UIImage imageNamed:@"weixin"],[UIImage imageNamed:@"weibo"],[UIImage imageNamed:@"QQ"], nil];
    
    NSMutableArray* sharelabelArr = [[NSMutableArray alloc]initWithObjects:@"uper",SVLocalizedString(@"Moments", nil),SVLocalizedString(@"WeChat", nil),SVLocalizedString(@"Weibo", nil),@"QQ", nil];
   
    UIImage *shareImage = [UIImage imageNamed:@"weibo"];
    CGFloat w = shareImage.size.width;//imgHeight;
    CGFloat h = shareImage.size.height;//imgHeight;
        
        CGFloat edge = (kScreenWidth - 80 - 4 * 40) / 3;
        for (int i = 0; i<imageArr.count; i++) {
            
            int row = i / 4;
            int loc = i % 4;
            CGFloat x = (edge + w) * loc + 40;
            CGFloat y = (edge + h + 5) * row;
            
            _shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
            _shareImageView.image = imageArr[i];
            _shareImageView.userInteractionEnabled = YES;
            [_shareView addSubview:_shareImageView];
            _shareImageView.tag = i + 100;
            
            _shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(x-16,_shareImageView.bottom+5 , 70, 15)];
            _shareLabel.text = sharelabelArr[i];
            _shareLabel.textAlignment = NSTextAlignmentCenter;
            _shareLabel.textColor = ColorForHex(0xb2b1b1);
            _shareLabel.font = [UIFont systemFontOfSize:14];
            _shareLabel.tag = i+100;
            _shareLabel.userInteractionEnabled = YES;
            [_shareView addSubview:_shareLabel];
            
            
            UITapGestureRecognizer * iamgeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareButtonclick:)];
            [_shareImageView addGestureRecognizer:iamgeTap];
            
            UITapGestureRecognizer * labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareButtonclick:)];
            [_shareLabel addGestureRecognizer:labelTap];
            
        }

    
    
}


- (void)creatShareLabel{
    
    float shareToWidth = [PublicObject widthForString:SVLocalizedString(@"Share To", nil) font:[UIFont systemFontOfSize:15]];
    _shareToLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-shareToWidth) / 2, _backView.bottom + 20 + 20 + 30, shareToWidth, 20)];
    if ([PublicObject isiPhone6plus]) {
        _shareToLabel.frame = CGRectMake((kScreenWidth-shareToWidth) / 2, _backView.bottom + 70 + 20, shareToWidth, 20);
    }
    _shareToLabel.text = SVLocalizedString(@"Share To", nil);
    _shareToLabel.textColor = ColorForHex(0xb2b1b1);
    _shareToLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_shareToLabel];
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(40, _backView.bottom + 20 + 20 + 30 + 18, (kScreenWidth-shareToWidth) / 2 - 40 - 10, 1)];
    if ([PublicObject isiPhone6plus]) {
        leftLine.frame = CGRectMake(40, _backView.bottom + 70 + 20 + 18, (kScreenWidth-shareToWidth) / 2 - 40 - 10, 1);
    }
    leftLine.backgroundColor = ColorForHex(0xb2b1b1);
    [self.view addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(_shareToLabel.right + 10, _backView.bottom + 20 + 20 + 30 + 18, (kScreenWidth-shareToWidth) / 2 - 40 - 10, 1)];
    if ([PublicObject isiPhone6plus]) {
        rightLine.frame = CGRectMake(_shareToLabel.right + 10, _backView.bottom + 70 + 20 + 18, (kScreenWidth-shareToWidth) / 2 - 40 - 10, 1);
    }
    rightLine.backgroundColor = ColorForHex(0xb2b1b1);
    [self.view addSubview:rightLine];
    
}

- (void)creatSaveLocalText{
    
    _saveToLocal = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveToLocal.frame = CGRectMake(0, _backView.bottom + 20, kScreenWidth, 20);
    [_saveToLocal setTitleColor:ColorForHex(0xffffff) forState:UIControlStateNormal];
    [_saveToLocal setTitle:SVLocalizedString(@"Saved to the local", nil) forState:UIControlStateNormal];
    [_saveToLocal setImage:[UIImage imageNamed:@"greenHook"] forState:UIControlStateNormal];
    _saveToLocal.backgroundColor = [UIColor clearColor];
    _saveToLocal.titleLabel.font =[UIFont systemFontOfSize:15];
    _saveToLocal.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    _saveToLocal.userInteractionEnabled = NO;
    [self.view addSubview:_saveToLocal];

}

- (void)creatVideoPlayView{
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-KPlayVideoWidth) / 2, 30, KPlayVideoWidth, KPlayVideoHeight)];
    if ([PublicObject isiPhone6plus]) {
        _backView.frame = CGRectMake((kScreenWidth - 325) / 2, 30, 325, 325);
    }
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    NSURL *sourceMovieURL = nil;
    if ([self.finishVideo FinsishVideoIsExist]) {
        sourceMovieURL = [NSURL fileURLWithPath:[self.finishVideo finishVideoFilePath]];

    }else{
        sourceMovieURL = [NSURL URLWithString:self.finishVideo.videoURL];
    }

    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    playerLayer.frame = CGRectMake(0, 0, KPlayVideoWidth, KPlayVideoHeight);
    if ([PublicObject isiPhone6plus]) {
        playerLayer.frame = CGRectMake(0, 0, 325, 325);
    }
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_backView.layer addSublayer:playerLayer];
    
    //封面图片
    _thumbnailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KPlayVideoWidth, KPlayVideoHeight)];
    if ([PublicObject isiPhone6plus]) {
        _thumbnailImageView.frame = CGRectMake(0, 0, 325, 325);
    }
    NSURL * thumbnailUrl = [NSURL fileURLWithPath:[self.finishVideo coverfinishVideoFilePath]];
    _thumbnailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailUrl]];
    [_backView addSubview:_thumbnailImageView];
    
    // 视频播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    // 播放视频标识
    UIImage *videoPlayMarkImage = kVideoPlayIcon100;
    _videoPlayMarkView = [[UIImageView alloc] initWithFrame:CGRectMake((_backView.width-videoPlayMarkImage.size.width)/2, (_backView.height-videoPlayMarkImage.size.height)/2, videoPlayMarkImage.size.width, videoPlayMarkImage.size.height)];
    _videoPlayMarkView.backgroundColor = [UIColor clearColor];
    _videoPlayMarkView.image = videoPlayMarkImage;
    _videoPlayMarkView.hidden = NO;
    [_backView addSubview:_videoPlayMarkView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_backView addGestureRecognizer:tap];
    
}

#pragma mark  点击事件
// 暂停、播放
- (void)tap
{
    if (_player) {
        if (_player.rate == 0) {
            CGFloat currentTimeValue = CMTimeGetSeconds(_player.currentTime);
            CGFloat totalTimeValue = CMTimeGetSeconds(_player.currentItem.duration);
            if (currentTimeValue - totalTimeValue >= 0) {
                [_player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)];
            }
            [_player play];
        }else {
            [_player pause];
        }
    }
    [self updateVideoPlayMarkState];
}

//停止通知
-(void)stop{
    
    if (_player) {
        [_player pause];
    }
    [self updateVideoPlayMarkState];
}

//更新播放按钮显示状态
- (void)updateVideoPlayMarkState
{
    if (_player && _player.rate == 0) {
        _videoPlayMarkView.hidden = NO;
    }
    else{
        _videoPlayMarkView.hidden = YES;
        _thumbnailImageView.hidden = YES;
    }
}

- (void)cancelShare
{
    _backgroundView.hidden = YES;
    NSString *share_h5_url = [NSString stringWithFormat:@"%@_share_h5_url",self.finishVideo.videoURL.lastPathComponent];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *isUpload = [user objectForKey:share_h5_url];
    if ([PublicObject isEmpty:isUpload]) {
        [user setObject:kNotificationQiNiuCanacelUpload forKey:kNotificationQiNiuCanacelUpload];//设此值是为了监控是否取消上传了
        [user synchronize];
    }
}

- (void)ShareOneVideo
{
    NSLog(@"分享按钮");
    _backgroundView.hidden = YES;
    [self shareOneVideoWithTap:_tapSender];
}

-(void)btnCancelClick{
    if (self.publishType == PublishBothSaveAndShare) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)selectVideoQuality
{

    CMActionSheet *actionSheet = [[CMActionSheet alloc] initWithTarget:nil];

    [actionSheet addButtonWithTitle:SVLocalizedString(@"share HD Video", nil) type:CMActionSheetButtonTypeNormal block:^{
        self.uploadQualityType = UploadQualityTypeHeight;
        [self actualBuildPublishData];

    }];
    
    [actionSheet addButtonWithTitle:SVLocalizedString(@"share Regular Video", nil) type:CMActionSheetButtonTypeNormal block:^{
        self.uploadQualityType = UploadQualityTypeNormal;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

        NSString *normalVideoPath = [NSString stringWithFormat:@"%@_normalPath",self.finishVideo.videoURL.lastPathComponent];
        self.normalVideoQualityPath = [user objectForKey:normalVideoPath];
        
        NSString *share_h5_url = [NSString stringWithFormat:@"%@_share_h5_url_normal",self.normalVideoQualityPath.lastPathComponent];
        NSString *isUpload = [user objectForKey:share_h5_url];
        _share_url = [user objectForKey:normalVideoPath];
            
        if (![PublicObject isEmpty:isUpload])
        {
            [self actualBuildPublishData];
        }else{
            self.normalVideoQualityPath = [VideoRecordViewController getRecordVideoFinishPath];
            NSString *normalVideoPath = [NSString stringWithFormat:@"%@_normalPath",self.finishVideo.videoURL.lastPathComponent];
            [user setObject:self.normalVideoQualityPath forKey:normalVideoPath];
            [user synchronize];
            
            NSURL *finishedURL = [NSURL fileURLWithPath:self.normalVideoQualityPath];
            [PublicObject convertVideoQualityWithInputURL:[NSURL fileURLWithPath:[self.finishVideo finishVideoFilePath]] outputURL:finishedURL completedBlock:^(BOOL isSuccess, NSString *errorString) {//压缩视频
                if (isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self actualBuildPublishData];

                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:errorString afterDelay:kStayTime];
                    });
                }
            }];
        }
        
    }];
    
    [actionSheet addButtonWithTitle:SVLocalizedString(@"cancel", nil) type:CMActionSheetButtonTypeNormal block:^{
        
    }];
    [actionSheet present];

}

//开始分享到七牛
- (void)actualBuildPublishData
{
    if (![PublicObject networkIsReachable]) {
        [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:@"当前网络异常" afterDelay:2];
        return;
    }
    __weak PublishVideoViewController *wself = self;
    NSMutableArray *fileUrlArr = [[NSMutableArray alloc]init];
    
    NSString *share_h5_url = [NSString stringWithFormat:@"%@_share_h5_url",self.finishVideo.videoURL.lastPathComponent];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *isUpload = [user objectForKey:share_h5_url];
    _share_url = [user objectForKey:share_h5_url];

    if (self.uploadQualityType == UploadQualityTypeNormal) {//低清
        share_h5_url = [NSString stringWithFormat:@"%@_share_h5_url_normal",self.normalVideoQualityPath.lastPathComponent];
        user = [NSUserDefaults standardUserDefaults];
        isUpload = [user objectForKey:share_h5_url];
        _share_url = [user objectForKey:share_h5_url];

    }
    //曾经上传分享过 直接分享即可
    if (![PublicObject isEmpty:isUpload])
    {
        NSLog(@"分享过的");
        //取得封面图片
        NSString *imagePath = [NSString stringWithFormat:@"%@_imagePath_Thumail",self.finishVideo.videoURL.lastPathComponent];
        self.shareVideoImageUrlStr = [NSURL URLWithString:[user objectForKey:imagePath]];
        
        [self updateActivityStateWhenUploadIsFinish];
        NSLog(@"分享按钮");
        _backgroundView.hidden = YES;
        [self shareOneVideoWithTap:_tapSender];
    }
    else{
        _backgroundView.hidden = NO;
        //将本地视频上传到七牛
        NSLog(@"分享到七牛");
        
        NSString *filePath =[self.finishVideo finishVideoFilePath];
        if (self.uploadQualityType == UploadQualityTypeNormal) {
            filePath = self.normalVideoQualityPath;
        }
        
        [SVUploadFileManager uploadFileWithFileURL:filePath fileType:SVUploadFileTypeVideo progressBlock:^(float percent) {
            NSLog(@"percent--%f",percent);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _percentLabel.text = [NSString stringWithFormat:@"视频搬运中...%d%@",(int)(percent * 100),@"%"];
                [_filledIndicator updateWithTotalBytes:1 downloadedBytes:percent];
                
            });
            
        } completedBlock:^(BOOL isSuccess, NSURL *fileURL) {
            if (isSuccess) {
                wself.shareFinishVideoUrlStr = fileURL;
                [fileUrlArr addObject:fileURL];
                if (fileUrlArr.count == 2)
                {
                    [wself sendQiNiuResultToServerWithTap:_tapSender];
                }
            }else{
                //上传失败 隐藏上传进度框
                [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:@"上传失败,请重新上传" afterDelay:2];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:@"" forKey:kNotificationQiNiuCanacelUpload];//设此值是为了监控是否取消上传了
                [user synchronize];
                _backgroundView.hidden = YES;
                return;
                
            }
            
        }];
        
        [SVUploadFileManager uploadFileWithFileURL:[self.finishVideo coverfinishVideoFilePath] fileType:SVUploadFileTypePhoto progressBlock:^(float percent) {
        } completedBlock:^(BOOL isSuccess, NSURL *fileURL) {
            if (isSuccess) {
                wself.shareVideoImageUrlStr = fileURL;
                [fileUrlArr addObject:fileURL];
                if (fileUrlArr.count == 2)
                {
                    [wself sendQiNiuResultToServerWithTap:_tapSender];
                }
            }else{
                //上传失败 隐藏上传进度框
                [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:@"上传失败,请重新上传" afterDelay:2];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:@"" forKey:kNotificationQiNiuCanacelUpload];//设此值是为了监控是否取消上传了
                [user synchronize];
                _backgroundView.hidden = YES;
                return;
            }
            
        }];
    }

}

#pragma mark  上传七牛

- (void)shareButtonclick:(UITapGestureRecognizer *)sender
{
    [self stop];
    _tapSender = sender;
    [self selectVideoQuality];//选择视频清晰度
}

//将返回的视频地址传回服务器,并返回html5地址
- (void)sendQiNiuResultToServerWithTap:(UITapGestureRecognizer *)sender
{
    __weak PublishVideoViewController *bself = self;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSData dataWithContentsOfFile:[self.finishVideo coverfinishVideoFilePath]];
    UIImage *image = [UIImage imageWithData:data];
    [SVUploadFileManager setUploadServerResultWithFinishUrl:self.shareFinishVideoUrlStr.absoluteString video_length:[self.finishVideo.videoLength floatValue] main_image_url:self.shareVideoImageUrlStr.absoluteString main_image_width:image.size.width main_image_height:image.size.height completedBlock:^(BOOL isSuccess, NSString *share_UrlStr, NSString *video_info_id) {
        if (isSuccess) {
            [bself updateActivityStateWhenUploadIsFinish];
            _share_url = share_UrlStr;

            NSString *info_id = [NSString stringWithFormat:@"%@_video_info_id",bself.finishVideo.videoURL.lastPathComponent];
            NSString *share_h5_url = [NSString stringWithFormat:@"%@_share_h5_url",bself.finishVideo.videoURL.lastPathComponent];
            NSString * shareQinNiuVideoUrlStr = [NSString stringWithFormat:@"%@_share_QinNiu_VideoUrlStr",bself.finishVideo.videoURL.lastPathComponent];
            NSString *imagePath = [NSString stringWithFormat:@"%@_imagePath_Thumail",bself.finishVideo.videoURL.lastPathComponent];
            
            if (self.uploadQualityType == UploadQualityTypeNormal){//低清保存信息
                
                info_id = [NSString stringWithFormat:@"%@_video_info_id_normal",bself.normalVideoQualityPath.lastPathComponent];
                share_h5_url = [NSString stringWithFormat:@"%@_share_h5_url_normal",bself.normalVideoQualityPath.lastPathComponent];
                shareQinNiuVideoUrlStr = [NSString stringWithFormat:@"%@_share_QinNiu_VideoUrlStr_normal",bself.normalVideoQualityPath.lastPathComponent];
                imagePath = [NSString stringWithFormat:@"%@_imagePath_Thumail_normal",bself.normalVideoQualityPath.lastPathComponent];

            }
            
            [user setObject:bself.shareFinishVideoUrlStr.absoluteString forKey:shareQinNiuVideoUrlStr];//七牛视频
            [user setObject:video_info_id forKey:info_id];//存储当前视频的id
            [user setObject:_share_url forKey:share_h5_url];//存最终的视频地址以视频后缀名字为key h5
            [user setObject:bself.shareVideoImageUrlStr.absoluteString forKey:imagePath];//封面图片
            [user synchronize];
            
            _backgroundView.hidden = YES;
            [self shareOneVideoWithTap:_tapSender];
            
        }
    }];

}

#pragma mark  分享到各大平台
- (void)shareOneVideoWithTap:(UITapGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 100:
            NSLog(@"uper");
            [self shareToUper];
            break;
        case 101:
            NSLog(@"朋友圈");
            [self shareTypeWith:ShareTypeWeixiTimeline];
            break;
        case 102:
            NSLog(@"微信");
            [self shareTypeWith:ShareTypeWeixiSession];
            break;
        case 103:
            NSLog(@"微博");
            [self shareTypeWith:ShareTypeSinaWeibo];
            break;
        case 104:
            NSLog(@"qq好友");
            [self shareTypeWith:ShareTypeQQ];
            break;
//        case 105:
//            NSLog(@"facebook");
//            [self shareToFacebook];
//            
//            break;
//        case 106:
//            NSLog(@"twitter");
//            [self shareToTwitter];
//            break;
        default:
            break;
    }
}

- (void)shareToUper
{
    BOOL isInstalllUper = [UperAPI isUperAppInstalled];

    if (!isInstalllUper) {//未安装uper,跳转appstore下载
        NSString *evaluationAppUrl = [PublicObject getUperAppRateURL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluationAppUrl]];
        return;
    }
    
    //高清视频参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString * shareQinNiuVideoUrlStr = [NSString stringWithFormat:@"%@_share_QinNiu_VideoUrlStr",self.finishVideo.videoURL.lastPathComponent];
    NSString *imagePath = [NSString stringWithFormat:@"%@_imagePath_Thumail",self.finishVideo.videoURL.lastPathComponent];
    NSString *info_id = [NSString stringWithFormat:@"%@_video_info_id",self.finishVideo.videoURL.lastPathComponent];

    if (self.uploadQualityType == UploadQualityTypeNormal) {//低清视频
        shareQinNiuVideoUrlStr = [NSString stringWithFormat:@"%@_share_QinNiu_VideoUrlStr_normal",self.normalVideoQualityPath.lastPathComponent];
        info_id = [NSString stringWithFormat:@"%@_video_info_id_normal",self.normalVideoQualityPath.lastPathComponent];
        imagePath = [NSString stringWithFormat:@"%@_imagePath_Thumail_normal",self.normalVideoQualityPath.lastPathComponent];

    }
    
    UperAPIObject *uperObject = [[UperAPIObject alloc]init];
    uperObject.v_u = [NSString stringWithFormat:@"http://%@",[user objectForKey:shareQinNiuVideoUrlStr]];//七牛的视频地址
    uperObject.v_id = [user objectForKey:info_id];
    uperObject.i_u = [NSString stringWithFormat:@"http://%@",[user objectForKey:imagePath]];
    uperObject.v_l = [NSString stringWithFormat:@"%d",(int)[self.finishVideo.videoLength floatValue]-1];
    
    [UperAPI sendReq:uperObject];
    
}

//- (void)shareToFacebook{
//    __weak PublishVideoViewController *bself = self;
//    [ShareObject authLoginWithType:ShareTypeFaceBook viewController:self result:^(BOOL result, BOOL isCancel, NSString *error) {
//        [bself shareToSnsWithShareType:ShareTypeFaceBook];
//    }];
//}
//
//- (void)shareToTwitter{
//    __weak PublishVideoViewController *bself = self;
//
//    [ShareObject authLoginWithType:ShareTypeTwitter viewController:self result:^(BOOL result, BOOL isCancel, NSString *error) {
//        [bself shareToSnsWithShareType:ShareTypeTwitter];
//    }];
//}

- (void)shareTypeWith:(ShareType)type
{
    BOOL isCanShare = [ShareObject isCanShareToSnsWithType:type];
    if (isCanShare) {
        [self shareToSnsWithShareType:type];

    }
    
}
#pragma mark  创建分享内容
- (void)shareToSnsWithShareType:(ShareType)shareType{
    size_t thumbnailMaxBytes = 30*1024;
    UIImage *shareThumbnail = nil;
    ShareContent* contentObject = [[ShareContent alloc] init];
    contentObject.title =@"一秒视频 每次拍一秒接在一起看";
    contentObject.content = [NSString stringWithFormat:@"一秒视频｜快看我制作的高清无码小视频 %@",self.share_url];
    NSData *data = [NSData dataWithContentsOfFile:[self.finishVideo coverfinishVideoFilePath]];
    UIImage *image = [UIImage imageWithData:data];
    NSData *shareImgData = UIImagePNGRepresentation(image);
    if (shareImgData.length > thumbnailMaxBytes) {
        shareThumbnail = [image scaleToBytes:thumbnailMaxBytes
                                   usingMode:NYXResizeModeAspectFit];
    }
    contentObject.shareImage = image;
    contentObject.thumbImage = shareThumbnail;
    contentObject.thumbImageData = UIImagePNGRepresentation(contentObject.thumbImage);
    contentObject.desc = @"一秒视频｜快看我制作的高清无码小视频";
    contentObject.url = self.share_url;
    contentObject.shareImageData = UIImagePNGRepresentation(contentObject.shareImage);

    if (shareType == ShareTypeWeixiTimeline || shareType == ShareTypeWeixiSession) {
        contentObject.mediaType = PublishContentMediaTypeVideo;

    }else if (shareType == ShareTypeQQ || shareType == ShareTypeFaceBook){
        contentObject.mediaType = PublishContentMediaTypeNews;

    }else if (shareType == ShareTypeSinaWeibo || shareType == ShareTypeTwitter){
        contentObject.mediaType = PublishContentMediaTypeImage;
    }
    
    __weak PublishVideoViewController *wself = self;

    [ShareObject showShareWithType:shareType
                           content:contentObject
                            result:^(ShareType type, BOOL result) {
                                if (result == YES) {
                                    [MBProgressHUD showHUDOnlyTextAddedTo:wself.view labelText:SVLocalizedString(@"share success", nil) afterDelay:2];
                                    if (shareType == ShareTypeWeixiSession) {
                                        [EventCounting countEvent:kShareToWeiXinFriend];
                                        
                                    }else if (shareType == ShareTypeWeixiTimeline){
                                        [EventCounting countEvent:kShareToTimeLine];

                                    }else if (shareType == ShareTypeSinaWeibo){
                                        [EventCounting countEvent:kShareToWeiBo];
                                        
                                    }else if (shareType == ShareTypeQQ){
                                        [EventCounting countEvent:kShareToQQFriend];
                                        
                                    }
                                    [EventCounting countEvent:kTotalShareCount];
                                    
                                }
                                else {
                                    [MBProgressHUD showHUDOnlyTextAddedTo:wself.view labelText:SVLocalizedString(@"share failure", nil) afterDelay:2];
                                }
                                
                            }];
    
}
//"video finishes handling" = "video finishes handling";
//"video handling" = "video handling";
- (void)updateActivityStateWhenUploadIsFinish
{
    _percentLabel.text = SVLocalizedString(@"video finishes handling", nil);
    [_filledIndicator updateWithTotalBytes:1 downloadedBytes:1];
    _shareBtn.userInteractionEnabled = YES;
    [_shareBtn setTitleColor:ColorForHex(0x000000) forState:UIControlStateNormal];
    [_activityImageView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
