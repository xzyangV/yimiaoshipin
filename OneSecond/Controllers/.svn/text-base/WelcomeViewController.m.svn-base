//
//  WelcomeViewController.m
//  OneSecond
//
//  Created by uper on 16/5/18.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "UpWebViewController.h"
#import "UIImage+GIF.h"
@interface WelcomeViewController ()
@property (nonatomic,strong) UIImageView *loadingImageView;
@end

@implementation WelcomeViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initLoadingImageView];
    [self performSelector:@selector(introDidFinish) withObject:nil afterDelay:1.f];
}

- (void)initLoadingImageView
{
    NSString  *name = @"beginPlay.gif";
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    if (!self.loadingImageView) {
        self.loadingImageView = [[UIImageView alloc]init];
    }
    self.loadingImageView.backgroundColor = [UIColor clearColor];
    self.loadingImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    self.loadingImageView.frame = self.view.bounds;
    [self.view addSubview:self.loadingImageView];
    [self.view bringSubviewToFront:self.loadingImageView];
    
}

- (void)introDidFinish {
    
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 0.5;
        self.loadingImageView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.loadingImageView = nil;
        [[AppDelegate upAppDelegate] reloadApp];
        
    }];
    
}

//- (void)showBasicIntroWithBg {
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"This is page 1";
////    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
////    page1.titleImage = [UIImage imageNamed:@"original"];
//    page1.bgImage = [UIImage imageNamed:@"home_1"];
//    page1.urlStr = @"https://www.baidu.com";
//    
//    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"This is page 2";
////    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
////    page2.titleImage = [UIImage imageNamed:@"supportcat"];
//    page2.bgImage = [UIImage imageNamed:@"home_2"];
//    page2.urlStr = @"http://cnews.chinadaily.com.cn/2016-05/18/content_25345025.htm";
//    
//    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"This is page 3";
////    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
////    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
//    page3.bgImage = [UIImage imageNamed:@"home_3"];
//     page3.urlStr = @"http://www.cnblogs.com/kenshincui/p/4186022.html";
//    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
////    intro.bgImage = [UIImage imageNamed:@"introBg"];
//    
//    [intro setDelegate:self];
//    [intro showInView:self.view animateDuration:0.0];
//}
@end
