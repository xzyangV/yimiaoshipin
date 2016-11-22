//
//  UPImage77Filter.m
//  Up
//
//  Created by sup-mac03 on 15/3/24.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImage1977BaseFilter.h"

NSString *const kIF1977ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation UPImage1977BaseFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIF1977ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
