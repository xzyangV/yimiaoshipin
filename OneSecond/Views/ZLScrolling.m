//
//  ZLScrolling.m
//  zlee.custom
//
//  Created by zlee on 16/3/13.
//  Copyright © 2016年 zlee. All rights reserved.
//

#import "ZLScrolling.h"
#import "UIImageView+WebCache.h"

static NSString * cellIDF = @"cell";
static NSInteger pageCount = 1000;

@interface ZLScrolling()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    /**下载图片*/
    NSMutableArray *_downImageArray;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;
/**所有的图片对象*/
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) CGRect frame;
/**占位图片*/
@property (nonatomic, strong) UIImage *placeholder;
@end

@implementation ZLScrolling

/**
 *  初始化方法(数组本地图片存NSString,网络图片存NSURL)
 *
 *  @param viewcontroller     哪个控制器初始化就填哪个(一般是self)
 *  @param frame              frame
 *  @param photos             本地图片存NSString,网络图片存NSURL
 *  @param placeholderImage   占位图片
 */
- (instancetype)initWithCurrentController:(UIViewController *)viewcontroller frame:(CGRect)frame photos:(NSArray *)photos placeholderImage:(UIImage *)placeholderImage
{
    if (self = [super init]) {
        [viewcontroller.view addSubview:self.view];
        [viewcontroller addChildViewController:self];
        self.photos = photos;
        self.frame = frame;
        self.view.frame = frame;
        self.placeholder = placeholderImage;
        // 判断图片来源
        if ([self.photos[0] isKindOfClass:[NSURL class]]) {
            [self downloadImage];
        }
        [self.view addSubview:self.collectionView];
        [self.view addSubview:self.pageControl];
        self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.pageControl.frame = CGRectMake(0, frame.size.height-20, frame.size.width, 20);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(_photos.count*pageCount)/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    return self;
}

#pragma mark -<UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width,self.frame.size.height);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count*pageCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIDF forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    // 判断图片来源
    if ([self.photos[0] isKindOfClass:[NSURL class]]) {
        imageView = _downImageArray[indexPath.row %self.photos.count];
    }else{
        imageView.image = [UIImage imageNamed:self.photos[indexPath.row %self.photos.count]];
    }
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:imageView];
    return cell;
}
#pragma mark -<UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(zlScrolling:clickAtIndex:)]) {
        [self.delegate zlScrolling:self clickAtIndex:indexPath.row %self.photos.count];
    }
}

#pragma mark -Method
// 展示下一页
-(void)nextPage
{
    NSIndexPath *currentIndexPath=[[_collectionView indexPathsForVisibleItems]lastObject];
    NSInteger nextItem=currentIndexPath.item+1;
    NSIndexPath *nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:currentIndexPath.section];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

// 添加定时器
- (void)addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer=timer;
}
// 删除定时器
-(void)removeTimer{
    [self.timer invalidate];
    self.timer=nil;
}
// 当用户开始拖拽的时候就调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
// 当用户停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
// 设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.photos.count;
    self.pageControl.currentPage=page;
}

// 释放timer
- (void)viewDidDisappear:(BOOL)animated
{
    [self removeTimer];
}
// 添加timer
- (void)viewDidAppear:(BOOL)animated
{
    if (!_timer) {
        [self addTimer];
    }
}
// (是网络图片)下载图片
- (void)downloadImage
{
    _downImageArray = [NSMutableArray array];
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    for (NSURL *imgUrl in self.photos) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imageView sd_setImageWithURL:imgUrl placeholderImage:self.placeholder];
        imageView.image = [self imageWithImageSimple:imageView.image scaledToSize:size];
        [_downImageArray addObject:imageView];
    }
    
}
// 压缩图片
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIDF];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        _pageControl.numberOfPages = _photos.count;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}
- (void)dealloc
{
    NSLog(@"ZL销毁");
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com