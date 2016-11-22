//
//  YLZHoledView.h
//  HoledViewTest
//
//  Created by Colin on 15/4/7.
//  Copyright (c) 2015年 icephone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YLZHoleType)
{
    YLZHoleTypeCirle,
    YLZHoleTypeRect,
    YLZHoleTypeRoundedRect,
    YLZHoleTypeCustomRect
};


@class YLZHoledView;
@protocol YLZHoledViewDelegate <NSObject>

- (void)holedView:(YLZHoledView *)holedView didSelectHoleAtIndex:(NSUInteger)index;

@end

@interface YLZHoledView : UIView

@property (strong, nonatomic) UIColor *dimingColor;
@property (weak, nonatomic) id <YLZHoledViewDelegate> holeViewDelegate;

- (NSInteger)addHoleCircleCenteredOnPosition:(CGPoint)centerPoint andDiameter:(CGFloat)diamter;
- (NSInteger)addHoleRectOnRect:(CGRect)rect;
- (NSInteger)addHoleRoundedRectOnRect:(CGRect)rect withCornerRadius:(CGFloat)cornerRadius;
- (NSInteger)addHCustomView:(UIView *)customView onRect:(CGRect)rect;

- (void)addFocusView:(UIView *)focus;

- (void)removeHoles;


@end
