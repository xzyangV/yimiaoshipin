//
//  UPImageNormalFilter.m
//  Up
//
//  Created by sup-mac03 on 15/4/14.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageNormalFilter.h"

NSString *const kIFNormalShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );


@implementation UPImageNormalFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNormalShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
