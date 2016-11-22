//
//  UIImage-Extension.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NYXImagesHelper.h"
#import <ImageIO/ImageIO.h>

typedef enum
{
    NYXCropModeTopLeft,
    NYXCropModeTopCenter,
    NYXCropModeTopRight,
    NYXCropModeBottomLeft,
    NYXCropModeBottomCenter,
    NYXCropModeBottomRight,
    NYXCropModeLeftCenter,
    NYXCropModeRightCenter,
    NYXCropModeCenter
} NYXCropMode;

typedef enum
{
    NYXResizeModeScaleToFill,
    NYXResizeModeAspectFit,
    NYXResizeModeAspectFill
} NYXResizeMode;


@interface UIImage (CS_Extensions)

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

//- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
//- (UIImage *)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)cropImage:(CGRect)rect;
- (UIImage *)fixOrientation;


-(UIImage *)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode;

// NYXCropModeTopLeft crop mode used
-(UIImage *)cropToSize:(CGSize)newSize;

-(UIImage *)scaleByFactor:(float)scaleFactor;

-(UIImage *)scaleToSize:(CGSize)newSize usingMode:(NYXResizeMode)resizeMode;

// NYXResizeModeScaleToFill resize mode used
-(UIImage *)scaleToSize:(CGSize)newSize;

// Same as 'scale to fill' in IB.
//-(UIImage*)scaleToFillSize:(CGSize)newSize;

// Preserves aspect ratio. Same as 'aspect fit' in IB.
-(UIImage *)scaleToFitSize:(CGSize)newSize;

// Preserves aspect ratio. Same as 'aspect fill' in IB.
-(UIImage *)scaleToCoverSize:(CGSize)newSize;


-(UIImage *)scaleToBytes:(size_t)newBytes usingMode:(NYXResizeMode)resizeMode;

@end


