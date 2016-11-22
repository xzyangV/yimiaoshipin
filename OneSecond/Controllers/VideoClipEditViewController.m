//
//  VideoClipEditViewController.m
//  Up
//
//  Created by sup-mac03 on 16/4/12.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "VideoClipEditViewController.h"

#import "XWDragCellCollectionView.h"
#import "VideoClipEditDragCell.h"

#import "RecordVideoDefine.h"
#import "VideoObject.h"
#import "VideoClipObject.h"
#import "VideoClipObjectList.h"
#import "VideoObjectList.h"
#import "VideoClipHeaderView.h"
#import "UPGuide.h"
static NSString *kvideoClipEditCellIdr = @"videoClipEditCellIdr";

@interface VideoClipEditViewController ()<XWDragCellCollectionViewDataSource, XWDragCellCollectionViewDelegate>
{
    XWDragCellCollectionView *_collectionView;
}

@end

@implementation VideoClipEditViewController

static NSString * const kHeaderReuseIdentifier = @"editCollectionVCHeaderIdent";

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [UPGuide showGuideWithType:UPGuideTypeMoveSecondVideo completed:NULL];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackGroundColor;
//    self.view.clipsToBounds = YES;
    // 去掉 navigationBar 阴影
    [PublicObject removeNavigationBarShadowImage:self.navigationController];
    
    
//    self.navigationItem.title = UPLocStr(@"AllDraft");
    // 返回按钮
    UIBarButtonItem *backItem = [BizCommon barBackBtnWithTitle:UPLocStr(@"back")
                                                   clickTarget:self
                                                        action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backItem;

    self.title = SVLocalizedString(@"edit", nil);
    
    CGFloat itemSize = [VideoClipEditDragCell defaultSize];
    CGFloat space = (self.view.width - 4 * itemSize) / 5.f;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    layout.sectionInset = UIEdgeInsetsMake(10, space * 1.5, 20, space * 1.5);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 1.f;
    _collectionView = [[XWDragCellCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.shakeLevel = 3.0f;
    _collectionView.minimumPressDuration = 0.5;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[VideoClipEditDragCell class] forCellWithReuseIdentifier:kvideoClipEditCellIdr];
     [_collectionView registerClass:[VideoClipHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier];
    [self.view addSubview:_collectionView];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)goBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoClipEditViewControllerDidCancelEdit)]) {
        [self.delegate videoClipEditViewControllerDidCancelEdit];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteVideClipObject:(VideoClipObject *)videoClipObject
{
    [PublicObject showAlertViewWithTitle:SVLocalizedString(@"Sure you want to delete this video?", nil) message:SVLocalizedString(@"Delete this video will delete the source files at the same time", nil) cancelTitle:SVLocalizedString(@"delete", nil) otherTitle:SVLocalizedString(@"cancel", nil) completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (buttonIndex==0) {
            [self.videoObject deleteVideoClipObject:videoClipObject];
            // 删除时将一个视频的某个视频片段删除，删除了源文件，同样要更新数据列表。
            [[VideoObjectList sharedVideoList] saveVideoObject:self.videoObject];
            [_collectionView reloadData];
        }
    }];
}

#pragma mark - <XWDragCellCollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoObject.videoClips.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoClipEditDragCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:kvideoClipEditCellIdr forIndexPath:indexPath];
    cell.videoClipObject = [self.videoObject.videoClips objectAtIndex:indexPath.item];
    cell.deleteBlock = ^(VideoClipObject *videoClipObject){
        [self deleteVideClipObject:videoClipObject];
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]){
        VideoClipHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderReuseIdentifier forIndexPath:indexPath];
        return headerView;
    }
    
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 30);
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return [self.videoObject.videoClips.objectArray copy];
}

#pragma mark - <XWDragCellCollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    
    VideoClipObjectList *videoClipList = [[VideoClipObjectList alloc] init];
    for (VideoClipObject *tempObj in newDataArray) {
        [videoClipList addObject:tempObj];
    }
    self.videoObject.videoClips = videoClipList;
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)dragCellCollectionViewCellEndMoving:(XWDragCellCollectionView *)collectionView{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
