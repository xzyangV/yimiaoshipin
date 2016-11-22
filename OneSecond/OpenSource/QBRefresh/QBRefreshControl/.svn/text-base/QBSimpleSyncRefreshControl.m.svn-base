//
//  QBSimpleSyncRefreshControl.m
//  QBRefreshControlDemo
//
//  Created by Katsuma Tanaka on 2012/11/23.
//  Copyright (c) 2012年 Katsuma Tanaka. All rights reserved.
//

#import "QBSimpleSyncRefreshControl.h"

#import "QBAnimationSequence.h"
#import "QBAnimationGroup.h"
#import "QBAnimationItem.h"

#define kDefaultHeight 65.0
#define kTextHeight 14.0


@interface QBSimpleSyncRefreshControl ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation QBSimpleSyncRefreshControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kDefaultHeight);
        self.threshold = -self.height;
        self.angle = 0;
        self.clipsToBounds = YES;
        
        NSMutableArray *animateImages = [NSMutableArray array];
        for (int i = 1; i <= 3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"upRefreshControl_%d",i]];
            [animateImages addObject:image];
        }
        
        UIImage *defaultImage = [UIImage imageNamed:@"upRefreshControl_0"];
        CGSize tSize = CGSizeMake(kDefaultHeight, kDefaultHeight);
        
        self.imgView = [[UIImageView alloc] initWithImage:defaultImage];
        self.imgView.frame = CGRectMake((self.width - tSize.width) / 2.0, 2.0, tSize.width, tSize.height);
        self.imgView.animationImages = animateImages;
        self.imgView.animationDuration = 0.2;
        self.imgView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.imgView];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imgView.bottom - kTextHeight - 6, self.width, kTextHeight)];
        self.dateLabel.backgroundColor = [UIColor clearColor];//ColorForRGB(219, 229, 236, 1);
        self.dateLabel.font = [UIFont boldSystemFontOfSize:10];
        self.dateLabel.textColor = ColorForRGB(109, 114, 130, 1);
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dateLabel];
    }
    
    return self;
}

- (void)setState:(QBRefreshControlState)state
{
    [super setState:state];
    if (self.isDiscovery) {
        return;
    }
    switch(state) {
        case QBRefreshControlStateHidden:
            [self.imgView stopAnimating];
            break;
        case QBRefreshControlStatePullingDown:
            if (self.showUpdateTime && self.dateLabel.hidden) {
                self.dateLabel.hidden = NO;
            }
            break;
        case QBRefreshControlStateStopping:
            [self.imgView startAnimating];
            if (!self.dateLabel.hidden) {
                self.dateLabel.hidden = YES;
            }
            break;
        default:break;
    }
}

- (void)setLastUpdateTime:(NSString *)lastUpdateTime
{
    if (self.isDiscovery) {
        return;
    }
    if (_lastUpdateTime != lastUpdateTime) {
        _lastUpdateTime = lastUpdateTime;
        if (![self.dateLabel.text isEqualToString:_lastUpdateTime]) {
            self.dateLabel.text = [NSString stringWithFormat:UPLocalizedString(@"Last Update:%@", nil),
                                   (_lastUpdateTime ? _lastUpdateTime : UPLocalizedString(@"Never", nil))];
        }
    }
}

- (void)setShowUpdateTime:(BOOL)showUpdateTime
{
    if (_showUpdateTime != showUpdateTime) {
        _showUpdateTime = showUpdateTime;
    }
    self.dateLabel.hidden = !self.showUpdateTime;
}

- (void)setIsDiscovery:(BOOL)isDiscovery
{
    _isDiscovery = isDiscovery;
    if (_isDiscovery) {
        self.height = 30.0;
        self.threshold = -self.height;
        if (self.dateLabel) {
            self.dateLabel.hidden = YES;
        }
        if (self.imgView) {
            self.imgView.hidden = YES;
        }
    }
    else {
        self.height = kDefaultHeight;
        self.threshold = -self.height;
        if (self.dateLabel) {
            self.dateLabel.hidden = NO;
        }
        if (self.imgView) {
            self.imgView.hidden = NO;
        }
    }
}

@end
