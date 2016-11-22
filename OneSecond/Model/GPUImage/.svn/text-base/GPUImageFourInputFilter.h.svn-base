//
//  GPUImageFourInputFilter.h
//  Up
//
//  Created by sup-mac03 on 15/4/1.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "GPUImageThreeInputFilter.h"

extern NSString *const kGPUImageFourInputTextureVertexShaderString;

@interface GPUImageFourInputFilter : GPUImageThreeInputFilter
{
    GPUImageFramebuffer *fourInputFramebuffer;
    
    GLint filterFourTextureCoordinateAttribute;
    GLint filterInputTextureUniform4;
    GPUImageRotationMode inputRotation4;
    GLuint filterSourceTexture4;
    CMTime fourFrameTime;
    
    BOOL hasSetThirdTexture, hasReceivedFourFrame, FourFrameWasVideo;
    BOOL fourFrameCheckDisabled;
}

- (void)disableFourFrameCheck;

@end
