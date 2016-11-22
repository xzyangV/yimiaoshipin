//
//  ThumbnailPickerView.m
//  ThumbnailPickerView
//
//  Created by Dominik Kapusta on 11-12-20.
//  Copyright (c) 2011 Dominik Kapusta.
//
//  Latest code can be found on GitHub: https://github.com/ayoy/ThumbnailPickerView
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

#import "ThumbnailPickerView.h"

#define kContentViewBolderColor [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
#define kBackGroundColor [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1]
#define kBolderColor [UIColor colorWithRed:0 green:192.0/255.0 blue:1.0 alpha:1]


static const CGSize kThumbnailSize        = {30, 30};
static const CGSize kBigThumbnailSize     = {30, 30};
static const NSUInteger kThumbnailSpacing = 0;

static const NSUInteger kTagOffset = 100;
static const NSUInteger kBigThumbnailTagOffset = 1000;

@interface ThumbnailPickerView()
- (UIImageView *)_createThumbnailImageViewWithSize:(CGSize)size;
- (void)_setup;
- (void)_updateSelectedIndexForTouch:(UITouch *)touch fineGrained:(BOOL)fineGrained;
- (void)_updateBigThumbnailPositionVerbose:(BOOL)verbose animated:(BOOL)animated;
- (void)_memoryWarning:(NSNotification *)notification;

- (void)_prepareImageViewForReuse:(UIImageView *)imageView;
- (UIImageView *)_dequeueReusableImageView;

@property (nonatomic, assign) NSUInteger visibleThumbnailsCount;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, retain) UIImageView *bigThumbnailImageView;
@property (nonatomic, strong, readonly) NSMutableSet *reusableThumbnailImageViews;

@end

@implementation ThumbnailPickerView

@synthesize dataSource = _dataSource, delegate = _delegate;
@synthesize visibleThumbnailsCount = _visibleThumbnailsCount;
@synthesize contentView = _contentView, bigThumbnailImageView = _bigThumbnailImageView;
@synthesize reusableThumbnailImageViews = _reusableThumbnailImageViews;

- (UIImageView *)_createThumbnailImageViewWithSize:(CGSize)size
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    if (CGSizeEqualToSize(size, kThumbnailSize)) {
        // 小图
        
    }
    else if (CGSizeEqualToSize(size, kBigThumbnailSize)) {
        if (_pageEnabled) {
            imageView.backgroundColor = [UIColor whiteColor];
        }
        else {
            imageView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        imageView.layer.borderWidth = 3;
        imageView.layer.borderColor = kBolderColor.CGColor;
    }
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    return imageView;
}

- (void)_setup
{
    _selectedIndex = NSNotFound;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_memoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageEnabled = YES;
        [self _setup];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_memoryWarning:(NSNotification *)notification
{
    [self.reusableThumbnailImageViews removeAllObjects];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        if (_selectedIndex != NSNotFound)
            [self _updateBigThumbnailPositionVerbose:NO animated:animated];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (NSMutableSet *)reusableThumbnailImageViews
{
    if (!_reusableThumbnailImageViews) {
        _reusableThumbnailImageViews = [NSMutableSet set];
    }
    return _reusableThumbnailImageViews;
}

- (UIImageView *)_dequeueReusableImageView
{
    UIImageView *imageView = [self.reusableThumbnailImageViews anyObject];
    
    if (imageView) {
        [self.reusableThumbnailImageViews removeObject:imageView];
//        NSLog(@"found reusable image view!");
    }

    return imageView;
}

- (void)_prepareImageViewForReuse:(UIImageView *)imageView
{
    if (imageView.tag != 0) {
        imageView.image = nil;
        imageView.tag = 0;
        [self.reusableThumbnailImageViews addObject:imageView];
        [imageView removeFromSuperview];
    }
}

- (void)setDataSource:(id<ThumbnailPickerViewDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self setNeedsLayout]; // layoutSubviews calls reloadData
    }
}

- (void)reloadData
{
    NSUInteger totalItemsCount = [self.dataSource numberOfImagesForThumbnailPickerView:self];
    if (totalItemsCount == 0) {
        return;
    }
    
    CGFloat contentsWidth = totalItemsCount * kThumbnailSize.width + (totalItemsCount-1) * kThumbnailSpacing; // cw = i*w + (i-1)*s
    if (contentsWidth > self.bounds.size.width) {
        self.visibleThumbnailsCount = floor((self.bounds.size.width+kThumbnailSpacing)/(kThumbnailSize.width+kThumbnailSpacing)); // i = (c+s)/(w+s)
        NSLog(@"items count: %lu, new items count: %lu, width: %.0f", (unsigned long)totalItemsCount, (unsigned long)self.visibleThumbnailsCount, self.bounds.size.width);
        contentsWidth = self.visibleThumbnailsCount * kThumbnailSize.width + (self.visibleThumbnailsCount-1) * kThumbnailSpacing;
    } else {
        self.visibleThumbnailsCount = totalItemsCount;
    }
    
    NSMutableArray *indices = [NSMutableArray arrayWithCapacity:self.visibleThumbnailsCount];
    if (self.visibleThumbnailsCount < totalItemsCount) {
        for (NSUInteger i = 0; i < self.visibleThumbnailsCount; i++) {
            [indices addObject:[NSNumber numberWithUnsignedInteger:(float)i/(self.visibleThumbnailsCount-1)*(totalItemsCount-1)]];
        }
    } else {
        for (NSUInteger i = 0; i < self.visibleThumbnailsCount; i++) {
            [indices addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
    }
    
    if (!self.contentView) {
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentsWidth, kThumbnailSize.height)];
        self.contentView.userInteractionEnabled = NO;
        self.contentView.backgroundColor = kBackGroundColor;
        self.contentView.image = [UIImage imageNamed:@"selectedVideoCoverProgressBj"];
//        self.contentView.layer.borderColor = kContentViewBolderColor.CGColor;
//        self.contentView.layer.borderWidth = 1;
        [self addSubview:self.contentView];
    }
    else {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![indices containsObject:@([(UIView *)obj tag]-kTagOffset)]) {
                [self _prepareImageViewForReuse:obj];
            }
        }];
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.size.width = contentsWidth;
        self.contentView.frame = contentViewFrame;
    }
    

    UIImageView *imageView = nil;
    CGRect imageViewFrame;
    NSUInteger index;
    NSInteger tag;
    
    for (NSUInteger i = 0; i < self.visibleThumbnailsCount; i++) {
        index = [[indices objectAtIndex:i] unsignedIntegerValue];
        tag = index + kTagOffset;
        
        imageView = (UIImageView *)[self.contentView viewWithTag:tag];
        if (!imageView) {
            imageView = [self _dequeueReusableImageView];
            if (!imageView) {
                imageView = [self _createThumbnailImageViewWithSize:kThumbnailSize];
            }
            imageView.tag = tag;
        }
        
        imageViewFrame = imageView.frame;
        imageViewFrame.origin.x = i * (kThumbnailSize.width + kThumbnailSpacing);
        imageView.frame = imageViewFrame;
        
        [self.contentView addSubview:imageView];

        dispatch_queue_t imageLoadingQueue = dispatch_queue_create("image loading queue", NULL);
        dispatch_async(imageLoadingQueue, ^{
            UIImage *image = [self.dataSource thumbnailPickerView:self imageAtIndex:index];
            dispatch_async(dispatch_get_main_queue(),^{
                imageView.image = image;
            });
        });
#if !OS_OBJECT_USE_OBJC
        dispatch_release(imageLoadingQueue);
#endif
    }
    
    // 添加默认显示的大缩略图
    if (!self.bigThumbnailImageView) {
        UIImageView *bigThumb = [self _createThumbnailImageViewWithSize:kBigThumbnailSize];
        self.bigThumbnailImageView = bigThumb;
        self.bigThumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.bigThumbnailImageView.layer.borderWidth = 1.0;
        [self addSubview:self.bigThumbnailImageView];
//        [self bringSubviewToFront:self.bigThumbnailImageView];
    }
    if (_selectedIndex != NSNotFound) {
        UIImage *defaultBigThumbnailImage = [self.dataSource thumbnailPickerView:self imageAtIndex:_selectedIndex];
        if (defaultBigThumbnailImage != nil) {
            self.bigThumbnailImageView.image = defaultBigThumbnailImage;
        }
    }
}

- (void)reloadThumbnailAtIndex:(NSUInteger)index
{
    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:index + kTagOffset];
    if (imageView) {
        dispatch_queue_t imageLoadingQueue = dispatch_queue_create("image loading queue", NULL);
        dispatch_async(imageLoadingQueue, ^{
            UIImage *image = [self.dataSource thumbnailPickerView:self imageAtIndex:index];
            dispatch_async(dispatch_get_main_queue(),^{
                imageView.image = image;
                if (index == _selectedIndex && _pageEnabled) {
                    self.bigThumbnailImageView.image = image;
                }
            });
        });
#if !OS_OBJECT_USE_OBJC
        dispatch_release(imageLoadingQueue);
#endif
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
//    NSLog(@"beginTrackingWithTouch");
    if (_pageEnabled) {
        [self _updateSelectedIndexForTouch:touch fineGrained:NO];
        [self _updateBigThumbnailPositionVerbose:YES animated:NO];
    }
    else {
        [self _updateBigThumbnailPositionTouch:touch];
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
//    NSLog(@"touch phase = %ld ; event: type = %ld,subType =%ld",(long)event.type,(long)event.subtype,(long)touch.phase);
    if (_pageEnabled) {
        [self _updateSelectedIndexForTouch:touch fineGrained:YES];
        [self _updateBigThumbnailPositionVerbose:YES animated:NO];
    }
    else {
        [self _updateBigThumbnailPositionTouch:touch];
    }

    return YES;
}

- (void)_updateBigThumbnailPositionTouch:(UITouch *)touch
{
    UIView *thumbImageView = self.bigThumbnailImageView;
    CGRect newThumbFrame = CGRectOffset(thumbImageView.frame, [touch locationInView:thumbImageView].x, 0);
    newThumbFrame.origin.x = MAX(newThumbFrame.origin.x, 0);
    newThumbFrame.origin.x = MIN(newThumbFrame.origin.x, self.width-kBigThumbnailSize.width);
//    NSLog(@"frame = %@",NSStringFromCGRect(newThumbFrame));
    thumbImageView.frame = newThumbFrame;
    self.bigThumbnailImageView.frame = newThumbFrame;
    
    if ([self.delegate respondsToSelector:@selector(thumbnailPickerView:didSelectImageWithIndex:)]) {
        [self.delegate thumbnailView:self.bigThumbnailImageView
              bigThumbnailViewOffset:CGPointMake(newThumbFrame.origin.x, newThumbFrame.origin.y)];
    }
}

- (void)_updateSelectedIndexForTouch:(UITouch *)touch fineGrained:(BOOL)fineGrained
{
    CGPoint pos = [touch locationInView:self.contentView];
    NSUInteger totalItemsCount = [self.dataSource numberOfImagesForThumbnailPickerView:self];
    NSInteger idx;
    if (fineGrained)
        idx = floor(pos.x / self.contentView.frame.size.width * (totalItemsCount-1));
    else
        idx = floor(floor(pos.x/(kThumbnailSize.width+kThumbnailSpacing)) / (self.visibleThumbnailsCount-1) * (totalItemsCount-1));

    idx = MAX(0, idx);
    idx = MIN(totalItemsCount-1, idx);

    _selectedIndex = idx;
}

- (void)_updateBigThumbnailPositionVerbose:(BOOL)verbose animated:(BOOL)animated
{
    if (_selectedIndex != NSNotFound && self.contentView.subviews.count > 0) {
        UIView *subview = nil;
        NSInteger tag = _selectedIndex+kTagOffset;
        NSInteger tagOffset = 0;
//        NSLog(@"trying tag %d, tagOffset %d", tag, tagOffset);
        while (!(subview = [self.contentView viewWithTag:tag])) {
            tag += (tagOffset = (tagOffset + (tagOffset>0 ? 1 : -1)) * -1); // 0, 1, -2, 3, -4, 5, -6 ...
//            NSLog(@"trying tag %d, tagOffset %d", tag, tagOffset);
        }
        
        if (!self.bigThumbnailImageView) {
            UIImageView *bigThumb = [self _createThumbnailImageViewWithSize:kBigThumbnailSize];
            self.bigThumbnailImageView = bigThumb;
            [self addSubview:self.bigThumbnailImageView];
        }

        void (^animations)(void) = ^ {
            self.bigThumbnailImageView.center = [self.contentView convertPoint:subview.center toView:self];
            dispatch_queue_t imageLoadingQueue = dispatch_queue_create("image loading queue", NULL);
            dispatch_async(imageLoadingQueue, ^{
                UIImage *image = [self.dataSource thumbnailPickerView:self imageAtIndex:_selectedIndex];
                dispatch_async(dispatch_get_main_queue(),^{
                    if (_pageEnabled) {
                        self.bigThumbnailImageView.image = image;
                    }
                });
            });
#if !OS_OBJECT_USE_OBJC
            dispatch_release(imageLoadingQueue);
#endif
        };

        if (animated)
            [UIView animateWithDuration:0.2 animations:animations];
        else
            animations();

        self.bigThumbnailImageView.tag = tag-kTagOffset+kBigThumbnailTagOffset;
        [self bringSubviewToFront:self.bigThumbnailImageView];
        
        if (verbose && [self.delegate respondsToSelector:@selector(thumbnailPickerView:didSelectImageWithIndex:)])
            [self.delegate thumbnailPickerView:self didSelectImageWithIndex:_selectedIndex];
    }
}

- (void)layoutSubviews
{
//    [self reloadData];
    self.contentView.center = [self convertPoint:self.center fromView:self.superview];
    if (self.bigThumbnailImageView) {
        // center big thumbnail view vertically
        CGRect frame = self.bigThumbnailImageView.frame;
        frame.origin.y = (self.bounds.size.height - frame.size.height) / 2;
        self.bigThumbnailImageView.frame = frame;

        UIView *subview = [self.contentView viewWithTag:self.bigThumbnailImageView.tag-kBigThumbnailTagOffset+kTagOffset];
        if (subview)
            self.bigThumbnailImageView.center = [self.contentView convertPoint:subview.center toView:self];
    }
}

@end
