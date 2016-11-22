//
//  UPImageFilter.h
//  Up
//
//  Created by sup-mac03 on 15/3/19.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPImage.h"

#define UPFILTER_TYPE @"filter_type"
#define UPFILTER_NAME @"filter_name"
#define UPFILTER_IMAGE @"filter_image"

//typedef enum: NSInteger{
//    UPImageFilter_normal = 0,
//    UPImageFilter_rise,         //1
//    UPImageFilter_xproII,       //2
//    UPImageFilter_lomo,         //3
//    UPImageFilter_valencia,     //4
//    UPImageFilter_hefe,         //5
//    UPImageFilter_inkwell,      //6
//    UPImageFilter_hudson,       //7
//    UPImageFilter_earlybird,    //8
//    UPImageFilter_brannan,      //9
//    UPImageFilter_amaro,        //10
//    UPImageFilter_Mono,         //11
//    
//    UPImageFilter_nashville,    //12
//    UPImageFilter_kelvin,       //13
////    UPImageFilter_walden,       //14
////    UPImageFilter_1977,         //15
//    UPImageFilter_blend,        //16
//    UPImageFilter_sierra,       //17
//    UPImageFilter_sutro,        //18
////    UPImageFilter_toaster,      //19
//}UPImageFilterType;

typedef enum: NSInteger{
    UPImageFilter_normal = 0,
    UPImageFilter_lomo = 1,
    UPImageFilter_xproII = 2,
    UPImageFilter_rise = 3,
    UPImageFilter_valencia = 4,
    UPImageFilter_hudson = 5,
    UPImageFilter_earlybird = 6,
    UPImageFilter_brannan = 7,
    UPImageFilter_amaro = 8,
    UPImageFilter_hefe = 9,
    UPImageFilter_sutro = 10,
    UPImageFilter_nashville = 11,
    UPImageFilter_kelvin = 12,
    UPImageFilter_blend = 13,
    UPImageFilter_sierra = 14,
    UPImageFilter_inkwell = 15,
    UPImageFilter_Mono = 16,
}UPImageFilterType;


@interface UPImageFilter : NSObject

+ (NSArray *)UPImageFilters;

+ (void)filterImageWithSourcePicture:(GPUImagePicture *)inputPicture
                     outPutImageView:(GPUImageView *)outputView
                          filterType:(UPImageFilterType)type;
+ (void )filterVideoWithVideoFileURL:(NSURL *)fileURL filterType:(UPImageFilterType)type completionHandler:(void (^)(NSString *path))handler;

+ (UIImage *)filteredImageWithSourcePicture:(GPUImagePicture *)inputPicture
                               filterType:(UPImageFilterType)type;
+ (id)filterWithType:(UPImageFilterType)type;
@end
