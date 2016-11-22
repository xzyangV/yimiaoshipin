//
//  GPUImageSixInputFilter.h
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "GPUImageFiveInputFilter.h"

extern NSString *const kGPUImageSixInputTextureVertexShaderString;

@interface GPUImageSixInputFilter : GPUImageFiveInputFilter
{
    GPUImageFramebuffer *sixInputFramebuffer;
    
    GLint filterSixTextureCoordinateAttribute;
    GLint filterInputTextureUniform6;
    GPUImageRotationMode inputRotation6;
    GLuint filterSourceTexture6;
    CMTime sixFrameTime;
    
    BOOL hasSetFiveTexture, hasReceivedSixFrame, sixFrameWasVideo;
    BOOL sixFrameCheckDisabled;

}
- (void)disableSixFrameCheck;
@end
