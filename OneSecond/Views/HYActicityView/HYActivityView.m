//
//  HYActivityView.m
//  Test
//
//  Created by crte on 13-11-6.
//  Copyright (c) 2013年 crte. All rights reserved.
//

#import "HYActivityView.h"

#define BUTTON_VIEW_SIDE 75.f
#define BUTTON_VIEW_FONT_SIZE 12.f

static CGFloat const kAnimationDuration = 0.25;


#pragma mark - ButtonView

@interface ButtonView () {
    
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) ButtonViewHandler handler;

@end

@implementation ButtonView

- (id)initWithText:(NSString *)text image:(UIImage *)image handler:(ButtonViewHandler)handler
{
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
        if (handler) {
            self.handler = handler;
        }
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.text = self.text;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:BUTTON_VIEW_FONT_SIZE];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = ColorForHex(0xd7d7d7);
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.backgroundColor = [UIColor clearColor];
    [self.imageButton setImage:self.image forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.imageButton];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint = nil;
    NSDictionary *views = @{@"textLabel": self.textLabel, @"imageButton": self.imageButton};
    NSArray *constraints = nil;
    
    //view的宽高为70
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_VIEW_SIDE];
    [self addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:BUTTON_VIEW_SIDE-5];
    [self addConstraint:constraint];
    
    //label紧贴view的左右
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-15)-[textLabel]-(-15)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //imageView距离view左右各10, imageView的宽为55
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7.5-[imageButton(55)]-7.5-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //竖直方向imageView和textLabel在一条直线上, 并且挨着, imageView的高为55
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageButton(55)]-5-[textLabel]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    [self addConstraints:constraints];
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.activityView) {
        __weak ButtonView *wself = self;
        [self.activityView hide:^{
            if (wself.handler) {
                wself.handler(wself);
            }
        }];
    }
    else {
        if (self.handler) {
            self.handler(self);
        }
    }
}

@end

#define ICON_VIEW_HEIGHT_SPACE 15

#pragma mark - HYActivityView

@interface HYActivityView ()
{
    UIWindow *_overlayWindow;
}

// 主窗口
@property (nonatomic,strong) UIWindow *mainWindow;

// 标题
@property (nonatomic, copy) NSString *title;

//将要显示在该视图上
@property (nonatomic, weak) UIView *referView;

//内容窗口
@property (nonatomic, strong) UIView *contentView;

//透明的关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

//按钮加载的view
@property (nonatomic, strong) UIView *iconView;

//button数组
@property (nonatomic, strong) NSMutableArray *buttonArray;

//行数
@property (nonatomic, assign) int lines;

//目前正在生效的numberOfButtonPerLine
@property (nonatomic, assign) int workingNumberOfButtonPerLine;

//按钮间的间隔大小
@property (nonatomic, assign) CGFloat buttonSpace;

//消失的时候移除
@property (nonatomic, strong) NSLayoutConstraint *contentViewAndViewConstraint;

//iconView高度的constraint
@property (nonatomic, strong) NSLayoutConstraint *iconViewHeightConstraint;

//buttonView的constraints
@property (nonatomic, strong) NSMutableArray *buttonConstraintsArray;


@end

@implementation HYActivityView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

//- (id)initWithTitle:(NSString *)title referView:(UIView *)referView
//{
//    self = [super init];
//    if (self) {
//        self.title = title;
//        if (referView) {
//            self.referView = referView;
//        }
//        [self setup];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    }
//    return self;
//}

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.hidden = YES;
        
        [self setup];
    }
    return self;
}

- (void)calculateButtonSpaceWithNumberOfButtonPerLine:(int)number
{
    self.buttonSpace = (_overlayWindow.bounds.size.width - 70 - BUTTON_VIEW_SIDE * number) / (number - 1);
    
    if (self.buttonSpace < 0) {
        [self calculateButtonSpaceWithNumberOfButtonPerLine:3];
    } else {
        self.workingNumberOfButtonPerLine = number;
    }
}

- (void)setup
{
    self.buttonArray = [NSMutableArray array];
    self.buttonConstraintsArray = [NSMutableArray array];
    self.lines = 0;
    self.numberOfButtonPerLine = 4;
    self.useGesturer = YES;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    self.contentView = [[UIButton alloc]init];
    self.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    [self addSubview:self.contentView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = ColorForHex(0x646464);
    [self.contentView addSubview:self.titleLabel];
    
//    UIImage *s = [BizCommon loginButtonBjImage:NO];
//    UIImage *sj = [BizCommon loginButtonBjImage:YES];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    [[self.cancelButton layer] setCornerRadius:5.f];
//    [self.cancelButton setBackgroundImage:s forState:UIControlStateNormal];
//    [self.cancelButton setBackgroundImage:sj forState:UIControlStateHighlighted];
//    self.cancelButton.backgroundColor = kCommonTextColor;//[UIColor colorWithRed:44.0/255.0 green:137.0/255.0 blue:160.0/255.0 alpha:1.0];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];//@"取 消"
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.cancelButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.cancelButton.layer.cornerRadius = 5.0;
    self.cancelButton.layer.masksToBounds = YES;
    [self.contentView addSubview:self.cancelButton];
    
    self.iconView = [[UIButton alloc]init];
    self.iconView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.iconView];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setNeedsUpdateConstraints];
    
    //添加下滑关闭手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipe];
    
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSArray *constraints = nil;
    NSLayoutConstraint *constraint = nil;
    NSDictionary *views = @{@"contentView": self.contentView, @"closeButton": self.closeButton, @"titleLabel": self.titleLabel, @"cancelButton": self.cancelButton, @"iconView": self.iconView, @"view": self, @"referView": _overlayWindow};
    
    //view跟referView的宽高相等
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_overlayWindow attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [_overlayWindow addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_overlayWindow attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [_overlayWindow addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_overlayWindow attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [_overlayWindow addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_overlayWindow attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [_overlayWindow addConstraint:constraint];
    
    //closeButton跟view的左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[closeButton]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //contentView跟view的左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //垂直方向closeButton挨着contentView
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[closeButton(==view@999)][contentView]" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    //titleLabel跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //cancelButton跟contentView左右距离35
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[cancelButton]-35-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //iconView跟contentView左右挨着
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[iconView]-35-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    //iconView的高度
    if (self.iconViewHeightConstraint) {
        [self.iconView removeConstraint:self.iconViewHeightConstraint];
        
    }
    self.iconViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.lines * BUTTON_VIEW_SIDE + (self.lines + 1) * ICON_VIEW_HEIGHT_SPACE];
    [self.iconView addConstraint:self.iconViewHeightConstraint];
    
    //垂直方向titleLabel挨着iconView挨着cancelButton
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel(==20)]-[iconView]-[cancelButton(==40)]-15-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
}

- (void)prepareForShow
{
    //计算行数
    NSInteger count = [self.buttonArray count];
    self.lines = (int)count / self.workingNumberOfButtonPerLine;
    if (count % self.workingNumberOfButtonPerLine != 0) {
        self.lines++;
    }
    for (int i = 0; i < [self.buttonArray count]; i++) {
        ButtonView *buttonView = [self.buttonArray objectAtIndex:i];
        [self.iconView addSubview:buttonView];
        
        int y = i / self.workingNumberOfButtonPerLine;
        int x = i % self.workingNumberOfButtonPerLine;
        
        //排列buttonView的位置
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeTop multiplier:1 constant:(y + 1) * ICON_VIEW_HEIGHT_SPACE + y * BUTTON_VIEW_SIDE];
        [self.iconView addConstraint:constraint];
        [self.buttonConstraintsArray addObject:constraint];

        constraint = [NSLayoutConstraint constraintWithItem:buttonView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeLeading multiplier:1 constant:x * self.buttonSpace + x * BUTTON_VIEW_SIDE];
        [self.iconView addConstraint:constraint];
        [self.buttonConstraintsArray addObject:constraint];
    }
    [self layoutIfNeeded];
}

- (void)show
{
    if (self.isShowing) {
        return;
    }
//    [self.referView addSubview:self];
    self.mainWindow = [UIApplication sharedApplication].keyWindow;
    [_overlayWindow addSubview:self];

    [self setNeedsUpdateConstraints];
//    self.alpha = 0;

    [self prepareForShow];
    
    self.contentViewAndViewConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:0];
    [self addConstraint:self.contentViewAndViewConstraint];
    
    
    _overlayWindow.alpha = 0;
    _overlayWindow.hidden = NO;
    [_overlayWindow makeKeyWindow];
    [UIView animateWithDuration:0.25f animations:^{
//        self.alpha = 1;
        _overlayWindow.alpha = 1;
        [self layoutIfNeeded];
        self.show = YES;
    }];
}

- (void)hide:(ActivityHiddenBlock)block
{
    if (!self.isShowing) {
        return;
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _overlayWindow.alpha = 0;
        [self removeConstraint:self.contentViewAndViewConstraint];
        self.contentViewAndViewConstraint = nil;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.show = NO;
            _overlayWindow.hidden = YES;
            [_overlayWindow removeFromSuperview];
            [self.mainWindow makeKeyWindow];

            if (block) {
                block ();
            }
        }
    }];
}

- (void)deviceRotate:(NSNotification *)notification
{
    [self.iconView removeConstraints:self.buttonConstraintsArray];
    [self.buttonConstraintsArray removeAllObjects];
    
    [self calculateButtonSpaceWithNumberOfButtonPerLine:self.numberOfButtonPerLine];
    [self prepareForShow];
    
    [self.iconView removeConstraint:self.iconViewHeightConstraint];
    self.iconViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.lines * BUTTON_VIEW_SIDE + (self.lines + 1) * ICON_VIEW_HEIGHT_SPACE];
    [self.iconView addConstraint:self.iconViewHeightConstraint];
}

- (void)setNumberOfButtonPerLine:(int)numberOfButtonPerLine
{
    _numberOfButtonPerLine = numberOfButtonPerLine;
    [self calculateButtonSpaceWithNumberOfButtonPerLine:numberOfButtonPerLine];
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.contentView.backgroundColor = bgColor;
}

- (void)addButtonView:(ButtonView *)buttonView
{
    [self.buttonArray addObject:buttonView];
    buttonView.activityView = self;
}

- (void)closeButtonClicked:(UIButton *)button
{
    [self hide:NULL];
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)swipe
{
    if (self.useGesturer) {
        [self hide:NULL];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
