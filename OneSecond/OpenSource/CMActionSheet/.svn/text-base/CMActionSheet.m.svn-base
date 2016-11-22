//
//  CMActionSheet.m
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMActionSheet.h"
#import "CMRotatableModalViewController.h"

#define kSpaseHeight 10

@interface CMActionSheetStack : NSObject
@property (nonatomic) NSMutableArray *actionSheetArray;
@end

@implementation CMActionSheetStack

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CMActionSheetStack alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actionSheetArray = [NSMutableArray array];
    }
    return self;
}
- (void)push:(CMActionSheet *)actionSheet
{
    [self.actionSheetArray addObject:actionSheet];
}

- (void)pop:(CMActionSheet *)actionSheet
{
    [self.actionSheetArray removeObject:actionSheet];
}

@end




@interface CMActionSheet () <UIGestureRecognizerDelegate> {
    

}

@property (strong) UIImageView *backgroundActionView;
@property (strong) UIWindow *overlayWindow;
@property (strong) UIWindow *mainWindow;
@property (strong) NSMutableArray *items;
@property (strong) NSMutableArray *itemTypes;
@property (strong) NSMutableArray *callbacks;
@property (nonatomic, copy) CMActionSheetCompletionBlock completionBlock;
@end

@implementation CMActionSheet

@synthesize title, backgroundActionView, overlayWindow, mainWindow, items, callbacks;

- (id)init
{
    if (self = [self initWithTarget:nil]) {
    }
    return self;
}

- (id)initWithTarget:(id)delegate {
    self = [super init];
    if (self) {
        self.backgroundActionView = [[UIImageView alloc] init];//WithImage:backgroundImage] autorelease];
        self.backgroundActionView.backgroundColor = [UIColor clearColor];
        self.backgroundActionView.alpha = 1;
        self.backgroundActionView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundActionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.overlayWindow.windowLevel = UIWindowLevelStatusBar;
        self.overlayWindow.userInteractionEnabled = YES;
        self.overlayWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        self.overlayWindow.hidden = YES;
        
        // 添加手势响应
        UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSingleTap:)];
        [singletap setNumberOfTapsRequired:1];
        singletap.delegate = self;
        [self.overlayWindow addGestureRecognizer:singletap];
    }
    return self;
}



+ (void)showActionSheetWithTitles:(NSArray *)titles completionBlock:(CMActionSheetCompletionBlock)block
{
    [self showActionSheetWithTitles:titles images:nil completionBlock:block];
}

+ (void)showActionSheetWithTitles:(NSArray *)titles images:(NSArray *)images completionBlock:(CMActionSheetCompletionBlock)block
{
    CMActionSheet *actionSheet = [[CMActionSheet alloc] init];
    for (int i = 0; i < titles.count; i++) {
        UIImage *btnImage = nil;
        if (i < images.count) {
            btnImage = images[i];
        }
        [actionSheet addButtonWithTitle:titles[i] image:btnImage block:NULL];
    }
    actionSheet.completionBlock = block;
    [actionSheet present];
}

- (void)setStyleWithButton:(UIButton *)button type:(CMActionSheetButtonType)type
{
    UIImage *image = nil;
    UIImage *selected_image = nil;
    UIColor *titleColor = nil;
    UIColor *titleColorHi = nil;
    if (type == CMActionSheetButtonTypeNormal) {
        image = [UIImage imageNamed:@"action_white_single"];
        selected_image = [UIImage imageNamed:@"action_white_single_dj"];
        titleColor = ColorForHex(0x000000);//kCommonTextColor;//ColorForHex(0x006189);
        titleColorHi = ColorForHex(0x006189);
    }
    else {
        image = [UIImage imageNamed:@"cancelBar"];//[BizCommon loginButtonBjImage:NO];//[UIImage imageNamed:@"action_cancel"];
        selected_image = [UIImage imageNamed:@"cancelBar"];
        titleColor = ColorForHex(0x777777);
        titleColorHi = ColorForHex(0x77777);
    }
    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:selected_image forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    [button setTitleColor:titleColorHi forState:UIControlStateHighlighted];
}

- (void)addButtonWithTitle:(NSString *)buttonTitle image:(UIImage *)buttonImage type:(CMActionSheetButtonType)type block:(CallbackBlock)block
{
//	NSAssert(block, @"Block must not be nil!");
    
    NSUInteger index = 0;
    if (!self.items) {
        self.items = [NSMutableArray array];
    }
    if (self.itemTypes == nil) {
        self.itemTypes = [NSMutableArray array];
    }
    if (!self.callbacks) {
        self.callbacks = [NSMutableArray array];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setStyleWithButton:button type:type];
    button.backgroundColor = [UIColor whiteColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.titleLabel.minimumScaleFactor = 6;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 6;
    button.accessibilityLabel = buttonTitle;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.accessibilityLabel = buttonTitle;
    if (buttonImage) {
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    else {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.items addObject:button];
    [self.itemTypes addObject:@(type)];
    if (block) {
        [self.callbacks addObject:[block copy]];
    }
    index++;
}

- (void)addButtonWithTitle:(NSString *)buttonTitle type:(CMActionSheetButtonType)type block:(CallbackBlock)block
{
    [self addButtonWithTitle:buttonTitle image:nil type:type block:block];
}

- (void)addButtonWithTitle:(NSString *)btnTitle block:(CallbackBlock)block
{
    [self addButtonWithTitle:btnTitle type:CMActionSheetButtonTypeNormal block:block];
}

- (void)addButtonWithTitle:(NSString *)btnTitle image:(UIImage *)image block:(CallbackBlock)block
{
    [self addButtonWithTitle:btnTitle image:image type:CMActionSheetButtonTypeNormal block:block];
}

- (void)present {
    if (self.items && self.items.count > 0) {
        self.mainWindow = [UIApplication sharedApplication].keyWindow;
        CMRotatableModalViewController *viewController = [CMRotatableModalViewController new];
        viewController.rootViewController = mainWindow.rootViewController;
        
        // Build action sheet view
        UIView* actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height, kScreenWidth-40*2, 0)];
        actionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [viewController.view addSubview:actionSheet];
        
        // Add background
        self.backgroundActionView.frame = CGRectMake(0, 0, kScreenWidth, actionSheet.frame.size.height);
        [actionSheet addSubview:self.backgroundActionView];
        
        CGFloat offset = kSpaseHeight + 5;
        
        // Add Title
        if (self.title) {
            UIFont *titleFont = [UIFont systemFontOfSize:15.0];
//            CGSize size = [title sizeWithFont:titleFont
//                            constrainedToSize:CGSizeMake(actionSheet.frame.size.width-10*2, 1000)
//                                lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat sizeHeight = [PublicObject heightForString:title font:titleFont andWidth:actionSheet.frame.size.width-10*2];
            CGFloat width = actionSheet.frame.size.width-10*2;
            
            //            CGFloat width = 300;
            //            UIImage *backImage = [UIImage imageNamed:@"action_white_top.png"];
            //            UILabel *labelView = [[[UILabel alloc] initWithFrame:CGRectMake(10, offset, width, backImage.size.height)] autorelease];
            //            labelView.backgroundColor = [UIColor colorWithPatternImage:backImage];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, offset, width, sizeHeight+10)];
            labelView.backgroundColor = [UIColor clearColor];
            labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            labelView.font = titleFont;
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = ColorForHex(0x6d7282);
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.text = title;
            [actionSheet addSubview:labelView];
            
            offset += labelView.height + kSpaseHeight;
        }
        
        // Add action sheet items
        NSUInteger tag = 100;
        
        for (UIView *item in self.items) {
            if ([item isKindOfClass:[UIImageView class]]) {
                item.frame = CGRectMake(0, offset, actionSheet.frame.size.width, 2);
                [actionSheet addSubview:item];
                
                offset += item.frame.size.height + kSpaseHeight;
            } else {
                UIButton *btn = (UIButton *)item;
                if ([self.items lastObject]==item) {
                    //强制将最后一个按钮样式变成取消
                    if ([self.itemTypes.lastObject intValue] != CMActionSheetButtonTypeCancel) {
                        [self setStyleWithButton:btn type:CMActionSheetButtonTypeCancel];
                    }
                    
                    offset += 8;
                }
                UIImage *image = [btn backgroundImageForState:UIControlStateNormal];
                
                
                item.frame = CGRectMake(40, offset+30*kScreenHeight/667, actionSheet.frame.size.width, image.size.height*kScreenHeight/667);
//                item.frame = CGRectMake((actionSheet.frame.size.width-image.size.width)/2, offset, image.size.width, image.size.height);
                
                item.tag = tag++;
                [actionSheet addSubview:item];
                
                offset += item.frame.size.height + kSpaseHeight;
            }
        }
        
        actionSheet.frame = CGRectMake(0, viewController.view.frame.size.height, viewController.view.frame.size.width-40*2, offset + 10+30*kScreenHeight/667);
        
        // Present window and action sheet
        self.overlayWindow.rootViewController = viewController;
        self.overlayWindow.alpha = 0.0f;
        self.overlayWindow.hidden = NO;
        [self.overlayWindow makeKeyWindow];
        [[CMActionSheetStack sharedInstance] push:self];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            self.overlayWindow.alpha = 1;
            CGPoint center = actionSheet.center;
            center.y = center.y-actionSheet.frame.size.height+1;
            actionSheet.center = center;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                //                CGPoint center = actionSheet.center;
                //                center.y += 10;
                //                actionSheet.center = center;
            } completion:^(BOOL finished) {
                // we retain self until with dismiss action sheet
            }];
        }];
    }
}

- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated {
    // Hide window and action sheet
    [self hiddenWindowAndActionSheet];
    // Call callback
    
    if (index < self.callbacks.count) {
        CallbackBlock callback = [self.callbacks objectAtIndex:index];
        if (callback != nil) {
            callback();
        }
    }
    
    if (self.completionBlock) {
        self.completionBlock(index);
    }
    
}

#pragma mark - Private

- (void)hiddenWindowAndActionSheet
{
    UIView *actionSheet = self.overlayWindow.rootViewController.view.subviews.lastObject;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        self.overlayWindow.alpha = 0;
        CGPoint center = actionSheet.center;
        center.y += actionSheet.frame.size.height;
        actionSheet.center = center;
    } completion:^(BOOL finished) {
        
        self.overlayWindow.hidden = YES;
        [self.mainWindow makeKeyWindow];
        [[CMActionSheetStack sharedInstance] pop:self];
        // now we can release self
    }];
}

- (void)buttonClicked:(id)sender {
    NSUInteger buttonIndex = ((UIView *)sender).tag - 100;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


#pragma mark
#pragma mark UITapGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NSLog(@"%@",[touch.view class]);
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        
        return NO;
    }
    return  YES;
}

- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer
{
    [self hiddenWindowAndActionSheet];
    
    if ([self.delegate respondsToSelector:@selector(CMActionSheetDidSelectedBackGroundView:)]) {
        [self.delegate CMActionSheetDidSelectedBackGroundView:self];
    }
}

@end
