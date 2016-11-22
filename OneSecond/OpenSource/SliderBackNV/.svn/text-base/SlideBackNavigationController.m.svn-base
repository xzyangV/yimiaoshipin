//
//  XXNavigationController.m
//  XXNavigationController
//
//  Created by Tracy on 14-3-5.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "SlideBackNavigationController.h"
#import "MBProgressHUD.h"
//#import "PhotoMapViewController.h"


#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width



@interface SlideBackNavigationController ()<UIGestureRecognizerDelegate> {
    
    CGPoint startPoint;
    UIImageView *lastScreenShotView;        // view
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *screenShotList;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isPushing;
@property (nonatomic, weak) id<DidReceiveSlideBackNavTouchEvent> sliderBackDelegate;

@end

static CGFloat offset_float = 0.65;         // 拉伸参数
static CGFloat min_distance = 80;          // 最小回弹距离

@implementation SlideBackNavigationController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIImage *shadowImage = [UIImage imageNamed:@"sliderBackViewShadow"];
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.left-shadowImage.size.width, 0, shadowImage.size.width, self.view.height)];
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.image = shadowImage;
    [self.view addSubview:shadowView];
    
    // Do any additional setup after loading the view.
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    recognizer.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark Public Method

- (NSArray *)screenImageArray
{
    return self.screenShotList;
}

- (NSMutableArray *)screenShotList {
    if (!_screenShotList) {
        _screenShotList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _screenShotList;
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    self.backGroundView.hidden = YES;
    return [self gestureAnimation:animated];
    /*
    // 有动画用自己的动画
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        return [super popViewControllerAnimated:animated];
    }
     */
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.backGroundView.hidden = YES;
    NSUInteger popVCIndex = NSNotFound;
    for (int i = 0; i < [self.viewControllers count]; i ++) {
        UIViewController *tempVC = [self.viewControllers objectAtIndex:i];
        if (viewController == tempVC) {
            popVCIndex = i;
            break;
        }
    }
    if (popVCIndex != NSNotFound) {
        NSUInteger screenShotCount = [self.screenShotList count];
//        NSLog(@"self.screenShotList = %@",self.screenShotList);
        [self.screenShotList removeObjectsInRange:NSMakeRange(popVCIndex, screenShotCount-popVCIndex)];
//        NSLog(@"self.screenShotList = %@",self.screenShotList);
    }
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    self.backGroundView.hidden = YES;
    [self.screenShotList removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}

- (void) popAnimation {
    if (self.viewControllers.count == 1) {
        return;
    }
    if (!self.backGroundView) {
        CGRect frame = self.view.frame;
        
        self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        self.backGroundView.backgroundColor = [UIColor blackColor];
    }
    
    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    
    self.backGroundView.hidden = NO;
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotList lastObject];
    
    lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    
    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,kScreenWidth,MainScreenHeight};
    
    [self.backGroundView addSubview:lastScreenShotView];

    [UIView animateWithDuration:0.4 animations:^{
        
        [self moveViewWithX:kScreenWidth];
        
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self gestureAnimation:NO];
            
            CGRect frame = self.view.frame;
            
            frame.origin.x = 0;
            
            self.view.frame = frame;
            
            _isMoving = NO;
            
            self.backGroundView.hidden = YES;
        });
    }];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"self.topviewcontroller = %@  viewController = %@",self.topViewController,viewController);
    if (!self.topViewController) {
        // 首次加载根视图不需要截屏
        [super pushViewController:viewController animated:animated];
    }
    else {
        self.isPushing = YES;
        [self capture];
        self.backGroundView.hidden = NO;
        [super pushViewController:viewController animated:animated];
        double delayInSeconds = 0.7;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            self.isPushing = NO;
        });
    }
}


#pragma mark - Utility Methods -
// get the current view screen shot
- (void)capture
{
    UIViewController *screenViewController = self.tabBarController == nil ? self : self.tabBarController;
    if (!screenViewController) {
        return ;
    }
    UIGraphicsBeginImageContextWithOptions(screenViewController.view.bounds.size, screenViewController.view.opaque, [UIScreen mainScreen].scale);
    [screenViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (screenImage) {
        [self.screenShotList addObject:screenImage];
    }
//    double delayInSeconds = 0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
//        
//    });
}

// set lastScreenShotView 's position when paning
- (void)moveViewWithX:(float)x
{
    x = x > kScreenWidth ? kScreenWidth : x;
    
    x = x < 0 ? 0 : x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    // TODO
    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float)+x*offset_float,0,kScreenWidth,MainScreenHeight};
}

- (UIViewController *)gestureAnimation:(BOOL)animated {
//    NSLog(@"gestureAnimation");
    [self.screenShotList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
//    NSLog(@"paningGestureReceive isPushing = %d",self.isPushing);
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1) {
        return;
    }
    if (self.isPushing) {
        
        return;
    }

    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
//    NSLog(@"begin touch = %@",NSStringFromCGPoint(touchPoint));

    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        
        startPoint = touchPoint;
        // 背景
        if (!self.backGroundView) {
            CGRect frame = self.view.frame;
            
            self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            self.backGroundView.backgroundColor = [UIColor clearColor];
        }
        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
        self.backGroundView.hidden = NO;
        // 截图
        if (lastScreenShotView) {
            [lastScreenShotView removeFromSuperview];
        }
        UIImage *lastScreenShot = [self.screenShotList lastObject];
        lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,kScreenWidth,MainScreenHeight};
        [self.backGroundView addSubview:lastScreenShotView];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        
        if (touchPoint.x - startPoint.x > min_distance && _isMoving && [AppDelegate upAppDelegate].window.isKeyWindow)
        {
            [UIView animateWithDuration:0.4 animations:^{
                [self moveViewWithX:MainScreenWidth];
                
            } completion:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self gestureAnimation:NO];
                    CGRect frame = self.view.frame;
                    frame.origin.x = 0;
                    self.view.frame = frame;
                    _isMoving = NO;
                    self.backGroundView.hidden = YES;
                });
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backGroundView.hidden = YES;
            }];
        }
        return;
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){

        [UIView animateWithDuration:0.2 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backGroundView.hidden = YES;
        }];
        
        return;
    }

    if (_isMoving ) {
        [self moveViewWithX:touchPoint.x - startPoint.x];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    // 菊花转动的时候取消手势相应
    if ([touch.view class] == [MBProgressHUD class]) {
        return NO;
    }
    // 代理回传
    self.sliderBackDelegate = (id<DidReceiveSlideBackNavTouchEvent>)self.topViewController;
    if ([self.sliderBackDelegate respondsToSelector:@selector(didReceiveSlideBackNavTouchEvent:)]) {
        return [self.sliderBackDelegate didReceiveSlideBackNavTouchEvent:touch];
    }
    // 根视图取消手势相应
    if ([[self.viewControllers firstObject] class] == [self.topViewController class]) {
        return NO;
    }
    // 地图取消手势相应
//    if ([self.topViewController class] == [PhotoMapViewController class]) {
//        return NO;
//    }

    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
