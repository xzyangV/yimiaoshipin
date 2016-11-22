//
//  VideoDraftViewController.m
//  Up
//
//  Created by sup-mac03 on 16/4/8.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoDraftViewController.h"
#import "PublishVideoViewController.h"
#import "UpWebViewController.h"
#import "VideoDraftListCell.h"
#import "VideoRecordCreatCell.h"
#import "FinishVideoTableViewCell.h"
#import "RecordVideoDefine.h"
#import "HMSegmentedControl.h"
#import "FindPosterHeadView.h"

#import "VideoObject.h"
#import "VideoClipObject.h"
#import "VideoObjectList.h"
#import "FinishVideoObjectList.h"
#import "FinishVideoObject.h"
#import "PosterObject.h"
#import "PosterTopicList.h"
#import "EventCounting.h"
#import "DeviceObject.h"
@interface VideoDraftViewController ()<UITableViewDelegate,UITableViewDataSource,FindPosterHeadViewDelegate>
{
    UITableView *_tableView;
    FindPosterHeadView *_posterView;
    HMSegmentedControl *_drafaAndFinishedButton;
    NSMutableArray * imageArr;
    BOOL isNewDraft;
}

@end

@implementation VideoDraftViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        isNewDraft = YES;
       
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ColorForHex(0x1e1d1d);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorForHex(0x1e1d1d);
//    self.view.clipsToBounds = YES;
    imageArr = [[NSMutableArray alloc]init];
    // 去掉 navigationBar 阴影
    [PublicObject removeNavigationBarShadowImage:self.navigationController];
//    "new draft" = "新建/草稿";
//    "finish video" = "完成视频";
    if (_drafaAndFinishedButton == nil) {
        NSArray *titles = @[SVLocalizedString(@"new draft", nil), SVLocalizedString(@"finish video", nil)];
        _drafaAndFinishedButton = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _drafaAndFinishedButton.frame = CGRectMake(0,0, kScreenWidth - 110, 44);
        _drafaAndFinishedButton.backgroundColor = ColorForHex(0x1e1d1d);
        _drafaAndFinishedButton.selectionStyle = HMSegmentedControlSelectionStyleCustomWidthStripe;
        _drafaAndFinishedButton.selectionIndicatorWidth = 80;//控制文字下面线的长度
        _drafaAndFinishedButton.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _drafaAndFinishedButton.selectionIndicatorHeight = 3;
        _drafaAndFinishedButton.selectionIndicatorColor = ColorForHex(0xf2e216);
        _drafaAndFinishedButton.selectedTextColor = [UIColor whiteColor];
        _drafaAndFinishedButton.textColor = ColorForHex(0x777777);
        _drafaAndFinishedButton.font = [UIFont systemFontOfSize:15];
        __weak VideoDraftViewController *bself = self;
        [_drafaAndFinishedButton setIndexChangeBlock:^(NSInteger index)
        {
            [bself searchScopeButtonChangeForIndex:index];
        }];
        self.navigationItem.titleView = _drafaAndFinishedButton;
    }
    
    
    // 返回按钮
    UIBarButtonItem *backItem = [BizCommon barBackBtnWithTitle:UPLocStr(@"back")
                                                   clickTarget:self
                                                        action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backItem;

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = ColorForHex(0x1e1d1d);
    _tableView.separatorColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self setPosterImageForHeader];

}

- (void)setPosterImageForHeader
{
    if ([PosterTopicList sharedPosterList].count != 0) {
        [self buildHeaderView];
        _posterView.topicList = [PosterTopicList sharedPosterList];

    }
}

- (void)buildHeaderView{
    
    UIView * backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, (312+16)/2.f*kScreenHeight/667)];
    backGroundView.backgroundColor = [UIColor clearColor];
    _posterView = [[FindPosterHeadView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, backGroundView.height)];
    _posterView.delegate = self;
    _posterView.backgroundColor = [UIColor clearColor];
    [backGroundView addSubview:_posterView];
    _tableView.tableHeaderView = backGroundView;
}


- (void)searchScopeButtonChangeForIndex:(NSInteger)index{
    if (index == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        isNewDraft = YES;
        [self setPosterImageForHeader];
        [_tableView reloadData];

    }
    else {
        if ([FinishVideoObjectList sharedFinishVideoList].count == 0) {
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        isNewDraft = NO;
        _tableView.tableHeaderView = nil;
        [_tableView reloadData];
        
    }

}
- (void)goBack
{
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark- UITableView Delegate And Datasource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isNewDraft)
    {
        return [VideoObjectList sharedVideoList].count + 1;
    }
    else
    {
        return [FinishVideoObjectList sharedFinishVideoList].count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isNewDraft) {
        if (indexPath.row == 0) {
            static NSString *creatCellIdr = @"creatCellIdr";
            VideoRecordCreatCell *cell = [tableView dequeueReusableCellWithIdentifier:creatCellIdr];
            if (!cell) {
                cell = [[VideoRecordCreatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:creatCellIdr];
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = ColorForHex(0x000000);
            }
            return cell;
        }
        static NSString *cellIdr = @"cellIdr";
        VideoDraftListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdr];
        if (!cell) {
            cell = [[VideoDraftListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdr];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = ColorForHex(0x000000);
        }
        
        VideoObject *videoObject = [[VideoObjectList sharedVideoList] objectAtIndex:indexPath.row - 1];
        cell.videoObject = videoObject;
        return cell;

    }else{
        static NSString *fiishCellIdr = @"fiishCellIdr";
        FinishVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fiishCellIdr];
        if (!cell) {
            cell = [[FinishVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fiishCellIdr];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = ColorForHex(0x000000);
        }
        cell.finishObject = [[FinishVideoObjectList sharedFinishVideoList] objectAtIndex:indexPath.row];
        return cell;

    }
   }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isNewDraft) {
        if (indexPath.row == 0) {
            [EventCounting countEvent:k_creatNewVideo_count];//一秒视频新建量统计
            if(self.delegate && [self.delegate respondsToSelector:@selector(videoDraftViewController:didCreatNewVideoObject:)]){
                [self.delegate videoDraftViewController:self didCreatNewVideoObject:nil];
                [self goBack];
            }
            return;
        }
        VideoObject *videoObject = [[VideoObjectList sharedVideoList] objectAtIndex:indexPath.row - 1];
        if (videoObject) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(videoDraftViewController:didSelectedVideoObject:)]){
                [self.delegate videoDraftViewController:self didSelectedVideoObject:videoObject];
                [self goBack];
            }
        }
    }
    else{
        FinishVideoObject *finishObject = [[FinishVideoObjectList sharedFinishVideoList] objectAtIndex:indexPath.row];
        
        PublishVideoViewController *publish = [[PublishVideoViewController alloc]init];
        publish.finishVideo = finishObject;
        publish.finishVideoUrlStr = [finishObject finishVideoFilePath];
        publish.coverImagePath = [finishObject coverfinishVideoFilePath];
        publish.publishType = PublishOnlySave;
        [self.navigationController pushViewController:publish animated:YES];
    }
    
    
   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isNewDraft) {
        if (indexPath.row == 0) {
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isNewDraft) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [PublicObject showAlertViewWithTitle:SVLocalizedString(@"Sure you want to delete this video?", nil) message:SVLocalizedString(@"Delete this video will delete the source files at the same time", nil) cancelTitle:SVLocalizedString(@"delete", nil) otherTitle:SVLocalizedString(@"cancel", nil) completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex==0) {
                    VideoObject *videoObject = [[VideoObjectList sharedVideoList] objectAtIndex:indexPath.row - 1];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(videoDraftViewController:willDeleteVideoObject:)]) {
                        [self.delegate videoDraftViewController:self willDeleteVideoObject:videoObject];
                    }
                    [[VideoObjectList sharedVideoList] deleteVideoObject:videoObject];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
        }
    }
    else{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [PublicObject showAlertViewWithTitle:SVLocalizedString(@"Sure you want to delete this video?", nil) message:SVLocalizedString(@"Delete this video will delete the source files at the same time", nil) cancelTitle:SVLocalizedString(@"delete", nil) otherTitle:SVLocalizedString(@"cancel", nil) completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex==0) {
                    FinishVideoObject *videoObject = [[FinishVideoObjectList sharedFinishVideoList] objectAtIndex:indexPath.row];
                    [[FinishVideoObjectList sharedFinishVideoList] deleteFinishVideoObject:videoObject];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
        }

    }
    
}

#pragma mark - FindPosterHeadView Delegate

- (void)findPosterHeadView:(FindPosterHeadView *)findPosterView didClickedItem:(PosterObject *)posterObject
{
//    [posterObject showPostDetailWithRootVC:self];
    [EventCounting countEvent:k_click_banner_count];
    UpWebViewController *webView = [[UpWebViewController alloc]init];
    webView.url = [NSURL URLWithString:posterObject.url];
    if (posterObject.url.length > 0) {
        [self.navigationController presentViewController:[PublicObject ncForVC:webView] animated:YES completion:nil];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
