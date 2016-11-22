//
//  UIImage-Extensions.m
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

#import "UIImage-Extension.h"
//#import "ARCHelper.h"

CGFloat kDegreesToRadians(CGFloat degrees);
CGFloat kRadiansToDegrees(CGFloat radians);

@implementation UIImage (CS_Extensions)

- (UIImage *)cropImage:(CGRect) rect{
    CGAffineTransform rectTransform;
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(kDegreesToRadians(90)), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(kDegreesToRadians(-90)), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(kDegreesToRadians(-180)), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

-(UIImage*)resizedImageToSize:(CGSize)dstSize
{
	CGImageRef imgRef = self.CGImage;
	// the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
	CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    
	CGFloat scaleRatio = dstSize.width / srcSize.width;
	UIImageOrientation orient = self.imageOrientation;
	CGAffineTransform transform = CGAffineTransformIdentity;
	switch(orient) {
            
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
            
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
            
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
            
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
            
		case UIImageOrientationLeftMirrored: //EXIF = 5
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
			break;
            
		case UIImageOrientationLeft: //EXIF = 6
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
			break;
            
		case UIImageOrientationRightMirrored: //EXIF = 7
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
            
		case UIImageOrientationRight: //EXIF = 8
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
            
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
	}
    
	/////////////////////////////////////////////////////////////////////////////
	// The actual resize: draw the image on a new context, applying a transform matrix
	UIGraphicsBeginImageContextWithOptions(dstSize, NO, 0.0);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -srcSize.height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -srcSize.height);
	}
    
	CGContextConcatCTM(context, transform);
    
	// we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
	UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return resizedImage;
}



/////////////////////////////////////////////////////////////////////////////



//- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale
//{
//	// get the image size (independant of imageOrientation)
//	CGImageRef imgRef = self.CGImage;
//	CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which depends on the imageOrientation)!
//    
//	// adjust boundingSize to make it independant on imageOrientation too for farther computations
//	UIImageOrientation orient = self.imageOrientation;
//	switch (orient) {
//		case UIImageOrientationLeft:
//		case UIImageOrientationRight:
//		case UIImageOrientationLeftMirrored:
//		case UIImageOrientationRightMirrored:
//			boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
//			break;
//        default:
//            // NOP
//            break;
//	}
//    
//	// Compute the target CGRect in order to keep aspect-ratio
//	CGSize dstSize;
//    
//	if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
//		//NSLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
//		dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
//	} else {
//		CGFloat wRatio = boundingSize.width / srcSize.width;
//		CGFloat hRatio = boundingSize.height / srcSize.height;
//        
//		if (wRatio < hRatio) {
////			NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
//			dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
//		} else {
////			NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
//            dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
//			
//		}
//	}
////    NSLog(@"%@", NSStringFromCGSize(dstSize))
//	return [self resizedImageToSize:dstSize];
//}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:kRadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees 
{
    
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(kDegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, kDegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode
{
    const CGSize size = self.size;
    CGFloat x, y;
    switch (cropMode)
    {
        case NYXCropModeTopLeft:
            x = y = 0.0f;
            break;
        case NYXCropModeTopCenter:
            x = (size.width - newSize.width) * 0.5f;
            y = 0.0f;
            break;
        case NYXCropModeTopRight:
            x = size.width - newSize.width;
            y = 0.0f;
            break;
        case NYXCropModeBottomLeft:
            x = 0.0f;
            y = size.height - newSize.height;
            break;
        case NYXCropModeBottomCenter:
            x = (size.width - newSize.width) * 0.5f;
            y = size.height - newSize.height;
            break;
        case NYXCropModeBottomRight:
            x = size.width - newSize.width;
            y = size.height - newSize.height;
            break;
        case NYXCropModeLeftCenter:
            x = 0.0f;
            y = (size.height - newSize.height) * 0.5f;
            break;
        case NYXCropModeRightCenter:
            x = size.width - newSize.width;
            y = (size.height - newSize.height) * 0.5f;
            break;
        case NYXCropModeCenter:
            x = (size.width - newSize.width) * 0.5f;
            y = (size.height - newSize.height) * 0.5f;
            break;
        default: // Default to top left
            x = y = 0.0f;
            break;
    }
    
    CGRect cropRect = CGRectMake(x * self.scale, y * self.scale, newSize.width * self.scale, newSize.height * self.scale);
    
    /// Create the cropped image
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    UIImage* cropped = [UIImage imageWithCGImage:croppedImageRef scale:self.scale orientation:self.imageOrientation];
    
    /// Cleanup
    CGImageRelease(croppedImageRef);
    
    return cropped;
}

/* Convenience method to crop the image from the top left corner */
-(UIImage*)cropToSize:(CGSize)newSize
{
    return [self cropToSize:newSize usingMode:NYXCropModeTopLeft];
}

-(UIImage*)scaleByFactor:(float)scaleFactor
{
    CGSize scaledSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);
    return [self scaleToFillSize:scaledSize];
}

-(UIImage*)scaleToSize:(CGSize)newSize usingMode:(NYXResizeMode)resizeMode
{
    switch (resizeMode)
    {
        case NYXResizeModeAspectFit:
            return [self scaleToFitSize:newSize];
        case NYXResizeModeAspectFill:
            return [self scaleToCoverSize:newSize];
        default:
            return [self scaleToFillSize:newSize];
    }
}

/* Convenience method to scale the image using the NYXResizeModeScaleToFill mode */
-(UIImage*)scaleToSize:(CGSize)newSize
{
    return [self scaleToFillSize:newSize];
}

-(UIImage*)scaleToFillSize:(CGSize)newSize
{
    size_t destWidth = (size_t)(newSize.width * self.scale);
    size_t destHeight = (size_t)(newSize.height * self.scale);
    if (self.imageOrientation == UIImageOrientationLeft
        || self.imageOrientation == UIImageOrientationLeftMirrored
        || self.imageOrientation == UIImageOrientationRight
        || self.imageOrientation == UIImageOrientationRightMirrored)
    {
        size_t temp = destWidth;
        destWidth = destHeight;
        destHeight = temp;
    }
    
    /// Create an ARGB bitmap context
    CGContextRef bmContext = NYXCreateARGBBitmapContext(destWidth, destHeight, destWidth * kNyxNumberOfComponentsPerARBGPixel, NYXImageHasAlpha(self.CGImage));
    if (!bmContext)
        return nil;
    
    /// Image quality
    CGContextSetShouldAntialias(bmContext, true);
    CGContextSetAllowsAntialiasing(bmContext, true);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    /// Draw the image in the bitmap context
    
    UIGraphicsPushContext(bmContext);
    CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), self.CGImage);
    UIGraphicsPopContext();
    
    /// Create an image object from the context
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:self.scale orientation:self.imageOrientation];
    
    /// Cleanup
    CGImageRelease(scaledImageRef);
    CGContextRelease(bmContext);
    
    return scaled;
}

-(UIImage *)scaleToFitSize:(CGSize)newSize
{
    /// Keep aspect ratio
    size_t destWidth, destHeight;
    if (self.size.width > self.size.height)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
    }
    else
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
    }
    if (destWidth > newSize.width)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
    }
    if (destHeight > newSize.height)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
    }
    return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

-(UIImage*)scaleToCoverSize:(CGSize)newSize
{
    size_t destWidth, destHeight;
    CGFloat widthRatio = newSize.width / self.size.width;
    CGFloat heightRatio = newSize.height / self.size.height;
    /// Keep aspect ratio
    if (heightRatio > widthRatio)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
    }
    else
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
    }
    return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

-(UIImage *)scaleToBytes:(size_t)newBytes usingMode:(NYXResizeMode)resizeMode
{
    size_t pixel = CGImageGetBitsPerPixel(self.CGImage);
    CGFloat aspectRatio = self.size.width / self.size.height;
    CGFloat cpsWidth = sqrtf(aspectRatio * (newBytes/pixel)*8)/self.scale;
    CGFloat cpsHeight = cpsWidth / aspectRatio;
    
    UIImage *shareThumbnail = [self scaleToSize:CGSizeMake(cpsWidth, cpsHeight)
                                      usingMode:resizeMode];
    return shareThumbnail;
}


@end

#pragma mark - C function

CGFloat kDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat kRadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
