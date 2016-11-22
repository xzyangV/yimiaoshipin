//
//  UIView+Screenshot.m
//  RNFrostedSidebar
//
//  Created by amy on 14-1-20.
//  Copyright (c) 2014年 Ryan Nystrom. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)viewScreenshot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    image = [UIImage imageWithData:imageData];
    return image;
}

- (UIImage *)generateRetinaImg:(BOOL)afterUpdates
{
//    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 1.0);
//    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
//        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
//    }
//    else{
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    }
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return viewImage;
    return [self generateRetinaImg:afterUpdates scale:1.0];
}

- (UIImage *)generateRetinaImg:(BOOL)afterUpdates scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
//    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
//        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
//    }
//    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    }
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (UIImage *)generateImgWithAngle:(CGFloat)angle size:(CGSize)oldSize
{
    CGSize imageSize = self.frame.size;
//    NSLog(@"imageSize = %@",NSStringFromCGSize(imageSize));
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
//    CGContextConcatCTM(context, self.transform);
    CGContextTranslateCTM(context, (imageSize.width)/2 - (-sinf(angle)*oldSize.height/2+cosf(angle)*oldSize.width/2),
                                   (imageSize.height)/2 - (cosf(angle)*oldSize.height/2+sinf(angle)*oldSize.width/2));
    CGContextRotateCTM(context, angle);

    CGContextSetAllowsAntialiasing(context, YES);


    [self.layer renderInContext:context];
    CGContextRestoreGState(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
