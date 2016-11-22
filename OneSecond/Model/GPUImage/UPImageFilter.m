//
//  UPImageFilter.m
//  Up
//
//  Created by sup-mac03 on 15/3/19.
//  Copyright (c) 2015年 amy. All rights reserved.
//

#import "UPImageFilter.h"

@implementation UPImageFilter


//+ (NSArray *)UPImageFilters
//{
//    return [NSArray arrayWithObjects:
//            @{UPFILTER_TYPE:@(UPImageFilter_normal),UPFILTER_NAME:@"ORIGINAL",UPFILTER_IMAGE:@"original"},
//            @{UPFILTER_TYPE:@(UPImageFilter_rise),UPFILTER_NAME:@"NEW\nYORK",UPFILTER_IMAGE:@"newyork"},
//            @{UPFILTER_TYPE:@(UPImageFilter_xproII),UPFILTER_NAME:@"BERLIN",UPFILTER_IMAGE:@"berlin"},
//            @{UPFILTER_TYPE:@(UPImageFilter_lomo),UPFILTER_NAME:@"TOKYO",UPFILTER_IMAGE:@"tokyo"},
//            @{UPFILTER_TYPE:@(UPImageFilter_valencia),UPFILTER_NAME:@"PARGUE",UPFILTER_IMAGE:@"prague"},
//            @{UPFILTER_TYPE:@(UPImageFilter_hefe),UPFILTER_NAME:@"SAO\nPAULO",UPFILTER_IMAGE:@"saopaulo"},
//            @{UPFILTER_TYPE:@(UPImageFilter_inkwell),UPFILTER_NAME:@"TAIPEI",UPFILTER_IMAGE:@"taipei"},
//            @{UPFILTER_TYPE:@(UPImageFilter_hudson),UPFILTER_NAME:@"MADRID",UPFILTER_IMAGE:@"madrid"},
//            @{UPFILTER_TYPE:@(UPImageFilter_earlybird),UPFILTER_NAME:@"PARIS",UPFILTER_IMAGE:@"paris"},
//            @{UPFILTER_TYPE:@(UPImageFilter_brannan),UPFILTER_NAME:@"VIENNA",UPFILTER_IMAGE:@"vienna"},
//            @{UPFILTER_TYPE:@(UPImageFilter_amaro),UPFILTER_NAME:@"ROME",UPFILTER_IMAGE:@"rome"},
//            @{UPFILTER_TYPE:@(UPImageFilter_Mono),UPFILTER_NAME:@"LONDON",UPFILTER_IMAGE:@"london"},
//            @{UPFILTER_TYPE:@(UPImageFilter_nashville),UPFILTER_NAME:@"HONG\nKONG",UPFILTER_IMAGE:@"hongkong"},
//            @{UPFILTER_TYPE:@(UPImageFilter_kelvin),UPFILTER_NAME:@"BANGKOK",UPFILTER_IMAGE:@"bangkok"},
//            @{UPFILTER_TYPE:@(UPImageFilter_blend),UPFILTER_NAME:@"MILAN",UPFILTER_IMAGE:@"milan"},
//            @{UPFILTER_TYPE:@(UPImageFilter_sierra),UPFILTER_NAME:@"LOS\nANGELES",UPFILTER_IMAGE:@"losangeles"},
//            @{UPFILTER_TYPE:@(UPImageFilter_sutro),UPFILTER_NAME:@"BEIJING",UPFILTER_IMAGE:@"beijing"}
//            ,nil];
//}

//+ (NSArray *)UPImageFilters
//{
//    return [NSArray arrayWithObjects:
//            @{UPFILTER_TYPE:@(UPImageFilter_normal),UPFILTER_NAME:@"原图",UPFILTER_IMAGE:@"original"},
//            @{UPFILTER_TYPE:@(UPImageFilter_rise),UPFILTER_NAME:@"纽约",UPFILTER_IMAGE:@"newyork"},
//            @{UPFILTER_TYPE:@(UPImageFilter_xproII),UPFILTER_NAME:@"柏林",UPFILTER_IMAGE:@"berlin"},
//            @{UPFILTER_TYPE:@(UPImageFilter_lomo),UPFILTER_NAME:@"东京",UPFILTER_IMAGE:@"tokyo"},
//            @{UPFILTER_TYPE:@(UPImageFilter_valencia),UPFILTER_NAME:@"布拉格",UPFILTER_IMAGE:@"prague"},
//            @{UPFILTER_TYPE:@(UPImageFilter_hefe),UPFILTER_NAME:@"圣保罗",UPFILTER_IMAGE:@"saopaulo"},
//            @{UPFILTER_TYPE:@(UPImageFilter_inkwell),UPFILTER_NAME:@"台北",UPFILTER_IMAGE:@"taipei"},
//            @{UPFILTER_TYPE:@(UPImageFilter_hudson),UPFILTER_NAME:@"马德里",UPFILTER_IMAGE:@"madrid"},
//            @{UPFILTER_TYPE:@(UPImageFilter_earlybird),UPFILTER_NAME:@"巴黎",UPFILTER_IMAGE:@"paris"},
//            @{UPFILTER_TYPE:@(UPImageFilter_brannan),UPFILTER_NAME:@"维也纳",UPFILTER_IMAGE:@"vienna"},
//            @{UPFILTER_TYPE:@(UPImageFilter_amaro),UPFILTER_NAME:@"罗马",UPFILTER_IMAGE:@"rome"},
//            @{UPFILTER_TYPE:@(UPImageFilter_Mono),UPFILTER_NAME:@"伦敦",UPFILTER_IMAGE:@"london"},
//            @{UPFILTER_TYPE:@(UPImageFilter_nashville),UPFILTER_NAME:@"香港",UPFILTER_IMAGE:@"hongkong"},
//            @{UPFILTER_TYPE:@(UPImageFilter_kelvin),UPFILTER_NAME:@"曼谷",UPFILTER_IMAGE:@"bangkok"},
//            @{UPFILTER_TYPE:@(UPImageFilter_blend),UPFILTER_NAME:@"米兰",UPFILTER_IMAGE:@"milan"},
//            @{UPFILTER_TYPE:@(UPImageFilter_sierra),UPFILTER_NAME:@"洛杉矶",UPFILTER_IMAGE:@"losangeles"},
//            @{UPFILTER_TYPE:@(UPImageFilter_sutro),UPFILTER_NAME:@"北京",UPFILTER_IMAGE:@"beijing"}
//            ,nil];
//}

+ (NSArray *)UPImageFilters
{
    return [NSArray arrayWithObjects:
            @{UPFILTER_TYPE:@(UPImageFilter_normal),UPFILTER_NAME:@"原图",UPFILTER_IMAGE:@"original"},
            @{UPFILTER_TYPE:@(UPImageFilter_lomo),UPFILTER_NAME:@"北京",UPFILTER_IMAGE:@"beijing"},
            @{UPFILTER_TYPE:@(UPImageFilter_xproII),UPFILTER_NAME:@"柏林",UPFILTER_IMAGE:@"berlin"},
            @{UPFILTER_TYPE:@(UPImageFilter_rise),UPFILTER_NAME:@"纽约",UPFILTER_IMAGE:@"newyork"},
            @{UPFILTER_TYPE:@(UPImageFilter_valencia),UPFILTER_NAME:@"圣保罗",UPFILTER_IMAGE:@"saopaulo"},
            @{UPFILTER_TYPE:@(UPImageFilter_hudson),UPFILTER_NAME:@"巴黎",UPFILTER_IMAGE:@"paris"},
            @{UPFILTER_TYPE:@(UPImageFilter_earlybird),UPFILTER_NAME:@"马德里",UPFILTER_IMAGE:@"madrid"},
            @{UPFILTER_TYPE:@(UPImageFilter_brannan),UPFILTER_NAME:@"维也纳",UPFILTER_IMAGE:@"vienna"},
            @{UPFILTER_TYPE:@(UPImageFilter_amaro),UPFILTER_NAME:@"罗马",UPFILTER_IMAGE:@"rome"},
            @{UPFILTER_TYPE:@(UPImageFilter_hefe),UPFILTER_NAME:@"布拉格",UPFILTER_IMAGE:@"prague"},
            @{UPFILTER_TYPE:@(UPImageFilter_sutro),UPFILTER_NAME:@"东京",UPFILTER_IMAGE:@"tokyo"},
            @{UPFILTER_TYPE:@(UPImageFilter_nashville),UPFILTER_NAME:@"伦敦",UPFILTER_IMAGE:@"hongkong"},
            @{UPFILTER_TYPE:@(UPImageFilter_kelvin),UPFILTER_NAME:@"曼谷",UPFILTER_IMAGE:@"bangkok"},
            @{UPFILTER_TYPE:@(UPImageFilter_blend),UPFILTER_NAME:@"米兰",UPFILTER_IMAGE:@"milan"},
            @{UPFILTER_TYPE:@(UPImageFilter_sierra),UPFILTER_NAME:@"香港",UPFILTER_IMAGE:@"losangeles"},
            @{UPFILTER_TYPE:@(UPImageFilter_inkwell),UPFILTER_NAME:@"德黑兰",UPFILTER_IMAGE:@"taipei"},
            @{UPFILTER_TYPE:@(UPImageFilter_Mono),UPFILTER_NAME:@"墨西哥",UPFILTER_IMAGE:@"london"}
            ,nil];
}

+ (void)filterImageWithSourcePicture:(GPUImagePicture *)inputPicture
                     outPutImageView:(GPUImageView *)outputView
                          filterType:(UPImageFilterType)type
{
    [inputPicture removeAllTargets];
    id filter = [self filterWithType:type];
    [inputPicture addTarget:filter];
    [filter addTarget:outputView];
    [inputPicture processImage];
}

+ (UIImage *)filteredImageWithSourcePicture:(GPUImagePicture *)inputPicture
                                 filterType:(UPImageFilterType)type;
{
    [inputPicture removeAllTargets];
    id filter = [self filterWithType:type];
    [inputPicture addTarget:filter];
    [filter useNextFrameForImageCapture];
    [inputPicture processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

+ (void )filterVideoWithVideoFileURL:(NSURL *)fileURL filterType:(UPImageFilterType)type completionHandler:(void (^)(NSString *path))handler
{
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"hello" withExtension:@"mp4"];
    GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = NO;
    GPUImagePixellateFilter *filter = [[GPUImagePixellateFilter alloc] init];
    //    filter = [[GPUImageUnsharpMaskFilter alloc] init];
    
    [movieFile addTarget:filter];
    
    // Only rotate the video for display, leave orientation the same for recording
//    GPUImageView *filterView = (GPUImageView *)aView;
//    [filter addTarget:filterView];
    
    // In addition to displaying to the screen, write out a processed version of the movie to disk
    //    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSLog(@"path:%@",pathToMovie);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    [filter addTarget:movieWriter];
    
    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    __weak GPUImageMovieWriter *wMovieWriter = movieWriter;
    [movieWriter setCompletionBlock:^{
        [filter removeTarget:wMovieWriter];
        [wMovieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(pathToMovie);
        });
    }];
}

+ (id)filterWithType:(UPImageFilterType)type
{
    switch (type) {
        case UPImageFilter_normal:
        {
            UPImageNormalFilter *filter = [[UPImageNormalFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_Mono:
        {
            UPImageMonoFilter *filter = [[UPImageMonoFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_inkwell:
        {
            UPImageInkwellFilter *filter = [[UPImageInkwellFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_nashville:
        {
            UPImageNashvilleFilter *filter = [[UPImageNashvilleFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_kelvin:
        {
            UPImageKelvinFilter *filter = [[UPImageKelvinFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_xproII:
        {
            UPImageXproIIFilter *filter = [[UPImageXproIIFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_lomo:
        {
            UPImageLomoFilter *filter = [[UPImageLomoFilter alloc] init];
            return filter;
            
        }
            break;
//        case UPImageFilter_walden:
//        {
//            UPImageWaldenFilter *filter = [[UPImageWaldenFilter alloc] init];
//            return filter;
//        }
//            break;
        case UPImageFilter_valencia:
        {
            UPImageValenciaFilter *filter = [[UPImageValenciaFilter alloc] init];
            return filter;
        }
            break;
//        case UPImageFilter_1977:
//        {
//            UPImage1977Filter *filter = [[UPImage1977Filter alloc] init];
//            return filter;
//        }
//            break;
        case UPImageFilter_blend:
        {
            GPUImageFilterGroup *filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            [saturationFilter setSaturation:0.5];
            [filter addFilter:saturationFilter];
            
            GPUImageMonochromeFilter *monochromeFilter = [[GPUImageMonochromeFilter alloc] init];
            [monochromeFilter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.0f}];
            [monochromeFilter setIntensity:0.2];
            [saturationFilter addTarget:monochromeFilter];
            [filter addFilter:monochromeFilter];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            [exposureFilter setExposure:0.3];
            [monochromeFilter addTarget:exposureFilter];
            [filter addFilter:exposureFilter];
            
            [filter setInitialFilters:[NSArray arrayWithObjects:saturationFilter, nil]];
            [filter setTerminalFilter:exposureFilter];
            
            return filter;
        }
            break;
        case UPImageFilter_amaro:
        {
            UPImageAmaroFilter *filter = [[UPImageAmaroFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_rise:
        {
            UPImageRiseFilter *filter = [[UPImageRiseFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_hudson:
        {
            UPImageHudsonFilter *filter = [[UPImageHudsonFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_sierra:
        {
            UPImageSierraFilter *filter = [[UPImageSierraFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_earlybird:
        {
            UPImageEarlybirdFilter *filter = [[UPImageEarlybirdFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_sutro:
        {
            UPImageSutroFilter *filter = [[UPImageSutroFilter alloc] init];
            return filter;
        }
            break;
//        case UPImageFilter_toaster:
//        {
//            UPImageToasterFilter *filter = [[UPImageToasterFilter alloc] init];
//            return filter;
//        }
//            break;
        case UPImageFilter_brannan:
        {
            UPImageBrannanFilter *filter = [[UPImageBrannanFilter alloc] init];
            return filter;
        }
            break;
        case UPImageFilter_hefe:
        {
            UPImageHefeFilter *filter = [[UPImageHefeFilter alloc] init];
            return filter;
        }
            break;

        default:
        {
            GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
            return filter;
        }
            
            break;
    }
}
@end
