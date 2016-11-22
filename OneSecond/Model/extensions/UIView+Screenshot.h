//
//  UIView+Screenshot.h
//  RNFrostedSidebar
//
//  Created by amy on 14-1-20.
//  Copyright (c) 2014年 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

- (UIImage *)viewScreenshot;

- (UIImage *)generateRetinaImg:(BOOL)afterUpdates;
- (UIImage *)generateRetinaImg:(BOOL)afterUpdates scale:(CGFloat)scale;

- (UIImage *)generateImgWithAngle:(CGFloat)angle size:(CGSize)oldSize;

@end
