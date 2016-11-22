//
//  SelectSongViewController.m
//  Up
//
//  Created by uper on 16/4/15.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "SelectSongViewController.h"
#import "PullRefreshTableView.h"

#import "SelectSongTableViewCell.h"
#import "RemoveSongTableViewCell.h"
#import "MusicObject.h"
#import "MusicObjectList.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface SelectSongViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>
{
    NSString *filePath;
    NSInteger _selectedIndex;
    AVPlayer *_play;
}
@property (nonatomic, strong) PullRefreshTableView *tableView;

@end

@implementation SelectSongViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
//        self.navigationItem.rightBarButtonItem = [BizCommon barButtonWithTitle:SVLocalizedString(@"cancel", nil) clickTarget:self action:@selector(cancelBtnClick)];
        
         self.navigationItem.rightBarButtonItem = [BizCommon barBtnWithImage:[UIImage imageNamed:@"Shape"] title:nil titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:15] target:self action:@selector(cancelBtnClick)];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ColorForHex(0x1e1d1d);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_play pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorForHex(0x1e1d1d);

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _selectedIndex  = [user integerForKey:@"selectIndex"];
    
    self.title = SVLocalizedString(@"soundtrack", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self creatTableView];
    [self creatLocalSongView];

}
#pragma mark Build View


- (void)creatTableView
{
    _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kScreenHeight-kNavBarAndStatusBarHeight)];
    _tableView.backgroundColor = ColorForHex(0x1e1d1d);
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullRefreshDelegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showPullRefresh = YES;
    _tableView.showLoadMore = YES;
    [self.view addSubview:_tableView];
    [_tableView beginRefreshing];
    
}

- (void)creatLocalSongView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    backView.backgroundColor = ColorForHex(0x1e1d1d);
    
    UIImage *songImage = [UIImage imageNamed:@"backSongIcon"];
    UIImageView *songImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, (50-songImage.size.height)/2, songImage.size.width, songImage.size.height)];
    songImageView.image = songImage;
    [backView addSubview:songImageView];
    
    UILabel *addLocalSong = [[UILabel alloc]initWithFrame:CGRectMake(songImageView.right + 11,0 , 130, 50)];
    addLocalSong.text = SVLocalizedString(@"Add local music", nil);
    addLocalSong.textAlignment = NSTextAlignmentLeft;
    addLocalSong.textColor = ColorForHex(0xffffff);
    addLocalSong.font = [UIFont systemFontOfSize:15];
    [backView addSubview:addLocalSong];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:@"jiantou.png"];
    arrow.frame = CGRectMake(kScreenWidth-25-image.size.width, (50-image.size.height)/2, image.size.width, image.size.height);
    arrow.image = image;
    [backView addSubview:arrow];
    
    _tableView.tableHeaderView = backView;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(25, 49, kScreenWidth-50, SINGLE_LINE_WIDTH)];
    line.backgroundColor = ColorForHex(0x303030);
    [backView addSubview:line];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addLocalSong)];
    [backView addGestureRecognizer:tap];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [MusicObjectList sharedList].count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak SelectSongViewController *bself = self;
    NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults];
    static NSString * iden = @"iden";
    RemoveSongTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];

    if (indexPath.row==0) {
    if (cell1==nil) {
        cell1 = [[RemoveSongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
        if (_selectedIndex==0) {
            cell1.noSongLabel.textColor = ColorForHex(0xf2e216);
        }
        
        cell1.noMusicBlock = ^(MusicObject *musicObject){//选择无配乐
            _selectedIndex = indexPath.row;
            [userdef setInteger:_selectedIndex forKey:@"selectIndex"];
            [userdef synchronize];
            [_play pause];
            if (bself.selectBlankMusicBlock) {
                bself.selectBlankMusicBlock();
            }
            [bself dismissViewControllerAnimated:YES completion:nil];
        };
        
    return cell1;
    }
    else{
        NSString *cellIdr = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
        SelectSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdr];
        if (cell == nil) {
            cell = [[SelectSongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdr];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.musicObject = [[MusicObjectList sharedList] objectAtIndex:indexPath.row - 1];
        
        if (indexPath.row == _selectedIndex) {
            cell.songNameLabel.textColor = ColorForHex(0xf2e216);
        }
        
        cell.useMusicBlock = ^(MusicObject *musicObject){
            [_play pause];
            _selectedIndex = indexPath.row;
            [userdef setInteger:_selectedIndex forKey:@"selectIndex"];
            [userdef synchronize];
           if (bself.selectMusicBlock) {
            bself.selectMusicBlock(musicObject);
        }
    
        [bself dismissViewControllerAnimated:YES completion:nil];
        
        };
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicObject *musicObject = [[MusicObjectList sharedList] objectAtIndex:indexPath.row-1];
    
    if ([musicObject musicIsExist]) {
        [self playAudioWithAudioUrl:[NSURL fileURLWithPath:[musicObject musicFilePath]]];
    }else{
        if (![PublicObject networkIsReachableForShowAlert:YES]) {
           
            return;
        }
        [self playAudioWithAudioUrl:[NSURL URLWithString:musicObject.url]];
    }
    
    
    for (int i = 0; i<[MusicObjectList sharedList].count + 1; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:ip];
        
        if ([cell isKindOfClass:[RemoveSongTableViewCell class]]) {
            RemoveSongTableViewCell *cell1 = (RemoveSongTableViewCell *)cell;
            cell1.noSongLabel.textColor = ColorForHex(0xffffff);
        }
        
        if ([cell isKindOfClass:[SelectSongTableViewCell class]]) {
            SelectSongTableViewCell *cell2 = (SelectSongTableViewCell *)cell;
            cell2.songNameLabel.textColor = ColorForHex(0xffffff);
        }
        
        if (_selectedIndex == i) {
            if ([cell isKindOfClass:[RemoveSongTableViewCell class]]) {
                RemoveSongTableViewCell *cell1 = (RemoveSongTableViewCell *)cell;
                cell1.noSongLabel.textColor = ColorForHex(0xf2e216);
            }
            if ([cell isKindOfClass:[SelectSongTableViewCell class]]) {
                SelectSongTableViewCell *cell2 = (SelectSongTableViewCell *)cell;
                cell2.songNameLabel.textColor = ColorForHex(0xf2e216);
            }
        }
        
    }
    
}
#pragma mark
#pragma mark PullRefreshTableViewDelegate

- (void)tableViewDidBeginRefreshing:(PullRefreshTableView *)tableView
{
    __weak SelectSongViewController *wSelf = self;
    [[MusicObjectList sharedList] refreshDataWithObject:nil clearObjects:NO completedBlock:^(NSInteger aCount, NSString *aError) {
        if (!wSelf) {
            return ;
        }
        [wSelf.tableView endRefreshing];
        [wSelf.tableView reloadData];
    }];
}

- (void)tableViewDidBeginLoadMore:(UITableView *)tableView
{
    __weak SelectSongViewController *wSelf = self;
    [[MusicObjectList sharedList] loadMoreDataCompletedBlock:^(NSInteger aCount, NSString *aError) {
        if (!wSelf) {return ;}
        
        [wSelf.tableView reloadData];
        [wSelf.tableView endLoadMore];
        
        if (aCount == 0 && aError == nil) {
            wSelf.tableView.isNoMoreData = YES;
        }
    }];
}

- (void)addLocalSong{
    
    if (self.selectLocelMusicBlock)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.selectLocelMusicBlock();
    }

}
- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playAudioWithAudioUrl:(NSURL *)url{
    _play = [[AVPlayer alloc] initWithURL:url]; //在线
    [_play play];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
