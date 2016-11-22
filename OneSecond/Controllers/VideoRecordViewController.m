//
//  VideoViewController.m
//  videoRecord
//
//  Created by zhangyx on 13-8-7.
//  Copyright (c) 2013年 zhangyx. All rights reserved.
//  录制视频界面

#import "VideoRecordViewController.h"

// view controllr
#import "VideoDraftViewController.h"
#import "VideoClipEditViewController.h"
#import "SelectVideoCoverController.h"
#import "WelcomeViewController.h"
#import "PublishVideoViewController.h"
// view
#import "RecordVideoProgress.h"
#import "RecordVideoButton.h"
#import "CameraCoverView.h"
#import "PBJVisionUtilities.h"
#import "RecordVideoClipsView.h"
#import "RecordVideoClipPlayView.h"
#import "VideoClipCell.h"

// data model
#import "RecordVideoObject.h"
#import "UPAssetManager.h"
#import "VideoClipObject.h"
#import "VideoObject.h"
#import "VideoObjectList.h"
#import "UPGuide.h"
#import "FinishVideoObject.h"
#import "FinishVideoObjectList.h"

// public class
#import "DBManager.h"
#import "PBJVision.h"
#import "RecordVideoDefine.h"
#import "MBProgressHUD+CMBProgressHUD.h"
#import "UIImage-Extension.h"
#import "UINavigationItem+Support_ios7.h"
#import "HJImagesToVideo.h"

// frame work
#import <GLKit/GLKit.h>
#import "TranslucentButton.h"
#import "EventCounting.h"
#import "UPGuide.h"

#import "QiniuSDK.h"

#define kProgressBarHeight 6
#define kCameraPreviewInsets UIEdgeInsetsMake(0, 0, 0, 0)

#define kBlueDeleteBtnImage [UIImage imageNamed:@"blueDeleteBtn"]//normal status
#define kBlueDeleteBtnImageHi [UIImage imageNamed:@"blueDeleteBtn"]

#define kRedDeleteBtnImage [UIImage imageNamed:@"redDeleteBtn"] // ready delete
#define kRedDeleteBtnImageHi [UIImage imageNamed:@"redDeleteBtn"]

#define kRecordVideoBtnImage [UIImage imageNamed:@"recordVideoBtn"]
#define kRecordVideoBtnImageHi [UIImage imageNamed:@"recordVideoBtnHi"]

#define kSelectVideoBtnImage [UIImage imageNamed:@"selectVideoBtn"]
#define kSelectVideoBtnImageH [UIImage imageNamed:@"selectVideoBtn"]

#define kVideoLinkBtnImage [UIImage imageNamed:@"selectVideoLinkBtn"]
#define kVideoLinkBtnImageH [UIImage imageNamed:@"selectVideoLinkBtn"]

#define kRoteCameraBtnImage [UIImage imageNamed:@"rotateCameraBtn"]
#define kRoteCameraBtnImageHi [UIImage imageNamed:@"rotateCameraBtn_dj"]

#define kFlashBtnImage [UIImage imageNamed:@"flashBtn"]
#define kFlashBtnImageHi [UIImage imageNamed:@"flashBtn_dj"]
#define kFlashBtnImageAuto [UIImage imageNamed:@"flashBtn"]

#define kFoldoverImage [UIImage imageNamed:@"foldoverBtn"]
#define kFoldoverImageHi [UIImage imageNamed:@"foldoverBtn_dj"]

#define kTakePhotoBtnImage [UIImage imageNamed:@"takePhotoBtn"]
#define kTakePhotoBtnImageHi [UIImage imageNamed:@"takePhotoBtn_dj"]

#define kSelectVideoDraftImage [UIImage imageNamed:@"video_record_draft"]

#define kTextColor ColorForHex(0xd7d7d7)
#define kBottomBackColor ColorForRGB(0, 0, 0, 0.7)
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



//static BOOL kExistsRecordVideoController = NO;

typedef void(^MergeVideoResult) (BOOL isSuccess, NSURL *finishUrl,NSString *errorStr);

@interface VideoRecordViewController () <PBJVisionDelegate,
RecordVideoBtnDelegate,RecordVideoClipsViewDelegate,RecordVideoClipPlayViewDelegate,VideoDraftViewContollerDelegate,VideoClipEditViewControllerDelegate> {
    
    GLKViewController *_effectsViewController;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIView *_videoToolView; // 视频录制工具栏
    UIView *_previewView; // 渲染视图
    UIView *_navBottomView;
    UIView *_focusView;
    RecordVideoClipsView *_videoClipsView;
    RecordVideoClipPlayView *_videoClipPlayView;
    
    PBJVision *_recordEngine;
    
    RecordVideoProgress *_progressView;
    CameraCoverView *_cameraCoverView;
    UILabel *_deleteVideoAlertLabel;
    UILabel *_timeLabel;
    
    
    
    BOOL _isLocal;              //用来分辨是否是本地的视频或者图片
    BOOL _isPauseRecord;
    BOOL _recording;            // 是否在录制视频
    BOOL _nextBtnIsSelected;
    BOOL _isShowCoverView;
    
    NSMutableArray *_recordFrameItems;
    CGFloat _mixRecordFrame;                // 最小录制frame
    CGFloat _mixSegRecordFrame;             // 每段最小录制frame
    CGFloat _recordFrame;
    CGFloat _maxFrame;
    CGFloat _eachPartRecordFrame;           // 每段视频录制的帧数
    CGFloat _recordActionViewHeight;
}

//@property (nonatomic, retain) NSURL *mergeVideoURL; // 录制视频完成合并所有缓存的url

@property (nonatomic, assign) Float64 recordSeconds;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *foldoverButton;
@property (nonatomic, strong) UIButton *rotateCameraButton;
@property (nonatomic, strong) UIButton *takePhotoBtn;
@property (nonatomic, strong) RecordVideoButton *recordVideoBtn;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) TranslucentButton *nextStepBtn;
@property (nonatomic, strong) UIButton *videoDraftButton;

@property (nonatomic, strong) NSMutableArray *tmpAssetArray;
@property (nonatomic, assign) double videoSecond;
@property (nonatomic, strong) NSString *finishVideoPath;
@property (nonatomic, strong) UIButton *publishVideoLinkBtn;
@property (nonatomic, strong) VideoObject *videoObject;
@property (nonatomic, assign) CGPoint focusPoint;


@end

@implementation VideoRecordViewController

- (void)dealloc
{
    self.delegate = nil;
    if (_recordEngine) {
        [self endCapture];
        _recordEngine = nil;
    }
    self.recordVideoBtn.recordDelegate = nil;
    
    if (_effectsViewController) {
        [_effectsViewController removeFromParentViewController];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackgroundNotification)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ReceiveFinishResignPushNotification)
                                                     name:kFinishResignPushNotification
                                                   object:nil];

        //判断是否有未完成的视频 没有默认选择草稿箱的第一个
        VideoObject *unVideoObject = [VideoObject unFinishedVideoInstance];
        if (![PublicObject isEmpty:unVideoObject.videoId]) {
            VideoObject *video = [[VideoObjectList sharedVideoList] videoObjectWithVideoID:unVideoObject.videoId];
            self.unFinishedVideo = video;
        }else{
            VideoObject *videoObject = [[VideoObjectList sharedVideoList] firstObject];
            self.unFinishedVideo = videoObject;
            if (videoObject && videoObject.videoClips.count > 0) {
                self.unFinishedVideo = videoObject;
            }
        }
        _recordFrameItems = [[NSMutableArray alloc] init];
        self.videoObject = [VideoObject newVideo];
        self.recordType = RecordTypeVideo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackGroundColor;
    
    // 去掉 navigationBar 阴影
//    [PublicObject removeNavigationBarShadowImage:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.backButton = [self buildDraftBtn];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.backButton.enabled = NO;
    
    // 默认配置
    [self buildDefaultConfig];
    
    // titleView
    [self buildTitleView];
    
    // 创建捕捉器
    [self setUpCapture];
    
    // 以下方法顺序不能颠倒 -- > 渲染视图
    [self buildCameraPreview];
    
    [self buildRecordButton];
    // 加载指定的视频
    if (self.unFinishedVideo && self.unFinishedVideo.videoClips.count > 0) {
        [self resetRecordVideoViewWithVideoObject:self.unFinishedVideo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_cameraCoverView) {
        _cameraCoverView.hidden = NO;
    }
    self.navigationController.navigationBar.barTintColor = kBackGroundColor;
    
//    [self performSelector:@selector(showRecordGuideView) withObject:nil afterDelay:4];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    __weak VideoRecordViewController *bself = self;

    [self makeActionEventEnable:NO];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [bself makeActionEventEnable:YES];
    });
    
    // 显示录制视图
    if (_recordEngine.isCaptureSessionActive) {
        [self unfreezePreview];
        [self showCoverView];
    }
    else {
        NSLog(@"开始预览");
//        [self startCameraPreview];
    
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"打开麦克风了了");
            }
        }];
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"打开相机了");
                [self startCameraPreview];
                
            }
        }];
    }
    [[VideoObject unFinishedVideoInstance] deleteUnfinishedVideoInfo];
    [[VideoObject unFinishedVideoInstance] saveToFile:nil];
    [_videoClipsView scroolToBottomAnimation:YES];
    [_videoClipsView setAbleUseEditBtn];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenCoverView];
    [self makeActionEventEnable:NO];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 构建视图

- (void)showRecordGuideView
{
    [UPGuide showGuideWithType:UPGuideTypeExitSecondVideoAndBeginRecord completed:NULL];
}

- (UIBarButtonItem *)buildDraftBtn{
    UIImage *image = kSelectVideoDraftImage;
    const CGFloat btnSize = 20;
//    const CGFloat textImageSpacing = 15.0;
    UIButton *videoDraftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    videoDraftBtn.backgroundColor = [UIColor clearColor];
    videoDraftBtn.frame = CGRectMake(0, 0, btnSize, 15);
    [videoDraftBtn setImage:image forState:UIControlStateNormal];
    [videoDraftBtn addTarget:self action:@selector(videoDraftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoDraftBtn];
    self.videoDraftButton = videoDraftBtn;
    self.videoDraftButton.enabled = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.videoDraftButton];
    return barItem;
}
- (void)makeActionEventEnable:(BOOL)enabel
{
    self.recordVideoBtn.enabled = enabel;
    self.videoDraftButton.enabled = enabel;
    self.backButton.enabled = enabel;
    self.nextStepBtn.enabled = enabel;
}

- (void)showGuideView
{
    if (self.recordType == RecordTypeVideo) {
        //        [UPGuide showGuideWithType:UPGuideTypeTakeVideo completed:NULL];
    }
    else {
        //        [UPGuide showGuideWithType:UPGuideTypeTakePhoto completed:NULL];
    }
}

- (void)buildTitleView
{
    //    CGFloat btnGap = 20;
    _recordActionViewHeight = 95;
    if ([PublicObject isiPhone5]) {
        _recordActionViewHeight = 90;
    }
    
    if (self.recordType == RecordTypeVideo) {
        
        self.navigationItem.title =SVLocalizedString(@"record Video", nil);//@"录制视频";
        [self.navigationController.navigationBar setTitleTextAttributes:
         
         @{NSFontAttributeName:[UIFont systemFontOfSize:15],
           
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        _nextStepBtn = [TranslucentButton buttonWithType:UIButtonTypeCustom];
        _nextStepBtn.frame = CGRectMake(0, 0, 60, 32);
        [_nextStepBtn setTitle:SVLocalizedString(@"next", nil) forState:UIControlStateNormal];
        _nextStepBtn.titleLabel.font = kBarBtnFont;
        _nextStepBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:ColorForRGB(153, 153, 153, 1) forState:UIControlStateDisabled];
        [_nextStepBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem addRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_nextStepBtn]];
        
        // nav下面的黑色条
        CGFloat navBottomHeight = 0;
        if (kScreenHeight > 480) {
            navBottomHeight = 20;
        }
        _navBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navBottomHeight)];
        _navBottomView.backgroundColor = kBackGroundColor;
        [self.view addSubview:_navBottomView];
        
        // video tool
        //        [self buildVideoToolView];
    }
    else {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, kNavBarHeight)];
        titleView.backgroundColor = [UIColor clearColor];
        
        CGFloat flashButtonWidth = kFlashBtnImage.size.width + 30;
        // 旋转摄像头按钮
        self.rotateCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rotateCameraButton.backgroundColor = [UIColor clearColor];
        self.rotateCameraButton.exclusiveTouch = YES;
        self.rotateCameraButton.frame = CGRectMake(0, 0, kRoteCameraBtnImage.size.width, kRoteCameraBtnImage.size.height);
        [self.rotateCameraButton setBackgroundImage:kRoteCameraBtnImage forState:UIControlStateNormal];
        [self.rotateCameraButton setBackgroundImage:kRoteCameraBtnImageHi forState:UIControlStateHighlighted];
        [self.rotateCameraButton addTarget:self action:@selector(rotateCameraPosition:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rotateCameraButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        // 打开闪光灯按钮
        self.flashButton = [[UIButton alloc] initWithFrame:CGRectMake((titleView.width-flashButtonWidth)/2.,
                                                                      (titleView.frame.size.height-kFlashBtnImage.size.height)/2,
                                                                      flashButtonWidth, kFlashBtnImage.size.height)];
        self.flashButton.backgroundColor = [UIColor clearColor];
        [self.flashButton setTitleColor:kTextColor forState:UIControlStateNormal];
        [self.flashButton setTitleColor:kTextColor forState:UIControlStateHighlighted];
        self.flashButton.titleLabel.font = [PublicObject fontWithSize:12.0 fontName:@"" isBold:YES];
        [self.flashButton setImage:kFlashBtnImageAuto forState:UIControlStateNormal];
        [self.flashButton setImage:kFlashBtnImageAuto forState:UIControlStateHighlighted];
        [self.flashButton setTitle:UPLocalizedString(@"auto open flash", nil) forState:UIControlStateNormal];
        [self.flashButton setTitle:UPLocalizedString(@"auto open flash", nil) forState:UIControlStateHighlighted];
        [self.flashButton addTarget:self action:@selector(setCameraFlash) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:self.flashButton];
        
        self.navigationItem.titleView = titleView;
    }
}

- (void)buildVideoToolView
{
    if (!_videoToolView) {
        _videoToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        _videoToolView.backgroundColor = [UIColor clearColor];
        [_previewView addSubview:_videoToolView];
        
        CGFloat titleLabelHeight = 20;
        CGFloat titleLabelWidth = 40;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (_videoToolView.height - titleLabelHeight) / 2.f, titleLabelWidth, titleLabelHeight)];
        _timeLabel.clipsToBounds = YES;
        _timeLabel.backgroundColor = ColorForHexAlpha(0x000000, 0.4);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = ColorForHex(0xf2f2f2);
        _timeLabel.layer.cornerRadius = 4.f;
        [_videoToolView addSubview:_timeLabel];
        [self updateVideoTime];
        
        
        CGFloat itemBtnMargin = 20;
        CGFloat itemGap = 30;
        CGFloat itemSize = _videoToolView.height;
        
        // 重影效果按钮
        self.foldoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.foldoverButton.backgroundColor = [UIColor clearColor];
        self.foldoverButton.exclusiveTouch = YES;
        self.foldoverButton.userInteractionEnabled = NO;
        self.foldoverButton.frame = CGRectMake(self.view.width - itemBtnMargin - itemSize,
                                               (_videoToolView.height-itemSize)/2,itemSize, itemSize);
        [self.foldoverButton setImage:kFoldoverImage forState:UIControlStateNormal];
        [self.foldoverButton setImage:kFoldoverImageHi forState:UIControlStateSelected];
        [self.foldoverButton addTarget:self action:@selector(setFoldoverButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
        self.foldoverButton.userInteractionEnabled = NO;
        
        
        // 打开闪光灯按钮
        self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flashButton.frame = CGRectMake(self.foldoverButton.left - itemGap - itemSize,
                                            (_videoToolView.height-itemSize)/2,itemSize, itemSize);
        self.flashButton.backgroundColor = [UIColor clearColor];
        [self.flashButton setImage:kFlashBtnImage forState:UIControlStateNormal];
        [self.flashButton setImage:kFlashBtnImage forState:UIControlStateHighlighted];
        [self.flashButton addTarget:self action:@selector(setCameraFlash) forControlEvents:UIControlEventTouchUpInside];
        [_videoToolView addSubview:self.flashButton];
        
        // 旋转摄像头按钮
        self.rotateCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rotateCameraButton.backgroundColor = [UIColor clearColor];
        self.rotateCameraButton.exclusiveTouch = YES;
        self.rotateCameraButton.frame = CGRectMake(self.flashButton.left - itemGap - itemSize, (_videoToolView.height - itemSize) / 2., itemSize, itemSize);
        [self.rotateCameraButton setImage:kRoteCameraBtnImage forState:UIControlStateNormal];
        [self.rotateCameraButton setImage:kRoteCameraBtnImageHi forState:UIControlStateSelected];
        [self.rotateCameraButton addTarget:self action:@selector(rotateCameraPosition:) forControlEvents:UIControlEventTouchUpInside];
        [_videoToolView addSubview:self.rotateCameraButton];
        
        
        [_videoToolView addSubview:self.foldoverButton];
    }
}

- (void)buildCameraPreview
{
    CGRect preViewRect = CGRectMake(0, _navBottomView.bottom, self.view.width, self.view.width);
    if (self.recordType == RecordTypePhoto) {
        preViewRect = CGRectMake(0, _navBottomView.bottom, self.view.width, kScreenHeight - _navBottomView.height - kNavBarHeight - _recordActionViewHeight);
    }
    _previewView = [[UIView alloc] initWithFrame:preViewRect];
    _previewView.backgroundColor = [UIColor clearColor];
    _previewView.userInteractionEnabled = YES;
    [self.view addSubview:_previewView];
    
    _previewLayer = [_recordEngine bjPreviewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer insertSublayer:_previewLayer below:[[_previewView.layer sublayers] objectAtIndex:0]];
    
    if (self.recordType == RecordTypeVideo) {
        [self buildFoldOverView];
        [self buildVideoToolView];
        [self buildVideoClipPlayView];
        [self buildVideoRecordProgressView];
    }
    
    // 大门打开效果view
    _cameraCoverView = [[CameraCoverView alloc] initWithFrame:CGRectMake(_previewView.frame.origin.x,_previewView.frame.origin.y,_previewView.frame.size.width,_previewView.frame.size.height)];
    if (self.recordType == RecordTypePhoto) {
        _cameraCoverView.cameraCoverType = CameraCoverTypePhoto;
    }else{
        _cameraCoverView.cameraCoverType = CameraCoverTypeVideo;
    }
    [self.view addSubview:_cameraCoverView];
    
    // Add a single tap gesture to focus on the point tapped, then lock focus
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
    [singleTap setNumberOfTapsRequired:1];
    [_previewView addGestureRecognizer:singleTap];
}

- (void)buildVideoRecordProgressView
{
    CGFloat progressViewHeight = kProgressBarHeight;
    CGFloat progressViewTop = _previewView.bottom;
    _progressView = [[RecordVideoProgress alloc] initWithFrame:CGRectMake(0, progressViewTop, self.view.width, progressViewHeight)];
    [self.view addSubview:_progressView];
    
    _videoClipsView = [[RecordVideoClipsView alloc] initWithFrame:CGRectMake(0, _progressView.bottom, self.view.width, 68)];
    _videoClipsView.backgroundColor = [UIColor clearColor];
    _videoClipsView.delegate = self;
    [self.view addSubview:_videoClipsView];
}

- (void)buildRecordButton
{
    if (self.recordType == RecordTypeVideo) {
        CGFloat bottomViewHeight = kScreenHeight-kNavBarHeight-_videoClipsView.bottom;
        CGFloat recordBtnOrginY = _videoClipsView.bottom + (bottomViewHeight-kRecordVideoBtnImage.size.height) / 2.f;
        
        // 录制视频按钮
        RecordVideoButton *tempButton = [[RecordVideoButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-kRecordVideoBtnImage.size.width)/2, recordBtnOrginY, kRecordVideoBtnImage.size.width, kRecordVideoBtnImage.size.height)];
        tempButton.recordDelegate = self;
        self.recordVideoBtn = tempButton;
        self.recordVideoBtn.userInteractionEnabled = NO;
        [self.view addSubview:self.recordVideoBtn];
        
        
//        UIImage *image = kSelectVideoDraftImage;
//        const CGFloat btnSize = 60;
//        const CGFloat textImageSpacing = 15.0;
//        UIButton *videoDraftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        videoDraftBtn.backgroundColor = [UIColor clearColor];
//        videoDraftBtn.frame = CGRectMake(0, 0, btnSize, 50);
//        [videoDraftBtn setImage:image forState:UIControlStateNormal];
//        [videoDraftBtn setTitle:UPLocStr(@"AllDraft") forState:UIControlStateNormal];
//        [videoDraftBtn setTitleColor:kTextColor forState:UIControlStateNormal];
//        videoDraftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        videoDraftBtn.titleEdgeInsets = UIEdgeInsetsMake((btnSize-image.size.height-textImageSpacing)/2+image.size.height, -image.size.width, 0, 0);
//        videoDraftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, (btnSize - image.size.width)/2.-3, 11, 0);
//        [videoDraftBtn addTarget:self action:@selector(videoDraftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:videoDraftBtn];
//        videoDraftBtn.top = self.recordVideoBtn.top;
//        videoDraftBtn.left = (self.view.width-self.recordVideoBtn.right - videoDraftBtn.width) / 2.0 + self.recordVideoBtn.right;
//        
//        self.videoDraftButton = videoDraftBtn;
//        self.videoDraftButton.enabled = NO;
    }
    else if (self.recordType == RecordTypePhoto) {
        // 照相按钮
        CGFloat bottomViewHeight = _recordActionViewHeight;//tempViewHeight-y;
        CGFloat recordBtnOrginY = _previewView.bottom + (bottomViewHeight-kTakePhotoBtnImage.size.height)/2;
        self.takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.takePhotoBtn.backgroundColor = [UIColor clearColor];
        self.takePhotoBtn.frame = CGRectMake((self.view.width-kTakePhotoBtnImage.size.width)/2, recordBtnOrginY, kTakePhotoBtnImage.size.width, kTakePhotoBtnImage.size.height);
        [self.takePhotoBtn setBackgroundImage:kTakePhotoBtnImage forState:UIControlStateNormal];
        [self.takePhotoBtn setBackgroundImage:kTakePhotoBtnImageHi forState:UIControlStateHighlighted];
        [self.takePhotoBtn addTarget:self action:@selector(caputurePhoto) forControlEvents:UIControlEventTouchUpInside];
        self.takePhotoBtn.userInteractionEnabled = NO;
        self.takePhotoBtn.exclusiveTouch = YES;
        [self.view addSubview:self.takePhotoBtn];
    }
}

// 重影
- (void)buildFoldOverView
{
    if (!_effectsViewController) {
        
        self.foldoverButton.userInteractionEnabled = YES;
        
        // 重影效果
        //        [_recordEngine setupGL];
        
        _effectsViewController = [[GLKViewController alloc] init];
        _effectsViewController.preferredFramesPerSecond = 60;
        _effectsViewController.pauseOnWillResignActive = NO;
        [self addChildViewController:_effectsViewController];
        
        GLKView *view = (GLKView *)_effectsViewController.view;
        CGRect viewFrame = _previewView.bounds;
        view.frame = viewFrame;
        view.context = [_recordEngine context];
        view.contentScaleFactor = [[UIScreen mainScreen] scale];
        view.alpha = 0.35f;
        view.hidden = YES;
        [_recordEngine setPresentationFrame:_previewView.frame];
        [_previewView addSubview:_effectsViewController.view];
    }
}

- (void)buildVideoClipPlayView
{
    _videoClipPlayView = [[RecordVideoClipPlayView alloc] initWithFrame:_previewView.bounds];
    _videoClipPlayView.delegate = self;
    _videoClipPlayView.hidden = YES;
    [_previewView addSubview:_videoClipPlayView];
}

#pragma mark 构建数据

- (void)resetRecordVideoViewWithVideoObject:(VideoObject *)videoObject
{
    self.videoObject = videoObject;
    _videoClipsView.videoClips = self.videoObject.videoClips.objectArray;
    [self updateVideoTime];
}

- (void)buildDefaultConfig
{
    // 初始化数据
    self.recordSeconds = 0;
    _recordFrame = 0;
    _eachPartRecordFrame = 0;
    // 设备硬件比较低的情况下 秒数 * 帧数 最大录制时间
    //#define kMaxFrame kSeconds * kTimeScale // 秒数 * 帧数 最大录制时间
    float tempSeconds = kSeconds;
    float tempTimeScale = kTimeScale;
    _mixRecordFrame = kMixRecordSeconds * tempTimeScale;            // 最小录制frame
    _mixSegRecordFrame = kMixSegRecordSeconds * tempTimeScale;      // 每段最小录制frame
    _maxFrame = tempSeconds * tempTimeScale;
}

- (NSString *)docDir
{
    return [[DBManager getInstance] getCacheFolderPathWithFolderName:kFolderName];
}

- (NSString *)finishVidoDocDir
{
    return [[DBManager getInstance] getCacheFolderPathWithFolderName:kFinishVideoFoldreName];
}


- (NSString *)getRecordVideoFilePath
{
    NSString *fileName = [[PublicObject generateNoLineUUID] stringByAppendingString:@".mp4"];
    return [[self docDir] stringByAppendingPathComponent:fileName];
}

- (NSString *)getFinishVideoFilePath
{
    self.finishVideoPath = nil;
    if (!self.finishVideoPath) {
        NSString *fileName = [[PublicObject generateNoLineUUID] stringByAppendingString:@".mp4"];
        self.finishVideoPath = [[self finishVidoDocDir] stringByAppendingPathComponent:fileName];
    }
//    NSLog(@"self.finishVideoPath---***%@",self.finishVideoPath);
    return self.finishVideoPath;
}

+ (NSString *)getRecordVideoFinishPath
{
    NSString *fileName = [[PublicObject generateNoLineUUID] stringByAppendingString:@".mp4"];
    NSString *finishVideoDorPath = [[DBManager getInstance] getCacheFolderPathWithFolderName:kFinishVideoFoldreName];
    return [finishVideoDorPath stringByAppendingPathComponent:fileName];
}


#pragma mark
#pragma mark UIButton method

- (void)videoLinkBtnClicked
{
    if ([self.delegate respondsToSelector:@selector(recordVideoControllerDidSelectPublishVideoLink:)]) {
        [self stopCameraPreview];
        [self.delegate recordVideoControllerDidSelectPublishVideoLink:self];
    }
}

// 返回
- (void)goBack
{
    if (self.videoObject.videoClips.count > 0) {
        __weak VideoRecordViewController *bself = self;
        [PublicObject showAlertViewWithTitle:nil//@"提示"
                                  message:UPLocalizedString(@"Exit the uper or close the page after the video will not automatically deleted", nil)
                              cancelTitle:UPLocalizedString(@"cancel", nil)//@"取消"
                               otherTitle:UPLocalizedString(@"sure", nil)//@"确定"
                               completion:^(BOOL cancelled, NSInteger buttonIndex)
         {
             if (buttonIndex == 1) {
                 [_videoClipPlayView hide];
                 [_videoClipsView changeVideoClipStateToPlay];
                 if ([bself.videoObject.videoClips count] > 0 && bself.recordType == RecordTypeVideo) {
                     [[VideoObjectList sharedVideoList] saveVideoObject:bself.videoObject];
                     // 删除合成视频缓存
                     [[DBManager getInstance] deleteWithFilePath:[bself finishVidoDocDir]];
                     // 结束录制
                     [bself endCapture];
                     // 页面消失释放 录制engine
                     [bself distroyCurrentView];
                 }
                 else {
                     // 页面消失释放 录制engine
                     [bself distroyCurrentView];
                 }
                 
                 
             }else{
                 NSLog(@"取消");
             }
         }];
        
    }else{
        [_videoClipPlayView hide];
        [_videoClipsView changeVideoClipStateToPlay];
        if ([self.videoObject.videoClips count] > 0 && self.recordType == RecordTypeVideo) {
            [[VideoObjectList sharedVideoList] saveVideoObject:self.videoObject];
            // 删除合成视频缓存
            [[DBManager getInstance] deleteWithFilePath:[self finishVidoDocDir]];
            // 结束录制
            [self endCapture];
            // 页面消失释放 录制engine
            [self distroyCurrentView];
        }
        else {
            // 页面消失释放 录制engine
            [self distroyCurrentView];
        }
        
    }
    
}

// 页面消失释放 录制engine
- (void)distroyCurrentView
{
    [self stopCameraPreview];
    if ([self.delegate respondsToSelector:@selector(recordVideoControllerDidCancel:)]) {
        [self.delegate recordVideoControllerDidCancel:self];
    }
}

// 显示选择封面页面
- (void)showSelectCoverControllerWithVideoURL:(NSURL *)videoURL saveToAlbum:(BOOL)saveToAlbum
{
    [self freezePreview];
    SelectVideoCoverController *vc = [[SelectVideoCoverController alloc] initWithFileUrl:videoURL];
    vc.delegate = self;
    vc.needSaveToAlbum = YES;// 用户录制的视频，在发布后才自动保存到用户相册里。这里不要自动保存到相册
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showVideoDraftController
{
    [self freezePreview];
    VideoDraftViewController *videoDraftVC = [[VideoDraftViewController alloc] init];
    videoDraftVC.delegate = self;
    [self.navigationController pushViewController:videoDraftVC animated:YES];
}

// 下一步
- (void)nextAction
{
    [self makeActionEventEnable:NO];
    if (self.recordType == RecordTypeVideo) {
        [_videoClipPlayView hide];
        [_videoClipsView changeVideoClipStateToPlay];
        
        if (self.videoObject.videoClips.count < 5) {
            [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow labelText:SVLocalizedString(@"The shortest recorded 5 seconds", nil) afterDelay:kStayTime];
            [self makeActionEventEnable:YES];
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow labelText:SVLocalizedString(@"video generating", nil) afterDelay:1000];//视频合成中...
        hud.userInteractionEnabled = YES;
        
        if (_recordEngine.flashMode == PBJFlashModeOn) {
            // 关闭闪光灯
            [self setCameraFlash];
        }
        NSString *recordPath = [self getRecordVideoFilePath];
        // 获取视频最后一个片段的最后一帧图片，并在图片上加上用户名称，一秒视频title和图标等信息
        UIImage *image = [self.videoObject imageFromLastFrame];
        
        NSArray *array = @[image,image];
        [HJImagesToVideo videoFromImages:array toPath:recordPath withSize:image.size animateTransitions:YES withCallbackBlock:^(BOOL success) {
            
            __weak VideoRecordViewController *bself = self;
            
            NSMutableArray *cacheVideoUrls = [NSMutableArray array];
            for (VideoClipObject *object in bself.videoObject.videoClips.objectArray) {
                if (object.videoUrl && object.videoUrl.length > 0) {
                    [cacheVideoUrls addObject:[NSURL fileURLWithPath:object.videoUrl]];
                    
                }
            }
            if (cacheVideoUrls.count > 0) {
                [cacheVideoUrls addObject:[NSURL fileURLWithPath:recordPath]];
            }
            
            [bself mergeVideoWithURLItems:cacheVideoUrls
                                  result:^(BOOL isSuccess, NSURL *finishUrl, NSString *errorStr) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
                                          [self makeActionEventEnable:YES];
                                          if (isSuccess) {
                                              [bself saveRecordVideo];
                                              [bself showSelectCoverControllerWithVideoURL:finishUrl saveToAlbum:YES];
                                          }
                                          else {
                                              [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow
                                                                          labelText:errorStr
                                                                         afterDelay:kStayTime];
                                          }
                                      });
                                  }];
            if (_isLocal) {
//                [UPCounting countEvent:kEvent_PublishViewSource label:kVideoSourceLocal labelKey:kEvent_PublishViewSource];
            }else{
//                [UPCounting countEvent:kEvent_PublishViewSource label:kVideoSourceRecord labelKey:kEvent_PublishViewSource];
            }
        }];
    }
}


// 旋转摄像头
- (void)rotateCameraPosition:(id)sender
{
    self.rotateCameraButton.selected = !self.rotateCameraButton.selected;
    if (_recordEngine.cameraDevice == PBJCameraDeviceBack) {
        [_recordEngine setCameraDevice:PBJCameraDeviceFront];
        [self setFlashButtonStatus:PBJFlashModeOff];
    } else {
        [_recordEngine setCameraDevice:PBJCameraDeviceBack];
    }
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
    
}

// 设置闪光灯
- (void)setCameraFlash
{
    if (_recordEngine.isFlashAvailable) {
        if (_recordEngine.cameraMode == PBJCameraModeVideo) {
            if (_recordEngine.flashMode == PBJFlashModeOn) {
                [_recordEngine setFlashMode:PBJFlashModeOff];
                [self setFlashButtonStatus:PBJFlashModeOff];
            }
            else if (_recordEngine.flashMode == PBJFlashModeOff) {
                [_recordEngine setFlashMode:PBJFlashModeOn];
                [self setFlashButtonStatus:PBJFlashModeOn];
            }
            else {
                [_recordEngine setFlashMode:PBJFlashModeOff];
                [self setFlashButtonStatus:PBJFlashModeOff];
            }
        }
        else {
            if (_recordEngine.flashMode == PBJFlashModeAuto) {
                [_recordEngine setFlashMode:PBJFlashModeOn];
                [self setFlashButtonStatus:PBJFlashModeOn];
            }
            else if (_recordEngine.flashMode == PBJFlashModeOn) {
                [_recordEngine setFlashMode:PBJFlashModeOff];
                [self setFlashButtonStatus:PBJFlashModeOff];
            }
            else {
                [_recordEngine setFlashMode:PBJFlashModeAuto];
                [self setFlashButtonStatus:PBJFlashModeAuto];
            }
        }
    }
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
    
}

// 设置闪光灯按钮状态
- (void)setFlashButtonStatus:(PBJFlashMode)flashMode
{
    if (flashMode == PBJFlashModeAuto) {
        //Background
        [self.flashButton setImage:kFlashBtnImageAuto forState:UIControlStateNormal];
        [self.flashButton setImage:kFlashBtnImageAuto forState:UIControlStateHighlighted];
        
    }
    else if (flashMode == PBJFlashModeOn) {
        [self.flashButton setImage:kFlashBtnImageHi forState:UIControlStateNormal];
        [self.flashButton setImage:kFlashBtnImageHi forState:UIControlStateHighlighted];
    }
    else {
        [self.flashButton setImage:kFlashBtnImage forState:UIControlStateNormal];
        [self.flashButton setImage:kFlashBtnImage forState:UIControlStateHighlighted];
    }
}

// 设置重影
- (void)setFoldoverButtonStatus:(id)sender
{
    [self.foldoverButton setSelected:!self.foldoverButton.selected];
    _effectsViewController.view.hidden = !self.foldoverButton.selected;
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
}

// 选择视频草稿箱
- (void)videoDraftBtnClicked
{
    [self saveRecordVideo];
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
    
    [self showVideoDraftController];
}
// 选择视频或是相片
- (void)selectedMediaItem
{
//    NSInteger status = [UPAssetManager authorizationStatus];
//    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
//        [self showError:UPLocalizedString(@"visite local photo alert", nil)];//@"请在 “设置” > “隐私” > “照片” 中允许uper访问照片"
//        return;
//    }
//    if (self.recordType == RecordTypeVideo) {
//        [self freezePreview];
//        UPImagePickerController *imagePC = [[UPImagePickerController alloc] init];
//        imagePC.filterType = UPImagePickerFilterTypeAllVideos;
//        imagePC.delegate = self;
//        [self.navigationController pushViewController:imagePC animated:YES];
//    }
//    else if (self.recordType == RecordTypePhoto) {
//        [self distroyCurrentView];
//    }
//    _isLocal = YES;
}

// 拍摄照片
- (void)caputurePhoto
{
    if (_recordEngine.canCapturePhoto) {
        
        [self startCapture];
    }
    _isLocal = NO;
}

- (void)setDeleteButtonStatus:(BOOL)isNormal
{
    if (isNormal) {
        _deleteVideoAlertLabel.text = UPLocalizedString(@"return to delete", nil);//@"回删";
        [self.deleteButton setImage:kBlueDeleteBtnImage forState:UIControlStateNormal];
        [self.deleteButton setImage:kBlueDeleteBtnImageHi forState:UIControlStateHighlighted];
        
        [self.recordVideoBtn setBackgroundImage:kRecordVideoBtnImage forState:UIControlStateNormal];
        [self.recordVideoBtn setBackgroundImage:kRecordVideoBtnImage forState:UIControlStateHighlighted];
    }
    else {
        _deleteVideoAlertLabel.text = UPLocalizedString(@"delete", nil);//@"删除";
        [self.deleteButton setImage:kRedDeleteBtnImage forState:UIControlStateNormal];
        [self.deleteButton setImage:kRedDeleteBtnImageHi forState:UIControlStateHighlighted];
        [self.recordVideoBtn setBackgroundImage:kRecordVideoBtnImageHi forState:UIControlStateNormal];
        [self.recordVideoBtn setBackgroundImage:kRecordVideoBtnImageHi forState:UIControlStateHighlighted];
    }
}

- (void)removeRecordVideoClipObject:(VideoClipObject *)videoClipObject
{
    [self.videoObject deleteVideoClipObject:videoClipObject];
    [self resetRecordVideoViewWithVideoObject:self.videoObject];
    // 删除时将一个视频的某个视频片段删除，删除了源文件，同样要更新数据列表。
    [[VideoObjectList sharedVideoList] saveVideoObject:self.videoObject];
}

#pragma mark - private start/stop helper methods

- (void)updateVideoTime
{
    NSString *aTime = [NSString stringWithFormat:@"%lu秒",(unsigned long)self.videoObject.videoClips.count];
    _timeLabel.text = aTime;
    if (self.videoObject.videoClips.count == 1) {
        [UPGuide showGuideWithType:UPGuideTypeNextLensSecondVideo completed:NULL];
    }
    
    if (self.videoObject.videoClips.count == 2) {
//        [UPGuide showGuideWithType:UPGuideTypePreviewAndEditSecondVideo completed:NULL];
        [UPGuide showGuideWithType:UPGuideTypePreviewAndEditSecondVideo WithCustomView:_videoClipsView force:NO completed:NULL];
    }
    
    if (self.videoObject.videoClips.count == 5) {
        [UPGuide showGuideWithType:UPGuideTypePreviewSecondVideo completed:NULL];
    }
}


- (void)saveRecordVideo
{
    [[VideoObjectList sharedVideoList] saveVideoObject:self.videoObject];
}

- (void)setTakeButtonEnabled:(BOOL)enabled
{
    if (self.recordType == RecordTypeVideo) {
        self.recordVideoBtn.userInteractionEnabled = enabled;
        self.foldoverButton.userInteractionEnabled = enabled;
    }
    else if (self.recordType == RecordTypePhoto) {
        self.takePhotoBtn.userInteractionEnabled = enabled;
    }
}

- (void)showError:(NSString *)errorDes
{
    if (![PublicObject isEmpty:errorDes]) {
        [PublicObject showAlertViewForMessage:errorDes];
    }
}

- (void)showAlert:(NSString *)text
{
    [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow labelText:text afterDelay:kStayTime];
}


- (void)deleteFile:(NSURL *)filePath
{
    [[DBManager getInstance] deleteWithFilePath:[filePath path]];
}


- (void)buildTransitionComposition:(AVMutableComposition *)composition
               andVideoComposition:(AVMutableVideoComposition *)videoComposition
                       andAudioMix:(AVMutableAudioMix *)audioMix
                          urlItems:(NSArray *)urlItems
{
    
    NSInteger i;
    
    NSMutableArray *clipTimeRanges = [NSMutableArray arrayWithCapacity:urlItems.count];
    NSMutableArray *_clips = [NSMutableArray arrayWithCapacity:urlItems.count];
    
    //    AVMutableCompositionTrack *compositionVideoTracks[urlItems.count];
    //	AVMutableCompositionTrack *compositionAudioTracks[urlItems.count];
    
    for (i = 0; i < [urlItems count]; i ++) {
        NSURL *videoURl = [urlItems objectAtIndex:i];
        AVAsset *avAsset = [AVAsset assetWithURL:videoURl];
        [_clips addObject:avAsset];
        [clipTimeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(kCMTimeZero, avAsset.duration)]];
        //        compositionVideoTracks[i] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        //        compositionAudioTracks[i] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    
    CMTime nextClipStartTime = kCMTimeZero;
    NSUInteger clipsCount = [_clips count];
    
    // Make transitionDuration no greater than half the shortest clip duration.
    // 4s（包括4s） 之后的设备 0.03s的过度时间就可以了 4（包括4）之前的设备0.3s 的过渡时间
    CMTime transitionDuration = CMTimeMakeWithSeconds(0.03, 600);
    if ([PublicObject isNeedLongTransitionTime]) {
        transitionDuration = CMTimeMakeWithSeconds(0.3, 600);
    }
    //    NSLog(@"transitionDuration = %f",CMTimeGetSeconds(transitionDuration));
    for (i = 0; i < clipsCount; i++ ) {
        NSValue *clipTimeRange = [clipTimeRanges objectAtIndex:i];
        if (clipTimeRange) {
            CMTime halfClipDuration = [clipTimeRange CMTimeRangeValue].duration;
            //              NSLog(@"halfClipDuration = %f",CMTimeGetSeconds(halfClipDuration));
            halfClipDuration.timescale *= 2; // You can halve a rational by doubling its denominator.
            transitionDuration = CMTimeMinimum(transitionDuration, halfClipDuration);
            //              NSLog(@"transitionDuration = %f",CMTimeGetSeconds(transitionDuration));
        }
    }
    
    // 注意： 视频合成的时候同时拥有不同的AVMutableCompositionTrack的个数不能超过15个（iphone5是15个其他的设备可能个数有所偏差），超度硬件限制个数倒出视频的时候AVAssetExportSession回报11800 未知错误
    AVMutableCompositionTrack *compositionVideoTracks[2];
    AVMutableCompositionTrack *compositionAudioTracks[2];
    compositionVideoTracks[0] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    compositionVideoTracks[1] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    compositionAudioTracks[0] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    compositionAudioTracks[1] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTimeRange *passThroughTimeRanges = alloca(sizeof(CMTimeRange) * _clips.count);
    CMTimeRange *transitionTimeRanges = alloca(sizeof(CMTimeRange) * _clips.count);
    
    // Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
    for (i = 0; i < clipsCount; i++ ) {
        NSInteger alternatingIndex = i % 2; // alternating targets: 0, 1, 0, 1, ...
        AVURLAsset *asset = [_clips objectAtIndex:i];
        
        NSValue *clipTimeRange = [clipTimeRanges objectAtIndex:i];
        CMTimeRange timeRangeInAsset;
        if (clipTimeRange) {
            timeRangeInAsset = [clipTimeRange CMTimeRangeValue];
        }
        else {
            timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        }
        NSArray *videoTrackItems = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *clipVideoTrack = nil;
        if (videoTrackItems.count > 0) {
            clipVideoTrack = [videoTrackItems objectAtIndex:0];
            [compositionVideoTracks[alternatingIndex] insertTimeRange:timeRangeInAsset ofTrack:clipVideoTrack atTime:nextClipStartTime error:nil];
        }
        
        NSArray *audioTrackItems = [asset tracksWithMediaType:AVMediaTypeAudio];
        if (audioTrackItems.count > 0) {
            AVAssetTrack *clipAudioTrack = [audioTrackItems objectAtIndex:0];
            [compositionAudioTracks[alternatingIndex] insertTimeRange:timeRangeInAsset ofTrack:clipAudioTrack atTime:nextClipStartTime error:nil];
        }
        //		NSLog(@"compositionAudioTracks[%d] timeRangeInAsset start = %f duration = %f nextClipStartTime = %f",alternatingIndex,CMTimeGetSeconds(timeRangeInAsset.start),
        //              CMTimeGetSeconds(timeRangeInAsset.duration),CMTimeGetSeconds(nextClipStartTime));
        
        
        if (i == 0) {
            //            NSLog(@"cgsize = %@",NSStringFromCGSize(clipVideoTrack.naturalSize));
            // Every videoComposition needs these properties to be set:
            if (clipVideoTrack) {
                composition.naturalSize = clipVideoTrack.naturalSize;
                videoComposition.renderSize = clipVideoTrack.naturalSize;
            }
        }
        //        NSLog(@"nextClipStartTime = %f",CMTimeGetSeconds(nextClipStartTime));
        // Remember the time range in which this clip should pass through.
        // Second clip begins with a transition.
        // First clip ends with a transition.
        // Exclude those transitions from the pass through time ranges.
        passThroughTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, timeRangeInAsset.duration);
        
        if (i > 0) {
            passThroughTimeRanges[i].start = CMTimeAdd(passThroughTimeRanges[i].start, transitionDuration);
            passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
        }
        if (i+1 < clipsCount) {
            passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
        }
        
        // The end of this clip will overlap the start of the next by transitionDuration.
        // (Note: this arithmetic falls apart if timeRangeInAsset.duration < 2 * transitionDuration.)
        nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration);
        nextClipStartTime = CMTimeSubtract(nextClipStartTime, transitionDuration);
        //        NSLog(@"nextClipStartTime = %f",CMTimeGetSeconds(nextClipStartTime));
        
        // Remember the time range for the transition to the next item.
        if (i+1 < clipsCount) {
            transitionTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, transitionDuration);
        }
    }
    
    // Set up the video composition if we are to perform crossfade transitions between clips.
    NSMutableArray *instructions = [NSMutableArray array];
    NSMutableArray *trackMixArray = [NSMutableArray array];
    
    // Cycle between "pass through A", "transition from A to B", "pass through B"
    for (i = 0; i < clipsCount; i++ ) {
        NSInteger alternatingIndex = i % 2; // alternating targets
        // Pass through clip i.
        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction
                                                                       videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[alternatingIndex]];
        
        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = passThroughTimeRanges[i];
        passThroughInstruction.layerInstructions = [NSArray arrayWithObject:passThroughLayer];
        [instructions addObject:passThroughInstruction];
        
        if (i+1 < clipsCount) {
            AVMutableVideoCompositionInstruction *transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            transitionInstruction.timeRange = transitionTimeRanges[i];
            AVMutableVideoCompositionLayerInstruction *fromLayer = [AVMutableVideoCompositionLayerInstruction
                                                                    videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[alternatingIndex]];
            AVMutableVideoCompositionLayerInstruction *toLayer = [AVMutableVideoCompositionLayerInstruction
                                                                  videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[1-alternatingIndex]];
            
            // Fade in the toLayer by setting a ramp from 0.0 to 1.0.
            //            [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionTimeRanges[i]];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            [instructions addObject:transitionInstruction];
            
            /*
             AVAssetTrack *clipAudioTrack = [[[_clips objectAtIndex:i] tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
             //            AVAssetTrack *clipAudioTrack1 = [[[_clips objectAtIndex:i] tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
             
             CMTime startTime = kCMTimeZero;//clipAudioTrack.timeRange.start;
             CMTime endTime = clipAudioTrack.timeRange.duration;
             
             CMTime startFadeInTime = startTime;
             CMTime endFadeInTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(endTime)-0.3, 600);
             CMTimeRange fadeInTimeRange = CMTimeRangeFromTimeToTime(startFadeInTime, endFadeInTime);
             NSLog(@"fadeInTimeRange start = %f  duration = %f",CMTimeGetSeconds(fadeInTimeRange.start), CMTimeGetSeconds(fadeInTimeRange.duration));
             
             CMTime startFadeOutTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(endTime)-0.3, 600);
             CMTime endFadeOutTime = endTime;
             CMTimeRange fadeOutTimeRange = CMTimeRangeFromTimeToTime(startFadeOutTime, endFadeOutTime);
             NSLog(@"fadeOutTimeRange start = %f  duration = %f",CMTimeGetSeconds(fadeOutTimeRange.start), 0.3);
             
             // Add AudioMix to fade in the volume ramps compositionAudioTracks[alternatingIndex]
             AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:clipAudioTrack];
             // fade in
             //            [trackMix1 setVolume:0.0 atTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(startTime)-0.1, 600)];
             [trackMix1 setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:fadeInTimeRange];
             [trackMix1 setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:fadeOutTimeRange];
             
             [trackMixArray addObject:trackMix1];
             
             //            AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTracks[1]];
             // fade out
             //            [trackMix2 setVolumeRampFromStartVolume:0.6 toEndVolume:0.0 timeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, passThroughTimeRanges[i].duration)];
             //			[trackMix2 setVolumeRampFromStartVolume:0.6 toEndVolume:0.6 timeRange:passThroughTimeRanges[i]];
             
             //            [trackMixArray addObject:trackMix2];
             */
            
            // Add AudioMix to fade in the volume ramps
            AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTracks[0]];
            
            [trackMix1 setVolumeRampFromStartVolume:0 toEndVolume:1 timeRange:transitionTimeRanges[i]];
            
            [trackMixArray addObject:trackMix1];
            
            AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTracks[1]];
            //			[trackMix2 setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:transitionTimeRanges[0]];
            [trackMix2 setVolumeRampFromStartVolume:1.0 toEndVolume:1.0 timeRange:passThroughTimeRanges[i]];
            [trackMixArray addObject:trackMix2];
        }
        
    }
    //    NSLog(@"trackMixArray = %@",trackMixArray);
    audioMix.inputParameters = trackMixArray;
    videoComposition.instructions = instructions;
}

// 视频合成
- (void)mergeVideoWithURLItems:(NSArray *)urlItem result:(MergeVideoResult)result {
    if (urlItem.count == 1) {
        // export
        NSString *fileString = [self getFinishVideoFilePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileString]) {
            // Remove Existing File
            NSError *error;
            if ([fileManager removeItemAtPath:fileString error:&error] == NO) {
                NSLog(@"removeItemAtPath %@ error:%@", fileString, error);
                if (result) {
                    result(NO,nil,[error localizedDescription]);
                }
                return;
            }
        }
        NSURL *recordVideoURL = [urlItem firstObject];
        NSURL *finishVideoURL = [NSURL fileURLWithPath:fileString];
        //        NSString *recordVideoFile = [recordVideoURL absoluteString];
        //        NSLog(@"recordVideoFile = %@",recordVideoFile);
        NSError *moveError;
        if (![fileManager copyItemAtURL:recordVideoURL toURL:finishVideoURL error:&moveError]) {
            NSLog(@"copyItemAtURL %@ toURL = %@ error:%@", recordVideoURL,finishVideoURL, moveError);
            if (result) {
                result(NO,nil,[moveError localizedDescription]);
            }
            return;
        }
        //        if (![fileManager moveItemAtURL:recordVideoURL toURL:finishVideoURL error:&moveError]) {
        //            NSLog(@"moveItemAtURL %@ toURL = %@ error:%@", recordVideoURL,finishVideoURL, moveError);
        //            if (result) {
        //                result(NO,nil,[moveError localizedDescription]);
        //            }
        //            return;
        //        }
        if (result) {
            result(YES,finishVideoURL,nil);
        }
    }
    else {
        AVMutableComposition *composition = [AVMutableComposition composition];
        
        AVMutableVideoComposition *videoComposition = videoComposition = [AVMutableVideoComposition videoComposition];
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        
        // 构建 video composition
        [self buildTransitionComposition:composition
                     andVideoComposition:videoComposition
                             andAudioMix:audioMix
                                urlItems:urlItem];
        //    NSLog(@"audioMix = %@",audioMix);
        if (videoComposition) {
            // Every videoComposition needs these properties to be set:
            videoComposition.frameDuration = CMTimeMake(1, kTimeScale); // 30 fps
        }
        
        // export
        NSString *fileString = [self getFinishVideoFilePath];
//        NSLog(@"***fileString---***%@",fileString);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileString]) {
            // Remove Existing File
            NSError *error;
            if ([fileManager removeItemAtPath:fileString error:&error] == NO) {
                NSLog(@"removeItemAtPath %@ error:%@", fileString, error);
                if (result) {
                    result(NO,nil,[error localizedDescription]);
                }
                return;
            }
        }
        
        NSURL *fileURL = [NSURL fileURLWithPath:fileString];
        
        NSString *mp4Quality = AVAssetExportPresetHighestQuality;//kRecordVideoCompressRatio;
        //    if ([PublicObject isNeedLongTransitionTime]) {
        //        // 是否需要过度时间
        //        mp4Quality = AVAssetExportPreset640x480;
        //    }
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:mp4Quality];
        __weak AVAssetExportSession *wExporter = exporter;
        NSParameterAssert(exporter != nil);
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.outputURL = fileURL;
        exporter.videoComposition = videoComposition;
        exporter.audioMix = audioMix;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            switch ([wExporter status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [wExporter error]);
                    if (result) {
                        result(NO,nil,[[wExporter error] localizedDescription]);
                    }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    if (result) {
                        result(NO,nil,@"视频合成取消！");
                    }
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Export successfully");
                    if (result) {
                        result(YES,fileURL,nil);
                    }
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)stopedForce
{
    [self endCapture];
    //    [self showAlert:kMaxSecondAlertString];
}

- (void)resetStatus
{
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
    
    if (_progressView) {
        [_progressView resetProgress];
    }
    self.recordSeconds = 0;
    _recordFrame = 0;
    _nextBtnIsSelected = NO;
}

- (void)handleRecordTime:(id)captureedVideoSescond
{
    
    //    NSLog(@"handleRecordTime");
    _eachPartRecordFrame ++;
    _recordFrame ++;
    if (_recordFrame > _maxFrame) {
        [self stopedForce];
        return;
    }
    
    if (_isPauseRecord) {
        float remainFrame = _maxFrame - _recordFrame;  // 剩余frame
        //        NSLog(@"remainFrame = %f",remainFrame);
        //        NSLog(@"kMixSegRecordFrame = %f",kMixSegRecordFrame);
        // 暂停录制，判断录制的帧数是否小于 最小录制帧数 小于的话 默认继续录制直到等于为止
        if (_eachPartRecordFrame >= _mixSegRecordFrame && remainFrame >= _mixSegRecordFrame) {
            // 暂停录制
            [self endCapture];
        }
    }
    CGFloat p = (CGFloat)(_recordFrame / _maxFrame);
    _progressView.progress = p;
}

// 停止计算时间
- (void)stopComputingRecordingTime
{
    //    [_progressView setIsStop:YES];
    [_recordFrameItems addObject:[NSNumber numberWithFloat:_recordFrame]];
}

- (void)showCoverView
{
    _isShowCoverView = YES;
    [self showRecordViewAnimation];
}

- (void)hiddenCoverView
{
    [_cameraCoverView startAnimate];
    _isShowCoverView = NO;
    [self setTakeButtonEnabled:NO];
}

- (void)showRecordViewAnimation
{
    //NSLog(@"showRecordView");
    [_cameraCoverView startAnimate];
    [self performSelector:@selector(resetCameraCoverView) withObject:nil afterDelay:0.5];
}

- (void)resetCameraCoverView
{
    _cameraCoverView.hidden = YES;
    [self setTakeButtonEnabled:YES];
}


#pragma mark PBJVision methods

- (void)startCameraPreview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_recordEngine startPreview];
    });
}

- (void)stopCameraPreview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_recordEngine stopPreview];
    });
}

- (void)unfreezePreview
{
    [_recordEngine unfreezePreview];
}

- (void)freezePreview
{
    [_recordEngine freezePreview];
}

- (void)setUpCapture
{
    PBJCameraMode cameraMode = PBJCameraModePhoto;
    PBJOutputFormat outputMode = PBJOutputFormatPreset;
    BOOL shouldShowGLContext = NO;
    
    if (self.recordType == RecordTypeVideo) {
        cameraMode = PBJCameraModeVideo;
        outputMode = PBJOutputFormatSquare;
        shouldShowGLContext = YES;
    }
    _recordEngine = [[PBJVision alloc] initWithShowGLContext:shouldShowGLContext];
    _recordEngine.delegate = self;
    _recordEngine.cameraDevice = PBJCameraDeviceBack;
    _recordEngine.cameraOrientation = PBJCameraOrientationPortrait;
    _recordEngine.focusMode = PBJFocusModeContinuousAutoFocus;
    _recordEngine.outputFormat = outputMode;
    //    _recordEngine.captureDirectory = [self docDir];
    [_recordEngine setCameraMode:cameraMode];
    if (cameraMode == PBJCameraModeVideo) {
        [_recordEngine setVideoRenderingEnabled:YES];
    }
}

- (void)startCapture
{
    if (self.recordType == RecordTypePhoto) {
        [self setTakeButtonEnabled:NO];
        [_recordEngine capturePhoto];
    }
    else if (self.recordType == RecordTypeVideo) {
        [self resetStatus];
        _recordEngine.outputURL = [NSURL fileURLWithPath:[self getRecordVideoFilePath]];
        [_recordEngine startVideoCapture];
    }
}

- (void)pauseCapture
{
    if (self.recordType == RecordTypeVideo) {
        [_recordEngine pauseVideoCapture];
    }
}

- (void)resumeCapture
{
    if (self.recordType == RecordTypeVideo) {
        [_recordEngine resumeVideoCapture];
    }
}

- (void)endCapture
{
    if (self.recordType == RecordTypeVideo) {
        [_recordEngine endVideoCapture];
    }
}

#pragma mark NSNotification

- (void)applicationDidEnterBackgroundNotification
{
    [[VideoObjectList sharedVideoList] saveVideoObject:self.videoObject];
    [self.videoObject saveToFile:nil];//把video保存到file中
}

- (void)ReceiveFinishResignPushNotification
{
    [self showRecordGuideView];
}

#pragma mark RecordVideoButton delegate

-(void)recordVideoBtn:(RecordVideoButton *)recordBtn recognizer:(UIGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = recognizer.state;
    if (state == UIGestureRecognizerStateChanged) {
        NSLog(@"正在录制");
        
        return;
    }
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateEnded) {
        if (self.videoObject.videoClips.count >= 60) {//视频长度不可以超过60秒 可以发布了！
            __weak VideoRecordViewController *bself = self;
            [PublicObject showAlertViewWithTitle:nil message:SVLocalizedString(@"record video max second", nil) cancelTitle:SVLocalizedString(@"publish", nil) otherTitle:SVLocalizedString(@"cancel", nil) completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex==0) {//点击了发布
                    [bself performSelector:@selector(nextAction) withObject:nil afterDelay:0.3];
                }
            }];
            return;
        }
        
        _isPauseRecord = NO;
        _eachPartRecordFrame = 0;
        if (!_recording) {
            NSLog(@"开始录制");
            [self makeActionEventEnable:NO];
            [_videoClipsView setUnableUseEditBtn];//禁用其他按钮防止录制时间不足一秒
            [self startCapture];
        }else {
            NSLog(@"正在录制");
        }
    }
    else {
        NSLog(@"state changed");
        if (_eachPartRecordFrame < _mixSegRecordFrame) {
            _isPauseRecord = YES;
        }
        else {
            float remainFrame = _maxFrame - _recordFrame;  // 剩余frame
            // 暂停录制，判断录制的帧数是否小于最小录制帧数,小于的话默认继续录制直到等于为止
            if (remainFrame >= _mixSegRecordFrame) {
                // 暂停录制
                _isPauseRecord = NO;
                [self endCapture];
            }
            else {
                _isPauseRecord = YES;
            }
        }
    }
    _isLocal = NO;
}


#pragma mark - PBJVisionDelegate

- (void)visionSessionDidStart:(PBJVision *)vision
{
    if (!_isShowCoverView) {
        if (!_recordEngine.isFlashAvailable) {
            [_recordEngine setFlashMode:PBJFlashModeOff];
            [self setFlashButtonStatus:PBJFlashModeOff];
        }
        else {
            if (_recordEngine.flashMode == PBJFlashModeOff) {
                [_recordEngine setFlashMode:PBJFlashModeOff];
                [self setFlashButtonStatus:PBJFlashModeOff];
            }
            else if (_recordEngine.flashMode == PBJFlashModeAuto) {
                [_recordEngine setFlashMode:PBJFlashModeAuto];
                [self setFlashButtonStatus:PBJFlashModeAuto];
            }
            else {
                [_recordEngine setFlashMode:PBJFlashModeOn];
                [self setFlashButtonStatus:PBJFlashModeOn];
            }
        }
        [self showCoverView];
    }
    else {
        [self setTakeButtonEnabled:YES];
    }
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
    //    NSLog(@"visionSessionDidStop");
}
// focus / exposure

- (void)visionWillStartFocus:(PBJVision *)vision
{
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(500, 0, 0, 0)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderWidth = 1.f;
        _focusView.layer.borderColor = [UIColor yellowColor].CGColor;
        [_previewView addSubview:_focusView];
        self.focusPoint = CGPointMake(_previewView.width / 2.f, _previewView.height / 2.f);
    }
    _focusView.hidden = NO;
    CGSize oSize = CGSizeMake(120, 120);
    CGSize fSize = CGSizeMake(65, 65);
    _focusView.frame = CGRectMake(self.focusPoint.x - oSize.width / 2.f, self.focusPoint.y - oSize.height / 2.f, oSize.width, oSize.height);
    [UIView animateWithDuration:0.15 animations:^{
        _focusView.frame = CGRectMake(self.focusPoint.x - fSize.width / 2.f, self.focusPoint.y - fSize.height / 2.f, fSize.width, fSize.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)visionDidStopFocus:(PBJVision *)vision
{
    _focusView.hidden = YES;
}

- (void)visionDidChangeExposure:(PBJVision *)vision
{
    
}

// video capture
- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    _recording = YES;
    //    NSLog(@"visionDidStartVideoCapture");
}

// video capture progress
- (void)visionDidCaptureVideoSample:(PBJVision *)vision
{
    if (_recording && self.recordVideoBtn.userInteractionEnabled) {
        [self handleRecordTime:nil];
    }
}

// video
- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    [self makeActionEventEnable:YES];
    [_videoClipsView setAbleUseEditBtn];
    NSLog(@"结束录制");
    _recording = NO;
    if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    _recordEngine.isCanReleaseContext = YES;
    
    // 视频地址
    NSString *videoPath = [videoDict objectForKey:PBJVisionVideoPathKey];
    VideoClipObject *videoClip = [VideoClipObject objectWithVideoUrl:videoPath];//只有一个视频地址的属性
    [self.videoObject.videoClips addObject:videoClip];
    
    //录制一段就保存到未完成的一段里去
//    [[VideoObject unFinishedVideoInstance] deleteUnfinishedVideoInfo];
//    [[VideoObjectList sharedVideoList] saveVideoObject:self.videoObject];
//    [self.videoObject saveToFile:nil];
    
    self.deleteButton.hidden = NO;
    self.publishVideoLinkBtn.hidden = YES;
    _deleteVideoAlertLabel.hidden = NO;
    
    _videoClipsView.videoClips = self.videoObject.videoClips.objectArray;//在此处录制后增加一个片段
    [_videoClipsView scroolToBottomAnimation:YES];
    
    [self updateVideoTime];
    // 录制已满60秒，提示用户点击下一步
    if (self.videoObject.videoClips.count >= 60) {
        __weak VideoRecordViewController *bself = self;
        [PublicObject showAlertViewWithTitle:nil message:SVLocalizedString(@"reach the max video max second", nil) cancelTitle:SVLocalizedString(@"publish", nil) otherTitle:SVLocalizedString(@"cancel", nil) completion:^(BOOL cancelled, NSInteger buttonIndex) {
            if (buttonIndex==0) {//点击了发布
                [bself performSelector:@selector(nextAction) withObject:nil afterDelay:0.3];
            }
        }];
    }
}
// photo cature

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    [self setTakeButtonEnabled:YES];
    if (error) {
        NSLog(@"error = %@",[error description]);
        return;
    }
    
    UIImage *takeImage = [photoDict objectForKey:@"PBJVisionPhotoImageKey"];// 有方向属性
    //    NSLog(@"takeimage seize = %@",NSStringFromCGSize(takeImage.size));
    //    takeImage = [takeImage cropToSize:CGSizeMake(kPreviewWidth, _previewView.height)];
    takeImage = [takeImage fixOrientation];
    if (!takeImage) {
        NSLog(@"拍摄图片回调为空");
        [MBProgressHUD showHUDOnlyTextAddedTo:kKeyWindow
                                    labelText:UPLocalizedString(@"system error, please quit and try again!", nil)//@"系统出错，请退出重试！"
                                   afterDelay:kStayTime];
        NSLog(@"error = %@",error);
        return;
    }
//    UPAsset *asset = [[UPAsset alloc] init];
//    asset.userImage = takeImage;
//    
//    [_recordEngine stopPreview];
//    
//    if ([self.delegate respondsToSelector:@selector(recordVideoController:didFinishCapturePhotoWithInfo:)]) {
//        [self.delegate recordVideoController:self didFinishCapturePhotoWithInfo:asset];
//    }
}


// cannotGetFrontCamera error
- (void)cannotGetFrontCamera:(NSError *)error
{
    self.rotateCameraButton.userInteractionEnabled = NO;
}

// cannotGetBackCamera
- (void)cannotGetBackCamera:(NSError *)error
{
    [self setTakeButtonEnabled:NO];
    self.rotateCameraButton.userInteractionEnabled = NO;
    self.flashButton.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showError:@"请在 “设置” > “隐私” > “相机” 中允许uper访问相机"];//@"请在 “设置” > “隐私” > “相机” 中允许uper访问相机"];
    });
}

// cannotGetAudioDevice
- (void)cannotGetAudioDevice:(NSError *)error
{
    if (self.recordType == RecordTypeVideo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showError:@"请在 “设置” > “隐私” > “麦克风” 中允许uper访问麦克风"];//@"请在 “设置” > “隐私” > “麦克风” 中允许uper访问麦克风"];
        });
        self.recordVideoBtn.userInteractionEnabled = NO;
        self.rotateCameraButton.userInteractionEnabled = NO;
        self.flashButton.userInteractionEnabled = NO;
        self.foldoverButton.userInteractionEnabled = NO;
    }
}


#pragma mark add watermark delegate

- (void)doFinishCapturePhotoWithInfo:(id)info
{
    if ([self.delegate respondsToSelector:@selector(recordVideoController:didFinishCapturePhotoWithInfo:)]) {
        //        if (self.selectedPhotoArray == nil) {
        //            self.selectedPhotoArray = [NSMutableArray array];
        //        }
        //        [self.selectedPhotoArray addObject:info];
        [self.delegate recordVideoController:self didFinishCapturePhotoWithInfo:info];
    }
}

//- (void)addWatermark:(AddWatermarkController *)addWatermarkVC didFinishGenerateWatermark:(NSArray *)photoItems
//{
//    [self doFinishCapturePhotoWithInfo:photoItems];
//}
//
//- (void)addWatermarkDidCancel:(AddWatermarkController *)addWatermarkVC
//{
//    [addWatermarkVC.navigationController popViewControllerAnimated:YES];
//}


#pragma mark - UPImagePickerControllerDelegate

//- (void)imagePickerController:(UPImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
//{
//    if (![info isKindOfClass:[UPAsset class]]) {
//        return;
//    }
//    __weak VideoRecordViewController *bself = self;
//    [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
//    UPAssetManager *assetManager = [UPAssetManager sharedManager];
//    NSString *filePath = [self getFinishVideoFilePath];
//    NSURL *outputURL = [NSURL fileURLWithPath:filePath];
//    [assetManager exportVideoForAsset:info outputURL:outputURL completionHandler:^(BOOL success) {
//        [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
//        if (success) {
//            [bself showSelectCoverControllerWithVideoURL:outputURL saveToAlbum:NO];
//        }
//    }];
//}
//
//
//- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
//{
//    if (imagePickerController.presentingViewController) {
//        [imagePickerController dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
//    else {
//        [imagePickerController.navigationController popViewControllerAnimated:YES];
//    }
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
//{
//    return [NSString stringWithFormat:UPLocalizedString(@"%d photos", nil), numberOfPhotos];//@"%d 张照片"
//}

#pragma mark - SelectVideoCoverController delegate

- (void)selectedVideoCoverWithThumbnail:(UIImage *)thumbnail videoUrl:(NSURL *)videoUrl videoSecond:(double)second
{
    if (self.recordType != RecordTypeVideo) {
        return;
    }

    // 停止视频渲染
    [self stopCameraPreview];
    
    FinishVideoObject *finishVideoObject = [FinishVideoObject newFinishVideo];
    finishVideoObject.videoThumbnailImage = thumbnail;
    finishVideoObject.videoURL = [videoUrl absoluteString];
    finishVideoObject.videoLength = [NSString stringWithFormat:@"%d",(int)second];
    finishVideoObject.videoObject = self.videoObject;
    
    [[FinishVideoObjectList sharedFinishVideoList] saveFinishVideoObject:finishVideoObject];
    
    //从新保存完成视频的地址
    NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
    [videoData writeToFile:[finishVideoObject finishVideoFilePath] atomically:YES];
    
    //将封面图片存储起来
    NSData *imagedata;
    if (UIImagePNGRepresentation(thumbnail) == nil) {
        imagedata = UIImageJPEGRepresentation(thumbnail, 1);
    } else {
        imagedata = UIImagePNGRepresentation(thumbnail);
    }
    [imagedata writeToFile:[finishVideoObject coverfinishVideoFilePath] atomically:YES];
    
    //存储视频个数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *countStr = [NSString stringWithFormat:@"%@_clips_count",[NSURL fileURLWithPath:[finishVideoObject finishVideoFilePath].lastPathComponent]];
    [user setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.videoObject.videoClips.count] forKey:countStr];
    [user synchronize];
    
    
    PublishVideoViewController *publish = [[PublishVideoViewController alloc]init];
    publish.finishVideo = finishVideoObject;
    publish.finishVideoUrlStr = [finishVideoObject finishVideoFilePath];
    publish.coverImagePath = [finishVideoObject coverfinishVideoFilePath];
    publish.publishType = PublishBothSaveAndShare;
    [self.navigationController pushViewController:publish animated:YES];
    
    NSString *secondVideoLength = [NSString stringWithFormat:@"%d",(int)second];
    //统计已完成一秒视频的长度
    [EventCounting countEvent:k_completedVideoLength_count label:secondVideoLength];
}

#pragma mark
#pragma mark UIGestureRecognizer delegate
//点击聚焦
// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    // old pbvsion
    CGPoint tapPoint = [gestureRecognizer locationInView:_previewView];
    self.focusPoint = tapPoint;
    CGPoint convertedFocusPoint = [_previewLayer captureDevicePointOfInterestForPoint:tapPoint];
    [_recordEngine autoFocusAtPoint:convertedFocusPoint];
    [self performSelector:@selector(changeToContiniuFocusAtPoint) withObject:nil afterDelay:0.5];
}

- (void)changeToContiniuFocusAtPoint
{
    [_recordEngine continuousFocusAtPoint:CGPointMake(0.5, 0.5)];
}
#pragma mark- RecordVideoClipView Delegate
//进入编辑界面
- (void)recordVideoClipsView:(RecordVideoClipsView *)recordVideoClipView didSelectedEditCell:(VideoClipEditCell *)editCell
{
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
    VideoClipEditViewController *videoClipEditVC = [[VideoClipEditViewController alloc] init];
    videoClipEditVC.videoObject = self.videoObject;
    videoClipEditVC.delegate = self;
    [self.navigationController pushViewController:videoClipEditVC animated:YES];
}
//切换视频片段
- (void)recordVideoClipsView:(RecordVideoClipsView *)recordVideoClipView didSelectedVideoClipCell:(VideoClipCell *)videoClipCell
{
    [_videoClipPlayView hide];
}
//播放单个视频片段
- (void)recordVideoClipsView:(RecordVideoClipsView *)recordVideoClipView didSelectedVideoClipPlayCell:(VideoClipCell *)videoClipCell
{
    if (_videoClipPlayView.isPlaying) {
        return;
    }
    NSInteger index = [self.videoObject.videoClips.objectArray indexOfObject:videoClipCell.videoClipObject];
    [_videoClipPlayView playWithVideoClipObject:videoClipCell.videoClipObject videoClipIndex:index];
    [_videoClipsView changeVideoClipStateToStop];
}

#pragma mark- VideoClipPlayView Delegate
//单个视频播放完成后点击删除按钮
- (void)recordVideoClipPlayViewDidSelectedDeleteAction:(RecordVideoClipPlayView *)videoClipPlayView
{
    [self removeRecordVideoClipObject:_videoClipPlayView.videoClipObject];
    [_videoClipPlayView hide];
}

- (void)recordVideoClipPlayViewDidSelectedSaveAction:(RecordVideoClipPlayView *)videoClipPlayView
{
    [_videoClipPlayView hide];
    [_videoClipsView changeVideoClipStateToPlay];
}
//单个视频播放到最后
- (void)recordVideoClipPlayViewDidVideoItemReachEnd:(RecordVideoClipPlayView *)videoClipPlayView
{
    [_videoClipsView changeVideoClipStateToPlay];
}

#pragma mark- VideoDraftViewController Delegate Method
//选择草稿箱的视频片段集合
- (void)videoDraftViewController:(VideoDraftViewController *)videoDraftController didSelectedVideoObject:(VideoObject *)videoObject
{
    if ([self.videoObject.videoId isEqualToString:videoObject.videoId]) {
        return;
    }
    [self resetRecordVideoViewWithVideoObject:videoObject];
}
//删除草稿箱的视频集合
- (void)videoDraftViewController:(VideoDraftViewController *)videoDraftController willDeleteVideoObject:(VideoObject *)videoObject
{
    if ([self.videoObject.videoId isEqualToString:videoObject.videoId]) {
        [self resetRecordVideoViewWithVideoObject:[VideoObject newVideo]];
    }
}
//新建一个视频草稿箱
- (void)videoDraftViewController:(VideoDraftViewController *)videoDraftController didCreatNewVideoObject:(VideoObject *)videoObject
{
    [self resetRecordVideoViewWithVideoObject:[VideoObject newVideo]];
}


#pragma mark- VideoClipEditViewController Delegate Method
//取消编辑
- (void)videoClipEditViewControllerDidCancelEdit
{
    [self resetRecordVideoViewWithVideoObject:self.videoObject];
    [self saveRecordVideo];
}
//没用到
- (void)videoClipEditViewControllerDidDoneEdit
{
    [self resetRecordVideoViewWithVideoObject:self.videoObject];
}

@end
