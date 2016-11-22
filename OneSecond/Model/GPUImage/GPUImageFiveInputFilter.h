//
//  GPUImageFiveInputFilter.h
//  Up
//
//  Created by sup-mac03 on 15/4/3.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "GPUImageFourInputFilter.h"

extern NSString *const kGPUImageFiveInputTextureVertexShaderString;

@interface GPUImageFiveInputFilter : GPUImageFourInputFilter
{
    GPUImageFramebuffer *FiveInputFramebuffer;
    
    GLint filterFiveTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    GPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fiveFrameTime;
    
    BOOL hasSetFourTexture, hasReceivedFiveFrame, FiveFrameWasVideo;
    BOOL fiveFrameCheckDisabled;

}

- (void)disableFiveFrameCheck;
@end
