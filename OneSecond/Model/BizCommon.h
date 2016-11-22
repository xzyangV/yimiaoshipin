//
//  BizCommon.h
//  一秒视频UP
//
//  Created by uper on 16/5/11.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXAlertView+Customization.h"

@interface BizCommon : NSObject


//导航条普通按钮 右边样式
+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action;

//导航条返回按钮
+ (UIBarButtonItem *)barBackBtnWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action;

//只有文字
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title clickTarget:(id)target action:(SEL)action;

//只有图片
+ (UIBarButtonItem *)barBtnWithImage:(UIImage *)image target:(id)target action:(SEL)action;

//自定义图片文字
+ (UIBarButtonItem *)barBtnWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor*)titleColor titleFont:(UIFont*)titleFont target:(id)target action:(SEL)action;

//生成一个纯颜色的图片
+ (UIImage *)imageWithColor:(UIColor *)color defaultWidth:(float)width defaultHeight:(float)height;

// 生成一个居中正方的图片
+ (UIImage *)generateSquareImage:(UIImage *)image;
+ (BOOL)imageSizeIsBig:(CGSize)size;
 // 统一设置界面样式
+ (void)setUPUIAppearance;
@end
