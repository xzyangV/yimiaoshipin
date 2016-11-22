//
//  UPAssetManager.h
//  Up
//
//  Created by amy on 14-9-10.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

typedef enum : NSUInteger {
    UPAssetImageTypeThumbnail,                                  // 缩略图
    UPAssetImageTypeAspectRatioThumbnail,                       // 缩略图 保持纵横比
    
    UPAssetImageTypeLowFullScreen NS_ENUM_AVAILABLE_IOS(8_0),   // 低质量全屏图(带options.resizeMode参数)
    UPAssetImageTypeFullScreen,                                 // 适合屏幕尺寸的全屏图
    UPAssetImageTypeFullScreenEx,                               // 同上 对超长图做优化
    
    UPAssetImageTypeOriginal,                                   // 没处理的原始高清图
    UPAssetImageTypeOriginalAdjustment,                         // 处理后的原始高清图
    UPAssetImageTypeOriginalAdjustmentEx                        // 同上 对超大图做优化
} UPAssetImageType;

typedef NS_ENUM(NSInteger, UPAssetMediaType) {
    UPAssetMediaTypeAny     = -1,
    UPAssetMediaTypeUnknown = 0,
    UPAssetMediaTypeImage   = 1,
    UPAssetMediaTypeVideo   = 2,
    UPAssetMediaTypeAudio   = 3,
};


typedef NS_ENUM(NSInteger, UPImageContentMode) {
    UPImageContentModeAspectFit     = 0,    // Default 同PHImageContentModeAspectFit
    UPImageContentModeAspectFill    = 1,    // 缩略图时用 同PHImageContentModeAspectFill
};


typedef NS_ENUM(NSInteger, UPAssetCollectionType) {
    UPAssetCollectionTypeAll        = 0,    // 自定义“全部照片”相册集类型
    UPAssetCollectionTypeAlbum      = 1,    // 系统相册 同PHAssetCollectionTypeAlbum
    UPAssetCollectionTypeSmartAlbum = 2,    // 系统聪明的相册 同PHAssetCollectionTypeSmartAlbum
    UPAssetCollectionTypeMoment     = 3,    // 系统时刻的相册 同PHAssetCollectionTypeMoment
};

typedef NS_ENUM(NSInteger, UPAssetCollectionSubtype) {
    UPAssetCollectionSubtypeAll             = 0, // 自定义“全部照片”相册集子类型
    UPAssetCollectionSubtypeAlbumRegular    = 2, // 同UPAssetCollectionSubtypeAlbumRegular
    UPAssetCollectionSubtypeAny             = INT32_MAX // 同PHAssetCollectionSubtypeAny
};

/** 照片库发生变化通知 */
extern NSString * const UPPhotoLibraryChangedNotification;
/** asset(PHAsset) url scheme */
extern NSString * const UPAssetURLScheme;
/** asset(ALAsset) url scheme */
extern NSString * const ALAAssetURLScheme;

#define UPImageResultIsInCloudKey ([UPAssetManager imageResultIsInCloudKey])
// iOS8图片请求默认参数时回调两次，先快速返回低质量图，再二次返回原图，判断是否低质量图需要检查IsDegradedKey是否为1
#define UPImageResultIsDegradedKey ([UPAssetManager imageResultIsDegradedKey])
#define UPImageResultRequestIDKey ([UPAssetManager imageResultRequestIDKey])
#define UPImageManagerMaximumSize ([UPAssetManager imageManagerMaximumSize])

@class AVAsset;
@class UPAssetManager;

@interface UPAsset : NSObject

/** 将URL转换成localIdentifier */
+ (NSString *)localIdentifierWithURL:(NSURL *)url;

/** 实际对象 PHAsset/ALAsset */
@property (nonatomic, strong, readonly) id actualObject;
/** 唯一标识 PHAsset.localIdentifier/ALAsset.URL.absoluteString */
@property (nonatomic, strong, readonly) NSString *localIdentifier;
/** PHAsset URL = "assets-library://" + PHAsset.localIdentifier, ALAsset.URL */
@property (nonatomic, strong, readonly) NSURL *url;
/** 缩略图 PHAsset无(PH有自己的缓存机制)/ALAsset.thumbnail */
@property (nonatomic, strong, readonly) UIImage *thumbnail;
/** 位置信息 */
@property (nonatomic, strong, readonly) CLLocation *location;
/** 视频持续时间 */
@property (nonatomic, assign, readonly) NSTimeInterval duration;
/** 资源类型 */
@property (nonatomic, assign, readonly) UPAssetMediaType mediaType;
/** 图片类型 */
@property (nonatomic, assign, readonly) UPAssetImageType imageType;

/** 自定义值 序号标识 */
@property (nonatomic, assign) NSInteger tag;
/** 自定义值 原图 */
@property (nonatomic, strong) UIImage *userImage;
/** 自定义值 其它信息 */
@property (nonatomic, strong) NSDictionary *userInfo;
/** 是否被修改过 */
@property (nonatomic, assign) BOOL isEdited;

- (UPAsset *)buildNewUpAsset:(UIImage *)image;

@end


@interface UPAssetCollection : NSObject
/** 资源集(相册)PHAssetCollection/ALAssetsGroup */
@property (nonatomic, strong, readonly) id actualObject;
/** 唯一标识PHAssetCollection.localIdentifier/ALAssetsGroup.URL.absoluteString */
@property (nonatomic, strong, readonly) NSString *localIdentifier;
/** ALAssetsGroup.URL */
@property (nonatomic, strong, readonly) NSURL *url;
/** 预览缩略图 */
@property (nonatomic, strong, readonly) UIImage *posterImage;
/** 标题名称 */
@property (nonatomic, strong, readonly) NSString *title;
/** 资源集(相册)类型PHAssetCollection.assetCollectionType/ALAssetsGroup.ALAssetsGroupType */
@property (nonatomic, assign, readonly) UPAssetCollectionType type;
/** 资源集(相册)子类型PHAssetCollection。assetCollectionSubtype/ALAssetsGroup无 */
@property (nonatomic, assign, readonly) UPAssetCollectionSubtype subType;
/** 资源总数量 */
@property (nonatomic, assign, readonly) NSInteger numberOfAssets;

/** 自定义值 序号标识 */
@property (nonatomic, assign) NSInteger tag;
/** 自定义值 其它信息 */
@property (nonatomic, strong) NSDictionary *userInfo;
@end



typedef void (^UPAssetManagerCompletionHandler) (UIImage *image, NSURL *url, UPAssetImageType type);
typedef void (^UPAssetManagerResultHandler) (UIImage *image, NSDictionary *info);
typedef void (^UPAssetManagerWriteCompletionHandler) (UPAsset *asset, NSError *error);

//目前只有iCloud图片请求回调，故暂用不到
//typedef void (^UPAssetManagerProgressHandler) (double progress);


@interface UPAssetManager : NSObject

/** 请求的图片在iColud中 */
+ (NSString *)imageResultIsInCloudKey NS_AVAILABLE_IOS(8_0);
/** 请求的图片是低质量的图(iOS8请求图片默认先返回低质量图再返回高质量原图回调两次) */
+ (NSString *)imageResultIsDegradedKey NS_AVAILABLE_IOS(8_0);
/** 请求的图片操作的ID 取消请求时用 */
+ (NSString *)imageResultRequestIDKey NS_AVAILABLE_IOS(8_0);
/** 请求的图片最大尺寸 */
+ (CGSize)imageManagerMaximumSize NS_AVAILABLE_IOS(8_0);

+ (UPAssetMediaType)upAssetMediaTypeWithALAsset:(ALAsset *)alAsset;
+ (NSInteger)authorizationStatus;
+ (BOOL)unauthorized;
+ (BOOL)isAssetURL:(NSURL *)url;

+ (id)sharedManager;


/** 重新加载所有资源集(相册)及默认的资源数据 */
- (void)reloadDataForMediaType:(UPAssetMediaType)mediaType completionHandler:(void(^)(NSError *error))completionHandler;
/** 重新加载指定资源集(相册)的资源数据 */
- (void)reloadCurrentAssetCollection:(UPAssetCollection *)assetCollection;

/** 请求照片库海报预览图按类型 */
- (void)requestPhotoLibraryPosterImageForMediaType:(UPAssetMediaType)mediaType completionHandler:(void(^)(UIImage *image))completionHandler;


/** 请求缩略图按Asset */
- (int32_t)requestThumbnailForAsset:(UPAsset *)asset resultHandler:(UPAssetManagerResultHandler)resultHandler;
/** 请求图片按类型 */
- (int32_t)requestImageForAsset:(UPAsset *)asset imageType:(UPAssetImageType)imageType resultHandler:(UPAssetManagerResultHandler)resultHandler;
/** 请求图片按类型、是否需要调整方向(默认调整) */
- (int32_t)requestImageForAsset:(UPAsset *)asset imageType:(UPAssetImageType)imageType fixOrientation:(BOOL)fixOrientation resultHandler:(UPAssetManagerResultHandler)resultHandler ;

/** 请求图片按Size、contentMode */
- (int32_t)requestImageForAsset:(UPAsset *)asset targetSize:(CGSize)targetSize contentMode:(UPImageContentMode)contentMode resultHandler:(UPAssetManagerResultHandler)resultHandler NS_AVAILABLE_IOS(8_0);

/** 取消获取图片请求 */
- (void)cancelImageRequest:(int32_t)requestID NS_AVAILABLE_IOS(8_0);

/** 获取图片通过ALAsset.URL */
- (void)requestImageForALAssetURL:(NSURL *)assetURL imageType:(UPAssetImageType)imageType resultHandler:(UPAssetManagerResultHandler)resultHandler;
/** 获取图片通过ALAsset */
- (void)requestImageForALAsset:(ALAsset *)asset imageType:(UPAssetImageType)imageType resultHandler:(UPAssetManagerResultHandler)resultHandler;

/** 获取视频通过UPAsset */
- (int32_t)requestVideoAVAssetForAsset:(UPAsset *)asset resultHandler:(void (^)(AVAsset *asset, NSDictionary *info))resultHandler;


/** 保存图片至相册 */
- (void)writeImage:(UIImage *)image completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler;
- (void)writeImage:(UIImage *)image metadata:(NSDictionary *)metadata completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler;
- (void)writeImageData:(NSData *)imageData metadata:(NSDictionary *)metadata completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler;

/** 保存视频至相册 */
- (void)writeVideoAtURL:(NSURL *)url completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler;


/** 导出视频通过UPAsset */
- (void)exportVideoForAsset:(UPAsset *)asset outputURL:(NSURL *)outputURL completionHandler:(void(^)(BOOL success))completionHandler;
/** 导出视频通过AVAsset */
- (void)exportVideoForAVAsset:(AVAsset *)avAsset presetName:(NSString *)presetName outputURL:(NSURL *)outputURL maxLength:(NSInteger)maxLength completionHandler:(void(^)(BOOL success))completionHandler;

/** 获取Asset通过LocalIdentifier */
- (void)requestAssetWithLocalIdentifier:(NSString *)localIdentifier completionHandler:(void (^)(UPAsset *asset))completionHandler;
/** 获取Asset通过Asset URL */
- (void)requestAssetWithAssetURL:(NSURL *)assetURL completionHandler:(void (^)(UPAsset *asset))completionHandler;

/** 验证Asset是否存在 */
- (void)checkAssetExist:(UPAsset *)asset completionHandler:(void (^)(BOOL success))completionHandler;

/** 开始图片缓存 */
- (void)startCachingImagesForAssets:(NSArray *)assets imageType:(UPAssetImageType)imageType NS_AVAILABLE_IOS(8_0);
/** 开始缩略图缓存 */
- (void)startCachingThumbnailForAssets:(NSArray *)assets NS_AVAILABLE_IOS(8_0);

/** 停止图片缓存 */
- (void)stopCachingImagesForAssets:(NSArray *)assets imageType:(UPAssetImageType)imageType NS_AVAILABLE_IOS(8_0);
/** 停止缩略图缓存 */
- (void)stopCachingThumbnailForAssets:(NSArray *)assets NS_AVAILABLE_IOS(8_0);
/** 停止所有图片缓存 */
- (void)stopCachingImagesForAllAssets NS_AVAILABLE_IOS(8_0);

/** 获取资源的Metadata */
- (void)requestMetadataWithAsset:(UPAsset *)asset completionHandler:(void (^)(NSDictionary *metadata))completionHandler;

//- (void)fetchAssetLibraryCurrentAssetCollection:(ExecVoidBlock)block;

- (void)clearAsset;

/** 所有相册集 */
@property (nonatomic, strong, readonly) NSArray *assetCollectionArray;
/** 当前相册集 */
@property (nonatomic, strong, readonly) UPAssetCollection *currentAssetCollection;
/** 当前相册集中的所有资源 */
@property (nonatomic, strong, readonly) NSArray *currentAssetArray;

@property (nonatomic, assign) NSUInteger fetchPhotoIndex;

@end

