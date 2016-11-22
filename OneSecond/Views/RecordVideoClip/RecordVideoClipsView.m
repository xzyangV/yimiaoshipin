//
//  RecordVideoClipsView.m
//  Up
//
//  Created by sup-mac03 on 16/4/6.
//  Copyright © 2016年 amy. All rights reserved.
//

#import "RecordVideoClipsView.h"
#import "VideoClipCell.h"
#import "VideoClipEditCell.h"

static NSString * kVideoClipCellIdr = @"kVideoClipCellIdr";
static NSString * kVideoClipEditIdr = @"kVideoClipEditIdr";

@interface RecordVideoClipsView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation RecordVideoClipsView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self createClipsCollectionView];
    }
    return self;
}

- (void)createClipsCollectionView
{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumInteritemSpacing = 5;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 13);
     [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[VideoClipCell class] forCellWithReuseIdentifier:kVideoClipCellIdr];
    [_collectionView registerClass:[VideoClipEditCell class] forCellWithReuseIdentifier:kVideoClipEditIdr];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    _collectionView.userInteractionEnabled = NO;
}

- (void)setUnableUseEditBtn{
    _collectionView.userInteractionEnabled = NO;

}
- (void)setAbleUseEditBtn{
    _collectionView.userInteractionEnabled = YES;

}
- (void)setVideoClips:(NSArray *)videoClips
{
    if (_videoClips != videoClips) {
        _videoClips = videoClips;
    }
    
    self.selectedIndexPath = [NSIndexPath indexPathForItem:videoClips.count - 1 inSection:0];
    [_collectionView reloadData];
}

- (void)changeVideoClipStateToPlay
{
    VideoClipCell *cell = (VideoClipCell *)[_collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if (cell) {
        [cell showAndchangeVideoClipPlayStateToBegin];
    }
}
- (void)changeVideoClipStateToStop
{
    VideoClipCell *cell = (VideoClipCell *)[_collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if (cell) {
        [cell showAndchangeVideoClipPlayStateToStop];
    }
}

- (void)scroolToBottomAnimation:(BOOL)animation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = _collectionView.frame;
        if (_collectionView.contentSize.width > frame.size.width) {
            frame.origin.x += _collectionView.contentSize.width - frame.size.width;
            [_collectionView scrollRectToVisible:frame animated:animation];
        }
    });
}

#pragma mark- UICollectionViewDelegate DataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.videoClips.count < 2) {
        return self.videoClips.count;
    }
    return self.videoClips.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == self.selectedIndexPath) {
        return CGSizeMake(53, 53);
    }
    return CGSizeMake(44, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 13, 0, 13);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.videoClips.count) {
        VideoClipEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoClipEditIdr forIndexPath:indexPath];
        self.editCell = cell;
        return cell;
    }

    VideoClipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoClipCellIdr forIndexPath:indexPath];
    cell.videoClipObject = [self.videoClips objectAtIndex:indexPath.item];
    if (self.selectedIndexPath == indexPath) {
        [cell showAndchangeVideoClipPlayStateToBegin];
    }else{
        [cell hideVideoClipPlayControlView];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[VideoClipEditCell class]]) {
        // 编辑
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoClipsView:didSelectedEditCell:)]) {
            [self.delegate recordVideoClipsView:self didSelectedEditCell:(VideoClipEditCell *)cell];
        }
        return;
    }
    if (self.selectedIndexPath == indexPath) {
//        [(VideoClipCell *)cell showAndchangeVideoClipPlayStateToStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoClipsView:didSelectedVideoClipPlayCell:)]) {
            [self.delegate recordVideoClipsView:self didSelectedVideoClipPlayCell:(VideoClipCell *)cell];
        }
        return;
    }
    self.selectedIndexPath = indexPath;
    [collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoClipsView:didSelectedVideoClipCell:)]) {
        [self.delegate recordVideoClipsView:self didSelectedVideoClipCell:(VideoClipCell *)cell];
    }
}
@end
