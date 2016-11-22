//
//  BizCommon.m
//  一秒视频UP
//
//  Created by uper on 16/5/11.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "BizCommon.h"
#import "TranslucentButton.h"
#import "UIImage-Extension.h"
#import "UPBusinessDefine.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation BizCommon


+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action
{
    TranslucentButton *button = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 68, 32);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kBarBtnFont;
    [button setTitleColor:ColorForHex(0xf2e216) forState:UIControlStateNormal];
    [button setTitleColor:ColorForHexAlpha(0xf2f2f2, 0.5) forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    if (kIsIOS7) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    }
    else {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 6);
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)barBackBtnWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action
{
    UIButton *button = [self backBtnWithTitle:title clickTarget:target action:action];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIButton *)backBtnWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action
{
    //    if (title == nil) {
    //        title = UPLocalizedString(@"back", nil);//@"返回";
    //    }
    
    TranslucentButton *button = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"picback"] forState:UIControlStateNormal];
    //    button.frame = CGRectMake(0, 0, 65, 32);
    button.frame = CGRectMake(0, 0, 50, 32);
    //    button.backgroundColor = [UIColor brownColor];
    //    [button setTitle:title forState:UIControlStateNormal];
    //    button.titleLabel.font = kBarBtnFont;
    //    [button setTitleColor:kBarBtnFontColor forState:UIControlStateNormal];
    //    [button setTitleColor:ColorForRGB(153, 153, 153, 1) forState:UIControlStateDisabled];
    //    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //    if (kIsIOS7) {
    //        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    //        button.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, -6);
    //    }
    //    else {
    //        button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    //    }
    
    return button;
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action
{
    TranslucentButton *button = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 32);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kBarBtnFont;
    [button setTitleColor:kBarBtnFontColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)barBtnWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor*)titleColor titleFont:(UIFont*)titleFont target:(id)target action:(SEL)action
{
    UIButton *btn = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(0, 0, 55, 15);
    btn.exclusiveTouch = YES;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    //    [btn setTitleColor:ColorForRGB(153, 153, 153, 1) forState:UIControlStateDisabled];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -8);
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)barBtnWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self barBtnWithImage:image target:target action:action width:image.size.width];
}

+ (UIBarButtonItem *)barBtnWithImage:(UIImage *)image target:(id)target action:(SEL)action width:(CGFloat)width
{
    UIButton *btn = [TranslucentButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, width, image.size.height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

//生成一个纯颜色的图片
+ (UIImage *)imageWithColor:(UIColor *)color defaultWidth:(float)width defaultHeight:(float)height
{
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

// 生成一个居中正方的图片
+ (UIImage *)generateSquareImage:(UIImage *)image
{
    UIImage *newImg = image;
    if (image.size.width != image.size.height) {
        float cropImageWidth = image.size.width;
        float cropImageHeight = image.size.height;
        if (cropImageWidth > cropImageHeight) {
            cropImageWidth = cropImageHeight;
        }
        else {
            cropImageHeight = cropImageWidth;
        }
        newImg = [image cropToSize:CGSizeMake(cropImageWidth, cropImageHeight)
                         usingMode:NYXCropModeCenter];
    }
    
    return newImg;
}

+ (BOOL)imageSizeIsBig:(CGSize)size
{
    return (size.width > 2600 && size.height > 2600);
}

+ (void)setUPUIAppearance
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : kBarTitleFont,
                                                           NSForegroundColorAttributeName : kBarTitleFontColor,
                                                           NSShadowAttributeName : shadow}];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:kNBBarTintColor];
    [[UINavigationBar appearance] setTintColor:kCommonTextColor];
    
    [[UINavigationBar appearanceWhenContainedIn: [MPMoviePlayerViewController class], nil]
     setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn: [UIImagePickerController class], nil]
     setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

@end
