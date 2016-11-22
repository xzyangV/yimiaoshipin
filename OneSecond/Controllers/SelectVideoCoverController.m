//
//  PlayViewController.m
//  videoCapture
//
//  Created by zhangyx on 13-8-7.
//  Copyright (c) 2013年 zhangyx. All rights reserved.
//

#import "SelectVideoCoverController.h"
#import "SelectSongViewController.h"
#import "PublishVideoViewController.h"
// view
#import "TranslucentButton.h"
#import "GPUImage.h"
#import "UPImage.h"
#import "UPImageFilter.h"
#import "UPFilterToolBar.h"

// model
#import "UPAssetManager.h"
#import "EventCounting.h"
#import "DBManager.h"
#import "MusicObject.h"
#import "FinishVideoObject.h"
// public
#import "RecordVideoDefine.h"
#import "UPGuide.h"
#import "MBProgressHUD+CMBProgressHUD.h"
#import "UIImage-Extension.h"
#import "UINavigationItem+Support_ios7.h"
#import "UPDownloadManager.h"
#import "GiFHUD.h"

#import <MediaPlayer/MediaPlayer.h>
#import <ImageIO/ImageIO.h>


#define kThumbnailViewHeight 30
#define kThumbnailViewCount 8
#define kFilterViewHeight 85.f

#define kMusicTitleColor ColorForHex(0x777777)

#define kAddMusicImageN [UIImage imageNamed:@"add_music_icon_n"]
#define kAddMusicImageS [UIImage imageNamed:@"add_music_icon_se"]

#define kSoundImageN [UIImage imageNamed:@"sound_icon_n"]
#define kSoundImageS [UIImage imageNamed:@"sound_icon_s"]

#define kDegreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface SelectVideoCoverController () <MPMediaPickerControllerDelegate,UPFilterToolBarDelegate> {
    
    UIView *_topBackGroundView;
    ThumbnailPickerView *_thumbnailPickerView;
    UIView *_coverView;
    NSMutableArray *imageItems;
    NSMutableArray *_audioMixParams;
    AVAudioPlayer *_audioPlayer;
    
    UIImageView *_selectedMusicIcon;
    UIButton *_addMusicIcon;
    
    UILabel *_selectedMusicLabel;
    
    UIImageView *_videoPlayMarkView;
//    MBSwitch *_soundSwitch;
    UILabel *_soundLabel;
    UIButton *_soundButton;

    double _videoSecond;
    BOOL isFirstLoadView;
    BOOL _isMixAudio;  // 是否开启原音
    UIBarButtonItem *rightBarItem;
    TranslucentButton *_rightbtn;
    BOOL isCancelFilter;//标示是否进入后台 取消滤镜
    BOOL isClickDoneBtn;//标示是否点击了下一步
    BOOL isIntoMusic;   //标示是否进入音乐列表
}

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSURL *originalFileURL;
@property (nonatomic, strong) NSURL *filterURL;
@property (nonatomic, strong) NSURL *fadeSoundURL;
@property (nonatomic,strong)  MusicObject *selectMusicObject;

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) UIButton *selectedMusicBtn;

// 添加滤镜相关
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) GPUImageView *videoView;
@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, assign) UPImageFilterType currentFilterType;
@property (nonatomic, strong) UPFilterToolBar *toolBar;

@end

@implementation SelectVideoCoverController

- (id)initWithFileUrl:(NSURL *)file_url
{
    self = [super init];
    if (self) {
        isIntoMusic = NO;
        isCancelFilter = NO;
        isClickDoneBtn = NO;
        isFirstLoadView = YES;
        _isMixAudio = YES;
        self.fileURL = file_url;
//        self.filterURL = file_url;
        imageItems = [[NSMutableArray alloc] init];
        _audioMixParams = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                                                 selector:@selector(applicationWillEnterForegroundNotification)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)applicationDidEnterBackgroundNotification
{
    [self stop:nil];
    if (self.movieFile) {
        [self.movieFile cancelProcessing];
        isCancelFilter = YES;
    }
  
}

- (void)applicationWillEnterForegroundNotification
{
    isIntoMusic = NO;
    if (self.movieFile) {
        if (isClickDoneBtn == YES) {
            NSLog(@"下一步合成中");
        }else if(isClickDoneBtn == NO){
            NSLog(@"播放界面");
            [self.movieFile startProcessing];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackGroundColor;
//    self.view.clipsToBounds = YES;

    // 去掉 navigationBar 阴影
    [PublicObject removeNavigationBarShadowImage:self.navigationController];

    self.navigationItem.title = SVLocalizedString(@"video preview", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:15],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 返回按钮
    UIBarButtonItem *backItem = [BizCommon barBackBtnWithTitle:UPLocStr(@"back")
                                                   clickTarget:self
                                                        action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _rightbtn = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    _rightbtn.frame = CGRectMake(0, 0, 60, 32);
    [_rightbtn setTitle:SVLocalizedString(@"next", nil) forState:UIControlStateNormal];
    _rightbtn.titleLabel.font = kBarBtnFont;
    _rightbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightbtn setTitleColor:ColorForRGB(153, 153, 153, 1) forState:UIControlStateDisabled];
    [_rightbtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightbtn];
    [self.navigationItem addRightBarButtonItem:rightBarItem];
    
    _topBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    _topBackGroundView.backgroundColor = kBackGroundColor;
    [self.view addSubview:_topBackGroundView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = kBackGroundColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirstLoadView) {
        isFirstLoadView = NO;
        // 加载页面
        [self buildVideoPreview];
        // 获取视频缩略图片
        [self getMovieImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!isIntoMusic) {
        self.movieFile = nil;
        isClickDoneBtn = NO;
    }
 
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Build View


- (void)buildVideoPreview
{
    // 渲染显示视频视图
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0,_topBackGroundView.bottom, self.view.width, self.view.width)];
    playerView.backgroundColor = ColorForRGB(54.0, 54.0, 54.0, 1.0);
    playerView.clipsToBounds = YES;
    [self.view addSubview:playerView];
    
    //左右滑动切换滤镜
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handelSwipeFrom:)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [playerView addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handelSwipeFrom:)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [playerView addGestureRecognizer:leftRecognizer];
    
    self.videoView = [[GPUImageView alloc] initWithFrame:playerView.bounds];
    self.videoView.backgroundColor = [UIColor blackColor];
    [playerView addSubview:self.videoView];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:self.fileURL];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    // 视频播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];

    //GUPImageMovie
    self.movieFile = [[GPUImageMovie alloc] initWithPlayerItem:self.playerItem];
//    self.movieFile.runBenchmark = YES;
    self.movieFile.playAtActualSpeed = YES;
    self.currentFilterType = UPImageFilter_normal;
    GPUImageFilter *filter = [UPImageFilter filterWithType:self.currentFilterType];
    [self.movieFile addTarget:filter];
    
    GPUImageView *filterView = (GPUImageView *)self.videoView;
    [filter addTarget:filterView];
    [self.movieFile startProcessing];
    
//    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
//    avPlayerLayer.frame = CGRectMake(0, 0, playerView.width, playerView.height);
//    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    [playerView.layer addSublayer:avPlayerLayer];
//    [self.view addSubview:playerView];
    
    // 播放视频标识
    UIImage *videoPlayMarkImage = kVideoPlayIcon100;
    _videoPlayMarkView = [[UIImageView alloc] initWithFrame:CGRectMake((playerView.width-videoPlayMarkImage.size.width)/2, (playerView.height-videoPlayMarkImage.size.height)/2, videoPlayMarkImage.size.width, videoPlayMarkImage.size.height)];
    _videoPlayMarkView.backgroundColor = [UIColor clearColor];
    _videoPlayMarkView.image = videoPlayMarkImage;
    _videoPlayMarkView.hidden = YES;
    [playerView addSubview:_videoPlayMarkView];

    // 控制视频的播放与暂停
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    [playerView addGestureRecognizer:tap];
    
    CGFloat butonSize = 44;
    _soundButton = [[UIButton alloc] initWithFrame:CGRectMake(playerView.right - 20 - butonSize,10, butonSize, butonSize)];
    _soundButton.backgroundColor = [UIColor clearColor];
    [_soundButton setImage:kSoundImageN forState:UIControlStateNormal];
    [_soundButton setImage:kSoundImageS forState:UIControlStateSelected];
    [_soundButton addTarget:self action:@selector(sountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _soundButton.selected = YES;
    [playerView addSubview:_soundButton];

    _addMusicIcon = [[UIButton alloc] initWithFrame:CGRectMake(_soundButton.left - 10 - butonSize,_soundButton.top, butonSize, butonSize)];
    _addMusicIcon.backgroundColor = [UIColor clearColor];
    [_addMusicIcon setImage:kAddMusicImageN forState:UIControlStateNormal];
    [_addMusicIcon setImage:kAddMusicImageS forState:UIControlStateSelected];
    [_addMusicIcon addTarget:self action:@selector(addMusicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _addMusicIcon.contentMode = UIViewContentModeScaleAspectFit;
    [playerView addSubview:_addMusicIcon];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, playerView.bottom, self.view.width, 45)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = ColorForHex(0xd7d7d7);
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.text = SVLocalizedString(@"select cover", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    // 视频图片缩略图
    _thumbnailPickerView = [[ThumbnailPickerView alloc] initWithFrame:CGRectMake((kScreenWidth - 30 * 8) / 2, titleLabel.bottom, 30 * 8, kThumbnailViewHeight)];
    _thumbnailPickerView.pageEnabled = NO;
    _thumbnailPickerView.delegate = self;
    _thumbnailPickerView.dataSource = self;
    _thumbnailPickerView.selectedIndex = 0;
    [self.view addSubview:_thumbnailPickerView];
    
    _coverView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - 30 * 8) / 2, titleLabel.bottom, 30 * 8, kThumbnailViewHeight)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    _coverView.userInteractionEnabled = NO;
    [self.view addSubview:_coverView];
    
    //高亮的封面图
    self.selectedImage = [self getThumbnailImage:self.fileURL withTime:self.avPlayer.currentTime];
    UIImageView *firstImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    firstImageview.image = self.selectedImage;
    [_coverView addSubview:firstImageview];
    
    // 选择滤镜
    self.toolBar = [[UPFilterToolBar alloc] initWithFrame:CGRectMake(0, self.view.height - kFilterViewHeight , self.view.width, kFilterViewHeight)];
    self.toolBar.delegate = self;
    self.toolBar.backgroundColor = [UIColor clearColor];
    self.toolBar.filters = [UPImageFilter UPImageFilters];
    self.toolBar.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.toolBar];
    
    UILabel *filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.toolBar.top - 20, kScreenWidth, 15)];
    filterLabel.backgroundColor = [UIColor clearColor];
    filterLabel.text = SVLocalizedString(@"Filter", nil);
    filterLabel.textAlignment = NSTextAlignmentCenter;
    filterLabel.textColor =ColorForHex(0xd7d7d7);
    filterLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:filterLabel];
}

- (void)buildSelectMusicView:(MusicObject *)musicObject
{

    rightBarItem.enabled = NO;
    [_addMusicIcon setSelected:YES];
    
    // 获取最初的音频（itunes和服务器返回的音频文件）
    NSURL *sounURL = [NSURL fileURLWithPath:[musicObject musicFilePath]];
    if (musicObject.is_itunes_music) {
        sounURL = [NSURL URLWithString:musicObject.url];
    }
    
    // 当视频时长大于音频时长时，将音频以循环的方式对接起来
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:self.fileURL options:nil];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:sounURL options:nil];
    float videoDuration = CMTimeGetSeconds(videoAsset.duration);//视频时长
    float audioDuration = CMTimeGetSeconds(audioAsset.duration);//音频时长
    NSURL *audioURL = sounURL;
    if (videoDuration > audioDuration) {
        int count = (int)(videoDuration / audioDuration);
        NSMutableData *soundsData = [NSMutableData alloc];
        NSData *soundData = [[NSData alloc] initWithContentsOfURL:audioURL];
        for (int i = 0; i < count + 1; i++) {
            [soundsData appendData:soundData];
        }
        BOOL isWrite = [soundsData writeToFile:[self filePathWithName:@"tmp.mp3"] atomically:YES];
        if (isWrite) {
            audioURL = [NSURL fileURLWithPath:[self filePathWithName:@"tmp.mp3"]];
        }
    }
    __weak SelectVideoCoverController *bself = self;
    // 给音频加上淡出效果，将音频的最后三秒的声音由1到0，最终写入文件song.m4a
    NSURL* destinationURL = [NSURL fileURLWithPath:[self filePathWithName:@"song.m4a"]];
    [self makeAudioFadeOutWithSourceURL:audioURL destinationURL:destinationURL fadeOutBeginSecond:videoDuration - 3 fadeOutEndSecond:videoDuration fadeOutBeginVolume:1 fadeOutEndVolume:0 callBack:^(BOOL success) {
        if (success) {
            bself.fadeSoundURL = destinationURL;
            [bself playWithAudioUrl:destinationURL];
        }
    }];
}


#pragma mark button method


- (void)goBack
{
    [self stop:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

// 确定回传代理
- (void)doneAction:(id)sender
{
    isClickDoneBtn = YES;
    isCancelFilter = NO;
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    
    // 暂停播放
    [self stop:nil];
    __weak SelectVideoCoverController *bself = self;
    if (self.currentFilterType != UPImageFilter_normal) {// 加滤镜
        NSArray *imageArr = @[[UIImage imageNamed:@"compose1"],[UIImage imageNamed:@"compose2"],[UIImage imageNamed:@"compose3"],[UIImage imageNamed:@"compose4"],];
        [GiFHUD setGifWithImages:imageArr];
//        [GiFHUD show];//视频处理中...
        [GiFHUD showWithOverlay];
        // 生成加滤镜后的视频文件
        [self filterVideoWithUPImageFilterType:self.currentFilterType sourceFileURL:self.fileURL completionBlock:^(NSURL *filtedVideoURL) {
            
            if (filtedVideoURL) {
                if (isCancelFilter) {
                    button.enabled = YES;
                    [GiFHUD dismiss];
                    return;
                }
                [[NSFileManager defaultManager] removeItemAtURL:bself.fileURL error:nil];
                [[NSFileManager defaultManager] moveItemAtURL:filtedVideoURL toURL:bself.fileURL error:nil];
            }
            if (self.fadeSoundURL || !_isMixAudio) {
                [bself makeAudioWithAudioUrl:bself.fadeSoundURL];
            }
            else {
                [GiFHUD dismiss];
//                [self delegateCallBack];
                [bself delegateCallBackWithSingleAudio];

            }
            button.enabled = YES;
        }];
    }
    else{   // 没有加滤镜
        if (self.fadeSoundURL || !_isMixAudio) {
            [self makeAudioWithAudioUrl:self.fadeSoundURL];
        }
        else {
            
            [self delegateCallBackWithSingleAudio];
            
//            [self delegateCallBack];
        }
        button.enabled = YES;
    }
    
}

//单纯的更改视频的保存路径
- (void)delegateCallBackWithSingleAudio
{
    //从新保存完成视频的地址
    NSData *videoData = [NSData dataWithContentsOfURL:self.fileURL];
    NSString *path = [self selectCoverVideo];
    
    if ([videoData writeToFile:path atomically:YES]) {
//        self.fileURL = [NSURL fileURLWithPath:path];
        self.originalFileURL = [NSURL fileURLWithPath:path];
        [self delegateCallBack];
    }
}

- (NSString *)selectCoverVideo
{
    NSString *docpath =  [[DBManager getInstance] getCacheFolderPathWithFolderName:@"selectCoverVideo"];
    NSString *fileString = [docpath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[PublicObject generateNoLineUUID]]];
    return fileString;
}

- (void)closeOriginalSound:(BOOL)close
{
    if (close) {
        _isMixAudio = NO;
        [self setVideoVolume:0];
    }
    else{
        _isMixAudio = YES;
        [self setVideoVolume:1.f];
    }
}

- (void)addMusictoVideo:(MusicObject *)musicObject
{
        __weak SelectVideoCoverController *bself = self;

    MBProgressHUD *hud = [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:SVLocalizedString(@"Music Loading...", nil)  afterDelay:1000];//音乐加载中...
    hud.userInteractionEnabled = YES;
    BOOL isExist = [musicObject musicIsExist];
    if (isExist) {
        [self buildSelectMusicView:musicObject];
    }
    else{
//        MBProgressHUD *hud = [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:UPLocStr(@"Music Loading...")  afterDelay:1000];
//        hud.userInteractionEnabled = YES;
        rightBarItem.enabled = NO;
        [UPDownloadManager downloadFileWithURLStr:musicObject.url outputPath:[musicObject musicFilePath] rewrite:NO completionBlock:^(BOOL isSuccess, NSString *errorStr) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [bself buildSelectMusicView:musicObject];
        } progressChangedBlock:^(double progress) {
            
        }];
    }
}
// 选择音乐
- (void)addMusicBtnClicked:(id)sender
{
    [self.avPlayer pause];
    [_audioPlayer pause];
    [self showAddMusicSongsVC];
    [self updateVideoPlayMarkState];
}

- (void)showAddMusicSongsVC
{
    isIntoMusic = YES;
    __weak typeof(self)wSelf = self;
    SelectSongViewController *selectSong = [[SelectSongViewController alloc]init];
    selectSong.selectMusicBlock = ^(MusicObject *musicObject){//音乐列表
        wSelf.selectMusicObject = musicObject;
        [wSelf addMusictoVideo:musicObject];
    };
    
    selectSong.selectLocelMusicBlock = ^(){//本地音乐
        MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        mpc.delegate = self;
        mpc.prompt = UPLocalizedString(@"select backgound music", nil);//@"选择背景音乐";
        mpc.allowsPickingMultipleItems = NO;          //是否允许一次选择多个
        [wSelf presentViewController:mpc animated:YES completion:NULL];
    };
    
    selectSong.selectBlankMusicBlock = ^(){//无配音
        [wSelf clearSelectedMusic];
        rightBarItem.enabled = YES;
    };
    
    [self presentViewController:[PublicObject ncForVC:selectSong] animated:YES completion:nil];
}
// 清除选择音乐
- (void)clearSelectedMusic
{
    if (_audioPlayer) {
        [_audioPlayer pause];
        _audioPlayer = nil;
    }
    self.fadeSoundURL = nil;
    _addMusicIcon.selected = NO;
}

// 原音清除
- (void)sountBtnClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [self closeOriginalSound:YES];
    }
    else{
        [self closeOriginalSound:NO];
    }
    button.selected = !button.selected;
}
// 暂停、播放
- (void)tap
{
    // 重新播放
//    [self rePlay:nil];
    
    if (self.avPlayer) {
        if (self.avPlayer.rate == 0) {
            CGFloat currentTimeValue = CMTimeGetSeconds(self.avPlayer.currentTime);
            CGFloat totalTimeValue = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
            if (currentTimeValue - totalTimeValue >= 0) {
                [self.avPlayer seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)];
            }

            [self.avPlayer play];
        }else {
            [self.avPlayer pause];
        }
    }
    if (_audioPlayer) {
        if (_audioPlayer.isPlaying) {
            [_audioPlayer pause];
        }
        else {
            [_audioPlayer play];
            
        }
    }
    [self updateVideoPlayMarkState];
}

-(void)handelSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
//      NSLog(@"向左滑动");
        NSInteger index = _currentFilterType + 1;
//        NSLog(@"%ld",(long)index);
        if (index == [UPImageFilter UPImageFilters].count) {
            return;
        }
        [_toolBar setSelectedItemWithIndex:index];
        [self filterToolBar:_toolBar didSelctedFilterWithIndex:index];
//        _currentFilterType = (UPImageFilterType)index;

        
    }
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
//        NSLog(@"向右滑动");
        NSInteger index = _currentFilterType - 1;
        if (index < 0) {
            return;
        }
        [_toolBar setSelectedItemWithIndex:index];
//        _currentFilterType = (UPImageFilterType)index;
        [self filterToolBar:_toolBar didSelctedFilterWithIndex:index];
       
    }
    
}

- (void)updateVideoPlayMarkState
{
    if (self.avPlayer && self.avPlayer.rate == 0) {
        _videoPlayMarkView.hidden = NO;
    }
    else{
        _videoPlayMarkView.hidden = YES;
    }
}

- (void)delegateCallBack
{
    if (self.fadeSoundURL){
        [EventCounting countEvent:k_musicIsUsed_count label:self.selectMusicObject.name];//统计音乐使用次数
    }
    [[UPAssetManager sharedManager] writeVideoAtURL:self.originalFileURL completionHandler:NULL];//保存视频到相册
    
    if ([self.delegate respondsToSelector:@selector(selectedVideoCoverWithThumbnail:videoUrl:videoSecond:)]) {
        if (!self.selectedImage) {
            self.selectedImage = [self getThumbnailImage:self.originalFileURL withTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)];
        }
        if (self.currentFilterType != UPImageFilter_normal) {
            GPUImagePicture * imagePicture = [[GPUImagePicture alloc] initWithImage:self.selectedImage];
            self.selectedImage = [UPImageFilter filteredImageWithSourcePicture:imagePicture filterType:self.currentFilterType];
        }
        
        if (isCancelFilter) {//是否取消合成滤镜
            return;
        }
        [self.delegate selectedVideoCoverWithThumbnail:self.selectedImage videoUrl:self.originalFileURL videoSecond:_videoSecond];
    }
}

#pragma mark
#pragma mark 私有方法

- (NSString *)docDir
{
    return [[DBManager getInstance] getCacheFolderPathWithFolderName:kFinishVideoFoldreName];
}

- (void)refreshUI
{
    if ([imageItems count] != 0) {
        // 在主线程中刷新UI
        UIImage *tempImage = [self getThumbnailImage:self.fileURL
                                            withTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)];
        if (tempImage) {
            [imageItems replaceObjectAtIndex:0 withObject:tempImage];
        }
        [_thumbnailPickerView reloadData];
    }
    if (self.movieFile) {
        [self.movieFile startProcessing];
    }
    [self rePlay:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


// 设置视频音量
- (void)setVideoVolume:(float)volume
{
    NSArray *audioTracks = [self.avPlayer.currentItem.asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [self.avPlayer.currentItem setAudioMix:audioMix];
}

// 获取指定时间段视频图片
-(UIImage *)getThumbnailImage:(NSURL *)videoURL withTime:(CMTime)requestedTime
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
//    generator.maximumSize = CGSizeMake(600, 450);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    if (img != nil) {
        CFRelease(img);
    }
    return image;
}

// 获取视频缩略图
- (void)getMovieImage {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    float maxWidth = _thumbnailPickerView.width;
    float maxHeight = kThumbnailViewHeight-2;
    
    AVURLAsset *myAsset = [[AVURLAsset alloc] initWithURL:self.fileURL options:nil];
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime videoTime = [myAsset duration];
    _videoSecond = (double)videoTime.value/videoTime.timescale;
//    _videoSecond = ceil(tempScond);
    
    if ([PublicObject isRetina]){
        self.imageGenerator.maximumSize = CGSizeMake(maxWidth*2, maxHeight*2);
    }
    else {
        self.imageGenerator.maximumSize = CGSizeMake(maxWidth, maxHeight);
    }
    
    float picWidth = maxWidth / kThumbnailViewCount;
    
//    int picsCnt = ceil(maxWidth / picWidth);
    NSMutableArray *allTimes = [NSMutableArray array];
    int time4Pic = 0;
    for (int i = 1; i < kThumbnailViewCount+1; i++) {
        time4Pic = i*picWidth;
        CMTime timeFrame = CMTimeMakeWithSeconds(_videoSecond * time4Pic / maxWidth, 600);
        [allTimes addObject:[NSValue valueWithCMTime:timeFrame]];
    }
    __block int i = 1;
    __weak SelectVideoCoverController *wSelf = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:allTimes
                                              completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
                                                  
                                                  SelectVideoCoverController *bself = wSelf;
                                                  if (result == AVAssetImageGeneratorSucceeded) {
                                                      UIImage *videoScreen;
                                                      if ([PublicObject isRetina]) {
                                                          videoScreen = [UIImage imageWithCGImage:image scale:2.0 orientation:UIImageOrientationUp];
                                                      } else {
                                                          videoScreen = [UIImage imageWithCGImage:image];
                                                      }
                                                      [bself->imageItems addObject:videoScreen];
                                                      
                                                      if (i == [allTimes count]) {
                                                          // 在主线程中刷新UI
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [bself refreshUI];
                                                          });
                                                      }
                                                      i ++;
                                                  }else if (result == AVAssetImageGeneratorFailed) {
                                                      NSLog(@"获取视频image Failed with error: %@", [error localizedDescription]);
                                                      if (i == [allTimes count]) {
                                                          // 在主线程中刷新UI
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [bself refreshUI];
                                                          });
                                                      }
                                                      i ++;
                                                  }else if (result == AVAssetImageGeneratorCancelled) {
                                                      NSLog(@"获取视频image Canceled");
                                                      if (i == [allTimes count]) {
                                                          // 在主线程中刷新UI
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [bself refreshUI];
                                                          });
                                                      }
                                                      i ++;
                                                  }
                                              }];
}

// 合成音轨
- (void)setUpAndAddAudioAtPath:(AVURLAsset *)audioAsset toComposition:(AVMutableComposition *)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset
{
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error = nil;
    BOOL ok = NO;
    
    CMTime startTime = start;
    CMTime trackDuration = dura;
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:1.0f atTime:startTime];
    [_audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:offset error:&error];
    if (!ok) {
        NSLog(@"insert audio into track error = %@",error);
    }
}
- (NSString *)filePathWithName:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}

-(void)makeAudioFadeOutWithSourceURL:(NSURL*)sourceURL destinationURL:(NSURL*)destinationURL fadeOutBeginSecond:(NSInteger)beginTime fadeOutEndSecond:(NSInteger)endTime fadeOutBeginVolume:(CGFloat)beginVolume fadeOutEndVolume:(CGFloat)endVolume callBack:(void(^)(BOOL success))callBack
{
//    BOOL sourceExist = [[NSFileManager defaultManager] fileExistsAtPath:sourceURL.path];
//    NSAssert(sourceExist, @"source not exist");
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationURL.path]) {
        [[NSFileManager defaultManager] removeItemAtPath:destinationURL.path error:nil];
    }
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:sourceURL options:nil];
    AVAssetExportSession* exporter = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    exporter.outputURL = destinationURL;
    exporter.outputFileType = AVFileTypeAppleM4A;
    AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];
    AVMutableAudioMixInputParameters *exportAudioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:asset.tracks.lastObject];
    [exportAudioMixInputParameters setVolumeRampFromStartVolume:beginVolume toEndVolume:endVolume timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(beginTime, 1), CMTimeSubtract(CMTimeMakeWithSeconds(endTime, 1), CMTimeMakeWithSeconds(beginTime, 1)))];
    NSArray *audioMixParameters = @[exportAudioMixInputParameters];
    exportAudioMix.inputParameters = audioMixParameters;
    
    exporter.audioMix = exportAudioMix;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        AVAssetExportSessionStatus status = exporter.status;
        if (status != AVAssetExportSessionStatusCompleted) {
            callBack(NO);
        }
        else {
            callBack(YES);
        }
        NSError *error = exporter.error;
        NSLog(@"export done,error %@,status %ld",error,(long)status);
    }];
}

// 给视频替换音轨
- (void)makeAudioWithAudioUrl:(NSURL *)audio_url
{
//    self.needSaveToAlbum = YES;
    NSURL *videoUrl = self.fileURL;

//    MBProgressHUD *hud = [MBProgressHUD showHUDOnlyTextAddedTo:self.view labelText:@"音频合成中..." afterDelay:1000];//音频合成中
//    hud.userInteractionEnabled = YES;

    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audio_url options:nil];
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetTrack *sourceVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    

    CMTime audioDuration = videoAsset.duration;//音频以视频的长度为基准
//    if (CMTimeGetSeconds(audioAsset.duration) > CMTimeGetSeconds(videoAsset.duration)) {
//        audioDuration = videoAsset.duration;//获取较短的那个长度
//    }
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    // 视频
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:sourceVideoTrack
                                    atTime:kCMTimeZero
                                     error:nil];
    // 对AVMutableCompositionTrack的preferredTransform 赋值
    [compositionVideoTrack setPreferredTransform:sourceVideoTrack.preferredTransform];

    // 是否为本地相机竖相拍摄
    BOOL isVideoAssetPortrait = NO;

    // 这一步非常关键 CGAffineTransform 一定要取AVAssetTrack的preferredTransform ，不能取AVAsset的preferredTransform，因为AVAsset的preferredTransform都是初使值；
    CGAffineTransform videoTransform = compositionVideoTrack.preferredTransform;

    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        
        isVideoAssetPortrait = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        isVideoAssetPortrait = NO;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        isVideoAssetPortrait = NO;
    }
    
    AVMutableVideoCompositionLayerInstruction *instruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:sourceVideoTrack];
    CGSize naturalSize = sourceVideoTrack.naturalSize;
    if (isVideoAssetPortrait) {
//        CGAffineTransform t1 = CGAffineTransformMakeTranslation(compositionVideoTrack.naturalSize.height, 0.0);
//        CGAffineTransform t2 = CGAffineTransformRotate(t1, kDegreesToRadians(90));
        naturalSize = CGSizeMake(naturalSize.height, naturalSize.width);
    }
    [instruction setTransform:sourceVideoTrack.preferredTransform atTime:kCMTimeZero];

    /*
    CGFloat FirstAssetScaleToFitRatio = 320.0/compositionVideoTrack.naturalSize.width;
    if(isVideoAssetPortrait) {
        FirstAssetScaleToFitRatio = 320.0/compositionVideoTrack.naturalSize.height;
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [instruction setTransform:CGAffineTransformConcat(videoTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }
    else {
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [instruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(videoTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
    }
     */

    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = naturalSize;
    videoComposition.frameDuration = CMTimeMake(1, kTimeScale);
    
    /**** AVMutableComposition 的 naturalSize 不负值的话 AVAssetExportSession 会报11841的错误 ***/
    mixComposition.naturalSize = naturalSize;
    
    AVMutableVideoCompositionInstruction *videoTrackInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    videoTrackInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    videoTrackInstruction.layerInstructions = [NSArray arrayWithObject:instruction];
    
    [videoComposition setInstructions:[NSArray arrayWithObject:videoTrackInstruction]];
    
    // 音频
    AVMutableAudioMix *audioMix = nil;
    if (audioAsset) {
        // 混音
        if ([_audioMixParams count] > 0) {
            [_audioMixParams removeAllObjects];
        }
        if (_isMixAudio) {
            
            // 视频原有声音
            [self setUpAndAddAudioAtPath:videoAsset toComposition:mixComposition start:kCMTimeZero dura:videoAsset.duration offset:kCMTimeZero];
//            AVMutableCompositionTrack *oldAudioComTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                                      preferredTrackID:kCMPersistentTrackID_Invalid];
//            [oldAudioComTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
//                                      ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
//                                       atTime:kCMTimeZero error:nil];
           
                // 添加选择的声音
                [self setUpAndAddAudioAtPath:audioAsset toComposition:mixComposition start:kCMTimeZero dura:audioDuration offset:kCMTimeZero];
            
            
//            AVMutableCompositionTrack *selectedMusicComTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
//            [selectedMusicComTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioDuration)
//                                           ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
//                                            atTime:kCMTimeZero error:nil];
//
//            AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:selectedMusicComTrack];
//            [mixParameters setVolume:1.0f atTime:kCMTimeZero];

            audioMix = [AVMutableAudioMix audioMix];
            audioMix.inputParameters = [NSArray arrayWithArray:_audioMixParams];//@[mixParameters];
        }
        else {
            // 去掉视频原有音频，添加选中的音频
            AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioDuration)
                                                ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject]
                                                 atTime:kCMTimeZero error:nil];
        }
    }
    else {
        NSLog(@"没有原音000000");
        // 没有选取声音并且关掉原音，不进行添加音频处理就可以了
    }

    // 倒出视频
    NSString *mp4Quality = AVAssetExportPresetHighestQuality;
    
    // 生成mp4
    //    CFAbsoluteTime s = CFAbsoluteTimeGetCurrent();
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([compatiblePresets containsObject:mp4Quality]) {
        
        __weak SelectVideoCoverController *wSelf = self;
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                               presetName:mp4Quality];
        __weak AVAssetExportSession *wExportSession = exportSession;
//        NSString *fileString = [[self docDir] stringByAppendingPathComponent:@"modifyAudio.mp4"];
        NSString *fileString = [[self docDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[PublicObject generateNoLineUUID]]];
        

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileString]) {
            // Remove Existing File
            NSError *error;
            if ([fileManager removeItemAtPath:fileString error:&error] == NO) {
                NSLog(@"removeItemAtPath %@ error:%@", fileString, error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return;
            }
        }
        NSURL *tempUrl = [NSURL fileURLWithPath:fileString];
        exportSession.outputURL = tempUrl;
        if (audioMix) {
            exportSession.audioMix = audioMix;
        }
//        exportSession.timeRange = compositionVideoTrack.timeRange;
        //exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [GiFHUD dismiss];
            });
            
            switch ([wExportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed:%@",[wExportSession error]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"Successful!");
                    // 移除久的视频
//                    [[DBManager getInstance] deleteWithFilePath:[self.fileURL path]];
//                    self.fileURL = tempUrl;
                    self.originalFileURL = tempUrl;
                    //                    CFAbsoluteTime e = CFAbsoluteTimeGetCurrent();
                    //                    NSLog(@"MP4:%f",e-s);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wSelf delegateCallBack];
                    });
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
    else {
        //[self showAlert:@"AVAsset doesn't support mp4 quality"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}


#pragma mark 播放器控制

// 此方法连接到一个已经拖在视图上的button控件的触发事件上
- (void)playWithAudioUrl:(NSURL *)audioUrl
{
    [self stop:nil];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&error];
    if (error) {return;}
    //准备播放
    [_audioPlayer prepareToPlay];
    [self rePlay:nil];
}

-(void)rePlay:(id)sender {
    __weak SelectVideoCoverController *bself = self;

    if (self.avPlayer) {
        [self.avPlayer pause];
        [self.avPlayer seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            if (finished) {
                if (_audioPlayer) {
                    _audioPlayer.currentTime = 0.0f;
                    if (bself.fadeSoundURL) {
                        [_audioPlayer play];
                    }
                }
                [bself.avPlayer play];
                [bself updateVideoPlayMarkState];
                rightBarItem.enabled = YES;
                [MBProgressHUD hideHUDForView:bself.view animated:YES];
            }
        }];
    }
}


//暂停
-(void)pause:(id)sender {
    
    if (_audioPlayer) {
        [_audioPlayer pause];
    }
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
}

//停止
-(void)stop:(id)sender {
    
    if (_audioPlayer) {
        if (_audioPlayer.isPlaying) {
            [_audioPlayer stop];
        }
        _audioPlayer.currentTime = 0.0f;
    }
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
    [self updateVideoPlayMarkState];
}


#pragma mark
#pragma mark MPMediaPickerController delegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
    if ([mediaItemCollection items] > 0) {
        MPMediaItem *mediaItem = [[mediaItemCollection items] objectAtIndex:0];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MusicObject *music = [MusicObject musicObjectForMediaItem:mediaItem];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self buildSelectMusicView:music];
            });
        });
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ThumbnailPickerView data source

- (NSUInteger)numberOfImagesForThumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView
{
//    NSLog(@"count---%lu",(unsigned long)[imageItems count]);
    return [imageItems count];
    
}

- (UIImage *)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView imageAtIndex:(NSUInteger)index
{
    UIImage *image = [imageItems objectAtIndex:index];
    return image;
}

#pragma mark - ThumbnailPickerView delegate

- (void)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView didSelectImageWithIndex:(NSUInteger)index
{
    /*
    int time4Pic = (index+1)*kTimeScale;
    CMTime timeFrame = CMTimeMakeWithSeconds(second*time4Pic/kMaxFrame, 600);
    self.player.currentPlaybackTime = CMTimeGetSeconds(timeFrame);
    */
    /*
    double duration = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    float minValue = 0;
    float maxValue = [imageItems count]-1;
    float value = index;
    
    double time = duration * (value - minValue) / (maxValue - minValue);
    NSLog(@"time = %f",time);
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    
    self.selectedImage = [self getThumbnailImage:self.fileURL
                                        withTime:self.avPlayer.currentTime];
     */

//    CMTime newTime = CMTimeMakeWithSeconds(index, 1);
//    [self.avPlayer seekToTime:newTime];
//    [self.avPlayer setRate:0.5];
//    [self.avPlayer pause];
//    self.selectedImage = [self getThumbnailImage:self.fileURL withTime:self.avPlayer.currentTime];
//    UIImageView *bigThumbnailView = (UIImageView *)thumbnailPickerView;
//    bigThumbnailView.image = self.selectedImage;
}

- (void)thumbnailView:(UIView *)thumbnailView bigThumbnailViewOffset:(CGPoint)offset
{
    [self.avPlayer pause];
    [self updateVideoPlayMarkState];
    double duration = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    float minValue = 30;
    float maxValue = _thumbnailPickerView.width;//228;
    float value = offset.x;
    
    double time = duration * (value - minValue) / (maxValue - minValue);
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    [self pause:nil];
    self.selectedImage = [self getThumbnailImage:self.fileURL withTime:self.avPlayer.currentTime];
    UIImageView *bigThumbnailView = (UIImageView *)thumbnailView;
    bigThumbnailView.image = self.selectedImage;
    
    for (UIView *view in _coverView.subviews) {
        if (view) {
            UIImageView *frontImageView = (UIImageView *)view;
            [frontImageView removeFromSuperview];
        }
    }
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(offset.x, 0, 30, 30)];
    imageview.image = self.selectedImage;
    [_coverView addSubview:imageview];
    
}

#pragma mark- Filter Video

- (void)filterVideoForRealTime
{
    [self pause:nil];
    [self.movieFile removeAllTargets];
    [self.movieFile cancelProcessing];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:self.fileURL];
    [self.avPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    // 视频播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    self.movieFile = [[GPUImageMovie alloc] initWithPlayerItem:self.playerItem];
//    self.movieFile.runBenchmark = YES;
    self.movieFile.playAtActualSpeed = YES;
    GPUImageFilter *filter = [UPImageFilter filterWithType:self.currentFilterType];
    [self.movieFile addTarget:filter];
    [filter addTarget:self.videoView];
    [self.movieFile startProcessing];
    [self rePlay:nil];
    
}

- (void)filterVideoWithUPImageFilterType:(UPImageFilterType)type sourceFileURL:(NSURL *)sourceURL completionBlock:(void(^)(NSURL *filtedVideoURL))completionBlock
{
    self.movieFile = [[GPUImageMovie alloc] initWithURL:sourceURL];
    self.movieFile.runBenchmark = YES;
    self.movieFile.playAtActualSpeed = NO;
    GPUImageFilter *filter = [UPImageFilter filterWithType:type];
    [self.movieFile addTarget:filter];
    NSString *fileName = [[sourceURL path] lastPathComponent];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
    unlink([pathToMovie UTF8String]);// 删除在这个目录下已经存在的文件
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    double bytesPerSecond = 437500;
    if ([PublicObject isNeedLongTransitionTime]) {
        bytesPerSecond  = 87500;
    }
    bytesPerSecond *= 8;
    NSMutableDictionary * compressionProperties = [[NSMutableDictionary alloc] init];
    [compressionProperties setObject:[NSNumber numberWithDouble:bytesPerSecond] forKey:AVVideoAverageBitRateKey];
    [compressionProperties setObject:[NSNumber numberWithDouble: 30] forKey:AVVideoMaxKeyFrameIntervalKey];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:480], AVVideoWidthKey,
                                   [NSNumber numberWithInt:480],AVVideoHeightKey,
                                   compressionProperties, AVVideoCompressionPropertiesKey, nil];
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 480) fileType:AVFileTypeQuickTimeMovie outputSettings:videoSettings];;
    [filter addTarget:self.movieWriter];
    
    self.movieWriter.shouldPassthroughAudio = YES;
    self.movieFile.audioEncodingTarget = self.movieWriter;
    [self.movieFile enableSynchronizedEncodingUsingMovieWriter:self.movieWriter];
    
    [self.movieWriter startRecording];
    [self.movieFile startProcessing];
    
    __weak GPUImageMovieWriter *wMovieWriter = self.movieWriter;
    [self.movieWriter setCompletionBlock:^{
        [filter removeTarget:wMovieWriter];
        [wMovieWriter finishRecording];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(movieURL);
        });
    }];
}

#pragma mark- UPFilterToolBar Delegate Method

- (void)filterToolBar:(UPFilterToolBar *)toolBar didSelctedFilterWithIndex:(NSInteger)index
{
    NSDictionary *dict = [[UPImageFilter UPImageFilters] objectAtIndex:index];
    UPImageFilterType type = [[dict objectForKey:UPFILTER_TYPE] integerValue];
    if (type == self.currentFilterType) {
        return;
    }
    self.currentFilterType = index;
    [self filterVideoForRealTime];
    if (_soundButton.selected) {
        [self closeOriginalSound:NO];
    }
    else{
        [self closeOriginalSound:YES];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
