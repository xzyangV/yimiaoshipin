//
//  YLZHoledView.m
//  HoledViewTest
//
//  Created by Colin on 15/4/7.
//  Copyright (c) 2015年 icephone. All rights reserved.
//

#import "YLZHoledView.h"


#pragma mark - holes objects

@interface YLZHole : NSObject
@property (assign) YLZHoleType holeType;
@end

@implementation YLZHole
@end

@interface YLZCircleHole : YLZHole
@property (assign) CGPoint holeCenterPoint;
@property (assign) CGFloat holeDiameter;
@end

@implementation YLZCircleHole
@end

@interface YLZRectHole : YLZHole
@property (assign) CGRect holeRect;
@end

@implementation YLZRectHole
@end

@interface YLZRoundedRectHole : YLZRectHole
@property (assign) CGFloat holeCornerRadius;
@end

@implementation YLZRoundedRectHole
@end

@interface YLZCustomRectHole : YLZRectHole
@property (strong) UIView *customView;
@end

@implementation YLZCustomRectHole
@end

@interface YLZHoledView ()
@property (strong, nonatomic) NSMutableArray *holes;  //Array of YLZHole
@property (strong, nonatomic) NSMutableArray *focusView; // Array of focus
@end

@implementation YLZHoledView

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _holes = [NSMutableArray new];
    _focusView = [NSMutableArray new];
    self.backgroundColor = [UIColor clearColor];
    _dimingColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetectedForGesture:)];
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - UIView Overrides

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self)
    {
        for (UIView *focus in self.focusView) {
            if (CGRectContainsPoint(focus.frame, point))
            {
                return focus;
            }
        }
    }

    return hitView;
}


- (void)drawRect:(CGRect)rect
{
    [self removeCustomViews];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) {
        return;
    }
    
    [self.dimingColor setFill];
    UIRectFill(rect);
    
    for (YLZHole* hole in self.holes) {
        
        [[UIColor clearColor] setFill];
        
        if (hole.holeType == YLZHoleTypeRoundedRect) {
            YLZRoundedRectHole *rectHole = (YLZRoundedRectHole *)hole;
            CGRect holeRectIntersection = CGRectIntersection( rectHole.holeRect, self.frame);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:holeRectIntersection
                                                                  cornerRadius:rectHole.holeCornerRadius];
            
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
            CGContextAddPath(UIGraphicsGetCurrentContext(), bezierPath.CGPath);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            CGContextFillPath(UIGraphicsGetCurrentContext());
            
        } else if (hole.holeType == YLZHoleTypeRect) {
            YLZRectHole *rectHole = (YLZRectHole *)hole;
            CGRect holeRectIntersection = CGRectIntersection( rectHole.holeRect, self.frame);
            UIRectFill( holeRectIntersection );
            
        } else if (hole.holeType == YLZHoleTypeCirle) {
            YLZCircleHole *circleHole = (YLZCircleHole *)hole;
            CGRect rectInView = CGRectMake(floorf(circleHole.holeCenterPoint.x - circleHole.holeDiameter*0.5f),
                                           floorf(circleHole.holeCenterPoint.y - circleHole.holeDiameter*0.5f),
                                           circleHole.holeDiameter,
                                           circleHole.holeDiameter);
            CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextFillEllipseInRect( context, rectInView );
        }
    }
    
    [self addCustomViews];
}

#pragma mark - Add methods

- (NSInteger)addHoleCircleCenteredOnPosition:(CGPoint)centerPoint andDiameter:(CGFloat)diameter
{
    YLZCircleHole *circleHole = [YLZCircleHole new];
    circleHole.holeCenterPoint = centerPoint;
    circleHole.holeDiameter = diameter;
    circleHole.holeType = YLZHoleTypeCirle;
    [self.holes addObject:circleHole];
    [self setNeedsDisplay];
    
    return [self.holes indexOfObject:circleHole];
}

- (NSInteger)addHoleRectOnRect:(CGRect)rect
{
    YLZRectHole *rectHole = [YLZRectHole new];
    rectHole.holeRect = rect;
    rectHole.holeType = YLZHoleTypeRect;
    [self.holes addObject:rectHole];
    [self setNeedsDisplay];
    
    return [self.holes indexOfObject:rectHole];
}

- (NSInteger)addHoleRoundedRectOnRect:(CGRect)rect withCornerRadius:(CGFloat)cornerRadius
{
    YLZRoundedRectHole *rectHole = [YLZRoundedRectHole new];
    rectHole.holeRect = rect;
    rectHole.holeCornerRadius = cornerRadius;
    rectHole.holeType = YLZHoleTypeRoundedRect;
    [self.holes addObject:rectHole];
    [self setNeedsDisplay];
    
    return [self.holes indexOfObject:rectHole];
}

- (NSInteger)addHCustomView:(UIView *)customView onRect:(CGRect)rect
{
    YLZCustomRectHole *customHole = [YLZCustomRectHole new];
    customHole.holeRect = rect;
    customHole.customView = customView;
    customHole.holeType = YLZHoleTypeCustomRect;
    [self.holes addObject:customHole];
    [self setNeedsDisplay];
    
    return [self.holes indexOfObject:customHole];
}

- (void)addFocusView:(UIView *)focus
{
    [self.focusView addObject:focus];
}

- (void)removeHoles
{
    [self.holes removeAllObjects];
    [self removeCustomViews];
    [self setNeedsDisplay];
}

#pragma mark - Overided setter

- (void)setDimingColor:(UIColor *)dimingColor
{
    _dimingColor = dimingColor;
    [self setNeedsDisplay];
}

#pragma mark - Tap Gesture

- (void)tapGestureDetectedForGesture:(UITapGestureRecognizer *)gesture
{
    if ([self.holeViewDelegate respondsToSelector:@selector(holedView:didSelectHoleAtIndex:)]) {
        CGPoint touchLocation = [gesture locationInView:self];
        [self.holeViewDelegate holedView:self didSelectHoleAtIndex:[self holeViewIndexForAtPoint:touchLocation]];
    }
}

- (NSUInteger)holeViewIndexForAtPoint:(CGPoint)touchLocation
{
    __block NSUInteger idxToReturn = NSNotFound;
    [self.holes enumerateObjectsUsingBlock:^(YLZHole *hole, NSUInteger idx, BOOL *stop) {
        if (hole.holeType == YLZHoleTypeRoundedRect ||
            hole.holeType == YLZHoleTypeRect ||
            hole.holeType == YLZHoleTypeCustomRect) {
            YLZRectHole *rectHole = (YLZRectHole *)hole;
            if (CGRectContainsPoint(rectHole.holeRect, touchLocation)) {
                idxToReturn = idx;
                *stop = YES;
            }
            
        } else if (hole.holeType == YLZHoleTypeCirle) {
            YLZCircleHole *circleHole = (YLZCircleHole *)hole;
            CGRect rectInView = CGRectMake(floorf(circleHole.holeCenterPoint.x - circleHole.holeDiameter*0.5f),
                                           floorf(circleHole.holeCenterPoint.x - circleHole.holeDiameter*0.5f),
                                           circleHole.holeDiameter,
                                           circleHole.holeDiameter);
            if (CGRectContainsPoint(rectInView, touchLocation)) {
                idxToReturn = idx;
                *stop = YES;
            }
        }
    }];
    
    return idxToReturn;
}

#pragma mark - Custom Views

- (void)removeCustomViews
{
    [self.holes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[YLZCustomRectHole class]]) {
            YLZCustomRectHole *hole = (YLZCustomRectHole *)obj;
            [hole.customView removeFromSuperview];
        }
    }];
}

- (void)addCustomViews
{
    [self.holes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[YLZCustomRectHole class]]) {
            YLZCustomRectHole *hole = (YLZCustomRectHole *)obj;
            [hole.customView setFrame:hole.holeRect];
            [self addSubview:hole.customView];
        }
    }];
}

@end
