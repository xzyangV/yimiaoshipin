//
//  UpSnsShareManagement.m
//  Up
//
//  Created by zhangyx on 14-2-27.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "UpSnsShareManagement.h"
//#import "UpdateCheckObject.h"
#import "SDWebImageManager.h"
#import "HYActivityView.h"
//#import "WaterMarkObject.h"
#import "ConfigureObject.h"
//#import "UserObject.h"
#import "ShareTypeDef.h"

// public
#import "MBProgressHUD+CMBProgressHUD.h"
#import "UIImage-Extension.h"

//#define kShareContent [UpdateCheckObject sharedCheckObject].invite_share_content

#define kShareContent [UpSnsShareManagement inviteShareContent]

@implementation UpSnsShareManagement


// 显示动态分享框
+ (void)showShareToSnsAlert:(ExecAlertCompletedResultBlock)completedBlock
{
    [self showShareToSnsAlert:@"" block:completedBlock];
}

+ (void)showShareToSnsAlert:(NSString *)title block:(ExecAlertCompletedResultBlock)completedBlock
{
    //    __weak __typeof(self)wself = self;
    HYActivityView *myActivityView = [[HYActivityView alloc] initWithTitle:title];
    myActivityView.numberOfButtonPerLine = 4;
    ButtonView *bv = nil;
    // @"微信朋友圈"
    bv = [[ButtonView alloc] initWithText:@"微信朋友圈"
                                    image:[UIImage imageNamed:@"share_platform_pyq.png"]
                                  handler:^(ButtonView *buttonView) {
                                      if (completedBlock) {
                                          completedBlock (NO,ShareTypeWeixiTimeline);
                                      }
                                  }];
    [myActivityView addButtonView:bv];
    // @"微信好友"
    bv = [[ButtonView alloc]initWithText:@"微信好友"
                                   image:[UIImage imageNamed:@"share_platform_wxFri.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeWeixiSession);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    // @"新浪微博"
    bv = [[ButtonView alloc]initWithText:@"新浪微博"
                                   image:[UIImage imageNamed:@"share_platform_sina.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeSinaWeibo);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
        // QQ空间
        bv = [[ButtonView alloc]initWithText:@"QQ空间"
                                       image:[UIImage imageNamed:@"share_platform_qq.png"]
                                     handler:^(ButtonView *buttonView) {
                                         if (completedBlock) {
                                             completedBlock (NO,ShareTypeQQ);
                                         }
                                     }];
        [myActivityView addButtonView:bv];
    
    // FaceBook
    bv = [[ButtonView alloc]initWithText:@"Facebook"
                                   image:[UIImage imageNamed:@"share_platform_facebook.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeFaceBook);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    // twitter
    bv = [[ButtonView alloc]initWithText:@"Twitter"
                                   image:[UIImage imageNamed:@"share_platform_twitter.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeTwitter);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    [myActivityView show];
}

/*
// 显示水印、找玩伴分享框
+ (void)showActivityShareToSnsAlert:(ExecAlertCompletedResultBlock)completedBlock
{
    //    __weak __typeof(self)wself = self;
    HYActivityView *myActivityView = [[HYActivityView alloc] initWithTitle:@""];
    myActivityView.numberOfButtonPerLine = 3;
    ButtonView *bv = nil;
    // @"微信朋友圈"
    bv = [[ButtonView alloc] initWithText:UPLocalizedString(@"Weixin Moments", nil)
                                    image:[UIImage imageNamed:@"share_platform_pyq.png"]
                                  handler:^(ButtonView *buttonView) {
                                      if (completedBlock) {
                                          completedBlock (NO,ShareTypeWeixiTimeline);
                                      }
                                  }];
    [myActivityView addButtonView:bv];
    // @"微信好友"
    bv = [[ButtonView alloc]initWithText:UPLocalizedString(@"Weixin Friends", nil)
                                   image:[UIImage imageNamed:@"share_platform_wxFri.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeWeixiSession);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    // @"新浪微博"
    bv = [[ButtonView alloc]initWithText:UPLocalizedString(@"Sina weibo", nil)
                                   image:[UIImage imageNamed:@"share_platform_sina.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeSinaWeibo);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    if ([ShareObject isSupportSSOLogin:ShareTypeQQ]) {
        // QQ空间
        bv = [[ButtonView alloc]initWithText:UPLocalizedString(@"QQ space", nil)
                                       image:[UIImage imageNamed:@"share_platform_qq.png"]
                                     handler:^(ButtonView *buttonView) {
                                         if (completedBlock) {
                                             completedBlock (NO,ShareTypeQQ);
                                         }
                                     }];
        [myActivityView addButtonView:bv];
    }
    // FaceBook
    bv = [[ButtonView alloc]initWithText:@"Facebook"
                                   image:[UIImage imageNamed:@"share_platform_facebook.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeFaceBook);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
//    // twitter
//    bv = [[ButtonView alloc]initWithText:@"Twitter"
//                                   image:[UIImage imageNamed:@"share_platform_twitter.png"]
//                                 handler:^(ButtonView *buttonView) {
//                                     if (completedBlock) {
//                                         completedBlock (NO,ShareTypeTwitter);
//                                     }
//                                 }];
//    [myActivityView addButtonView:bv];
//    [myActivityView show];
}
*/
+ (void)showShareWithNOFacebookToSnsAlert:(NSString *)title block:(ExecAlertCompletedResultBlock)completedBlock{
    //    __weak __typeof(self)wself = self;
    HYActivityView *myActivityView = [[HYActivityView alloc] initWithTitle:title];
    myActivityView.numberOfButtonPerLine = 4;
    ButtonView *bv = nil;
    // @"微信朋友圈"
    bv = [[ButtonView alloc] initWithText:UPLocalizedString(@"Weixin Moments", nil)
                                    image:[UIImage imageNamed:@"share_platform_pyq.png"]
                                  handler:^(ButtonView *buttonView) {
                                      if (completedBlock) {
                                          completedBlock (NO,ShareTypeWeixiTimeline);
                                      }
                                  }];
    [myActivityView addButtonView:bv];
    // @"微信好友"
    bv = [[ButtonView alloc]initWithText:UPLocalizedString(@"Weixin Friends", nil)
                                   image:[UIImage imageNamed:@"share_platform_wxFri.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeWeixiSession);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    // @"新浪微博"
    bv = [[ButtonView alloc]initWithText:UPLocalizedString(@"Sina weibo", nil)
                                   image:[UIImage imageNamed:@"share_platform_sina.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeSinaWeibo);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
        // QQ空间
        bv = [[ButtonView alloc]initWithText:UPLocalizedString(@"QQ space", nil)
                                       image:[UIImage imageNamed:@"share_platform_qq.png"]
                                     handler:^(ButtonView *buttonView) {
                                         if (completedBlock) {
                                             completedBlock (NO,ShareTypeQQ);
                                         }
                                     }];
        [myActivityView addButtonView:bv];

    // FaceBook
    bv = [[ButtonView alloc]initWithText:@"Facebook"
                                   image:[UIImage imageNamed:@"share_platform_facebook.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeFaceBook);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    // twitter
    bv = [[ButtonView alloc]initWithText:@"Twitter"
                                   image:[UIImage imageNamed:@"share_platform_twitter.png"]
                                 handler:^(ButtonView *buttonView) {
                                     if (completedBlock) {
                                         completedBlock (NO,ShareTypeTwitter);
                                     }
                                 }];
    [myActivityView addButtonView:bv];
    [myActivityView show];
}
@end
