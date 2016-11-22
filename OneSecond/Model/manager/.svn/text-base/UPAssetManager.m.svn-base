//
//  UPAssetManager.m
//  Up
//
//  Created by amy on 14-9-10.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "UPAssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDImageCache.h"
#import "UIImage-Extension.h"
#import "Flurry.h"
#import "UPBusinessDefine.h"
//#import "UpdateCheckObject.h"

@import Photos;

#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread])\
    {\
        block();\
    }\
    else\
    {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

// 忽略2位以上尺寸
#define kScale MIN(([UIScreen mainScreen].scale), 2)

#define kItemWidth ((kScreenWidth) / 4.0)
// 缩略图大小
#define kThumbnailSize (CGSizeMake(kItemWidth * kScale, kItemWidth * kScale))
// 全屏图大小(非高清原图，相当于ALAsset fullScreenImage)
#define kFullScreenSize (CGSizeMake(kScreenWidth * kScale, kScreenHeight * kScale))

#define kUPAssetURLPrefix [NSString stringWithFormat:@"%@://", UPAssetURLScheme]

typedef NSString * (^UPAssetWritePerformChangeBlock) (void);

NSString * const UPPhotoLibraryChangedNotification = @"UPPhotoLibraryChangedNotification";
NSString * const UPAssetURLScheme = @"photos-framework";
NSString * const ALAAssetURLScheme = @"assets-library";

//static NSInteger OnePageMaxCount = 50;

@class UPAssetManager;

@interface UPAsset ()
{
}

@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *thumbnail;

@property (nonatomic, strong) id actualObject;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UPAssetMediaType mediaType;
@property (nonatomic, assign) UPAssetImageType imageType;

+ (UPAsset *)assetWithPHAsset:(PHAsset *)phAsset;
+ (UPAsset *)assetWithALAsset:(ALAsset *)alAsset;
@end


@implementation UPAsset

+ (NSString *)localIdentifierWithURL:(NSURL *)url
{
    NSString *localIdentifier = nil;
    if ([[url.scheme lowercaseString] isEqualToString:ALAAssetURLScheme]) {
        localIdentifier = url.absoluteString;
    }
    else {
        localIdentifier = [url.absoluteString stringByReplacingOccurrencesOfString:kUPAssetURLPrefix withString:@""];
    }
    return localIdentifier;
}

+ (UPAsset *)assetWithPHAsset:(PHAsset *)phAsset
{
    UPAsset *asset = [[UPAsset alloc] init];
    asset.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kUPAssetURLPrefix, phAsset.localIdentifier]];
    asset.localIdentifier = phAsset.localIdentifier;
    asset.actualObject = phAsset;
    asset.mediaType = phAsset.mediaType;
    asset.duration = phAsset.duration;
    asset.location = phAsset.location;
    return asset;
}

+ (UPAsset *)assetWithALAsset:(ALAsset *)alAsset
{
    UPAsset *asset = [[UPAsset alloc] init];
    asset.url = alAsset.defaultRepresentation.url;
    asset.localIdentifier = asset.url.absoluteString;
    asset.actualObject = alAsset;
    asset.mediaType = [UPAssetManager upAssetMediaTypeWithALAsset:alAsset];
    asset.thumbnail = [UIImage imageWithCGImage:alAsset.thumbnail];
    if (asset.mediaType == UPAssetMediaTypeVideo) {
        asset.duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
    }
    asset.location = [alAsset valueForProperty:ALAssetPropertyLocation];
    return asset;
}

- (void)generatePHAssetWithLocalIdentifier
{
    if (self.localIdentifier) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[self.localIdentifier] options:nil];
        if (fetchResult.count > 0) {
            self.actualObject = fetchResult.firstObject;
        }
    }
}

- (UPAsset *)buildNewUpAsset:(UIImage *)image
{
    UPAsset *newAsset = [[UPAsset alloc] init];
    newAsset.actualObject = self.actualObject;
    newAsset.localIdentifier = self.localIdentifier;
    newAsset.url = self.url;
    newAsset.thumbnail = self.thumbnail;
    newAsset.location = self.location;
    newAsset.duration = self.duration;
    newAsset.mediaType = self.mediaType;
    newAsset.imageType = self.imageType;
    newAsset.userImage = image;
    newAsset.userInfo = self.userInfo;
    newAsset.tag = self.tag;

    return newAsset;
}


@end



@interface UPAssetCollection ()

@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *posterImage;

@property (nonatomic, strong) id actualObject;

@property (nonatomic, assign) UPAssetCollectionType type;
@property (nonatomic, assign) UPAssetCollectionSubtype subType;
@property (nonatomic, assign) NSInteger numberOfAssets;
- (BOOL)isAllPhotosOrCameraRoll;
@end

@implementation UPAssetCollection

+ (UPAssetCollection *)assetCollectionWithPHAssetCollection:(PHAssetCollection *)phAssetCollection
{
    UPAssetCollection *upAC = [[UPAssetCollection alloc] init];
    upAC.actualObject = phAssetCollection;
    upAC.localIdentifier = phAssetCollection.localIdentifier;
    upAC.url = nil;
    upAC.title = phAssetCollection.localizedTitle;
    upAC.type = phAssetCollection.assetCollectionType;
    upAC.subType = phAssetCollection.assetCollectionSubtype;
    // 预估数量 实际数量和预览图需要通过PHFetchResult的PHAsset获取
    upAC.numberOfAssets = phAssetCollection.estimatedAssetCount;
    return upAC;
}

+ (UPAssetCollection *)assetCollectionWithALAssetsGroup:(ALAssetsGroup *)group
{
    UPAssetCollection *upAC = [[UPAssetCollection alloc] init];
    upAC.actualObject = group;
    upAC.url = [group valueForProperty:ALAssetsGroupPropertyURL];
    upAC.localIdentifier = upAC.url.absoluteString;
    upAC.title = [group valueForProperty:ALAssetsGroupPropertyName];
    upAC.posterImage = [UIImage imageWithCGImage:group.posterImage];
    upAC.type = UPAssetCollectionTypeAlbum;
    upAC.subType = UPAssetCollectionSubtypeAlbumRegular;
    upAC.numberOfAssets = group.numberOfAssets;
    return upAC;
}

+ (UPAssetCollection *)assetCollectionInAllPhotos
{
    UPAssetCollection *upAC = [[UPAssetCollection alloc] init];
    upAC.localIdentifier = [PublicObject generateNoLineUUID];
    upAC.url = nil;
    upAC.title = UPLocStr(@"All Photos");
    upAC.type = UPAssetCollectionTypeAll;
    upAC.subType = UPAssetCollectionSubtypeAll;
    return upAC;
}

- (BOOL)isAllPhotosOrCameraRoll
{
    return (self.type == UPAssetCollectionTypeAll && self.subType == UPAssetCollectionSubtypeAll) ||
    (self.type == PHAssetCollectionTypeSmartAlbum && self.subType == PHAssetCollectionSubtypeSmartAlbumUserLibrary);
}

@end


@interface UPAssetManager()<PHPhotoLibraryChangeObserver>
{
}
// >= iOS8
@property (nonatomic, strong) PHCachingImageManager *imageManager;
// < iOS8
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
// 用于iOS8之前版本的图片缓存
@property (nonatomic, strong) SDImageCache *oldImageCache;

@property (nonatomic, strong) NSArray *assetCollectionFetchResultArray;
@property (nonatomic, strong) NSMutableArray *mAssetCollectionArray;
@property (nonatomic, strong) NSMutableArray *mCurrentAssetArray;
@property (nonatomic, strong) UPAssetCollection *currentAssetCollection;
@property (nonatomic, strong) PHFetchOptions *assetFetchOptions;


@property (nonatomic, assign) UPAssetMediaType currentMediaType;
@property (nonatomic, assign) BOOL photoLibraryChanged;
@end


@implementation UPAssetManager

+ (NSString *)imageResultIsInCloudKey
{
    if (kIsIOS8) {
        return PHImageResultIsInCloudKey;
    }
    return nil;
}

+ (NSString *)imageResultIsDegradedKey
{
    if (kIsIOS8) {
        return PHImageResultIsDegradedKey;
    }
    return nil;
}

+ (NSString *)imageResultRequestIDKey
{
    if (kIsIOS8) {
        return PHImageResultRequestIDKey;
    }
    return nil;
}

+ (CGSize)imageManagerMaximumSize
{
    if (kIsIOS8) {
        return PHImageManagerMaximumSize;
    }
    return CGSizeMake(-1, -1);
}

+ (UPAssetMediaType)upAssetMediaTypeWithALAsset:(ALAsset *)alAsset
{
    id type = [alAsset valueForProperty:ALAssetPropertyType];
    if ([type isEqualToString:ALAssetTypePhoto]) {
        return UPAssetMediaTypeImage;
    }
    if ([type isEqualToString:ALAssetTypeVideo]) {
        return UPAssetMediaTypeVideo;
    }
    return UPAssetMediaTypeUnknown;
}

+ (NSInteger)authorizationStatus
{
    if (kIsIOS8) {
        return [PHPhotoLibrary authorizationStatus];
    }
    return [ALAssetsLibrary authorizationStatus];
}

+ (BOOL)authorized
{
    if (kIsIOS8) {
        return ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized);
    }
    return ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized);
}

+ (BOOL)unauthorized
{
    NSInteger status = [self authorizationStatus];
    return (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied);
}

+ (BOOL)isAssetURL:(NSURL *)url
{
    NSString *urlScheme = [[url scheme] lowercaseString];
    return [urlScheme isEqualToString:UPAssetURLScheme] || [urlScheme isEqualToString:ALAAssetURLScheme];
}

+ (id)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mAssetCollectionArray = [NSMutableArray array];
        self.mCurrentAssetArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        if (kIsIOS8) {
            self.imageManager = [[PHCachingImageManager alloc] init];
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        }
        else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryChangedNotification:) name:ALAssetsLibraryChangedNotification object:nil];
            self.assetsLibrary = [[ALAssetsLibrary alloc] init];
            self.oldImageCache = [[SDImageCache alloc] initWithNamespace:@"UPAssetManagerOld"];
        }
    }
    return self;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Override Get Method

- (NSArray *)assetCollectionArray
{
    return self.mAssetCollectionArray;
}

- (NSArray *)currentAssetArray
{
    return self.mCurrentAssetArray;
}


#pragma mark - Reload Album Data

- (void)reloadCurrentAssetCollection:(UPAssetCollection *)assetCollection
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (!kIsIOS8) {
        [self reloadAssetLibraryCurrentAssetCollection:assetCollection];
        return;
    }

    self.currentAssetCollection = assetCollection;
    PHFetchResult *assetFetchResult = nil;
    if ([assetCollection isAllPhotosOrCameraRoll]) {
        // 所有照片相册集 取全部的照片
        assetFetchResult = [PHAsset fetchAssetsWithOptions:self.assetFetchOptions];
    }
    else {
        // 其它相册
        assetFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection.actualObject options:self.assetFetchOptions];
    }
    assetCollection.numberOfAssets = assetFetchResult.count;
    
    [self.mCurrentAssetArray removeAllObjects];
    if (assetFetchResult.count > 0) {
        //取相册的预览头图
        if (assetCollection.posterImage == nil) {
            [_imageManager requestImageForAsset:[assetFetchResult firstObject] targetSize:kThumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                assetCollection.posterImage = result;
            }];
        }
        
        //生成当前相册的照片数据
        for (PHAsset *itemAsset in assetFetchResult) {
            UPAsset *photoAsset = [UPAsset assetWithPHAsset:itemAsset];
            if ([self checkAssetCanBeSelected:photoAsset]) {
                [self.mCurrentAssetArray addObject:photoAsset];
            }
        }
//        ExecTimeBlock(^{
//            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:10000];
//            __block int i = 0;
//            while (i < 10000) {
//                [assetFetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [tempArray addObject:[UPAsset assetWithPHAsset:obj]];
//                    i++;
//                }];
////                for (PHAsset *itemAsset in assetFetchResult) {
////                    [tempArray addObject:[UPAsset assetWithPHAsset:itemAsset]];
////                    i++;
////                }
//            }
//        });
    }
}

- (void)reloadDataForMediaType:(UPAssetMediaType)mediaType completionHandler:(void(^)(NSError *error))completionHandler
{
    if ([UPAssetManager unauthorized]) {
        if (completionHandler) {
            completionHandler(nil);
        }
        return;
    }
    if (!kIsIOS8) {
        [self reloadAssetsLibraryForMediaType:mediaType completionHandler:completionHandler];
        return;
    }
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_main_sync_safe(^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self reloadPHPhotoLibraryForMediaType:mediaType completionHandler:completionHandler];
                }
                else {
                    if (completionHandler) {
                        completionHandler(nil);
                    }
                }
            });
        }];
    }
    else {
        [self reloadPHPhotoLibraryForMediaType:mediaType completionHandler:completionHandler];
    }
}

- (void)requestPhotoLibraryPosterImageForMediaType:(UPAssetMediaType)mediaType completionHandler:(void(^)(UIImage *image))completionHandler
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (!completionHandler) {
        return;
    }
    if (kIsIOS8) {
        [self setupAssetFetchOptionsForMediaType:mediaType];
        PHAsset *firstAsset = nil;
        // 所有照片
        PHFetchResult *assetFetchResult = [PHAsset fetchAssetsWithMediaType:mediaType options:self.assetFetchOptions];
        if (assetFetchResult.count > 0) {
            firstAsset = assetFetchResult.firstObject;
        }
        else {
            // 所有照片相册集为空有可能最近删除里有数据
            PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (PHAssetCollection *itemAssetCollection in smartAlbums) {
                PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:itemAssetCollection options:self.assetFetchOptions];
                if (assetFetchResult.count > 0) {
                    firstAsset = assetFetchResult.firstObject;
                    break;
                }
            }
        }
        if (firstAsset) {
            [_imageManager requestImageForAsset:firstAsset targetSize:kThumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                if ([[info objectForKey:PHImageResultIsDegradedKey] integerValue] != 1) {
                    completionHandler(result);
                }
            }];
        }
        else {
            completionHandler(nil);
        }
    }
    else {
        __block NSMutableArray *groupArray = [NSMutableArray array];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                switch(mediaType) {
                    case UPAssetMediaTypeImage: [group setAssetsFilter:[ALAssetsFilter allPhotos]]; break;
                    case UPAssetMediaTypeVideo: [group setAssetsFilter:[ALAssetsFilter allVideos]]; break;
                    default: [group setAssetsFilter:[ALAssetsFilter allAssets]]; break;
                }
                if (group.numberOfAssets > 0) {
                    if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                        [groupArray insertObject:group atIndex:0];
                        *stop = YES;
                    }
                    else {
                        [groupArray addObject:group];
                    }
                }
            }
            else {
                if (groupArray.count > 0) {
                    completionHandler([UIImage imageWithCGImage:((ALAssetsGroup *)groupArray.firstObject).posterImage]);
                }
                else {
                    completionHandler(nil);
                }
            }
        } failureBlock:^(NSError *error) {
            completionHandler(nil);
        }];
    }
}

#pragma mark - Image Request

- (int32_t)requestThumbnailForAsset:(UPAsset *)asset resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    return [self requestImageForAsset:asset
                            imageType:UPAssetImageTypeThumbnail
                        resultHandler:resultHandler];
}

- (int32_t)requestImageForAsset:(UPAsset *)asset imageType:(UPAssetImageType)imageType resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    // ios8 PHImageManager返回的非缩略图方向不正确，需要调整方向
    return [self requestImageForAsset:asset
                            imageType:imageType
                       fixOrientation:imageType > UPAssetImageTypeAspectRatioThumbnail
                        resultHandler:resultHandler];
}

- (int32_t)requestImageForAsset:(UPAsset *)asset imageType:(UPAssetImageType)imageType fixOrientation:(BOOL)fixOrientation resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    if (!resultHandler) {
        return 0;
    }
    asset.imageType = imageType;
    if (kIsIOS8) {
        return [self requestImageForAsset:asset
                               targetSize:[self imageTargetSizeForImageType:imageType phAsset:asset.actualObject]
                              contentMode:[self imageContentModeForImageType:imageType]
                           fixOrientation:fixOrientation
                            resultHandler:resultHandler];
    }
    else {
        if (asset.actualObject) {
            [self requestImageForALAsset:asset.actualObject imageType:imageType resultHandler:resultHandler];
        }
        else if (asset.url) {
            [self requestImageForALAssetURL:asset.url imageType:imageType resultHandler:resultHandler];
        }
        else {
            resultHandler(nil, nil);
        }
        return 0;
    }
}

- (int32_t)requestImageForAsset:(UPAsset *)asset targetSize:(CGSize)targetSize contentMode:(UPImageContentMode)contentMode resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    return [self requestImageForAsset:asset
                           targetSize:targetSize
                          contentMode:contentMode
                       fixOrientation:YES
                        resultHandler:resultHandler];
}

- (int32_t)requestImageForAsset:(UPAsset *)asset targetSize:(CGSize)targetSize contentMode:(UPImageContentMode)contentMode fixOrientation:(BOOL)fixOrientation resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    return [self requestImageForAsset:asset
                           targetSize:targetSize
                          contentMode:contentMode
                       fixOrientation:fixOrientation
                              options:[self requestOptionsWithAsset:asset]
                        resultHandler:resultHandler];
}

- (int32_t)requestImageForAsset:(UPAsset *)asset targetSize:(CGSize)targetSize contentMode:(UPImageContentMode)contentMode fixOrientation:(BOOL)fixOrientation options:(PHImageRequestOptions *)options resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    if ([UPAssetManager unauthorized]) {
        return 0;
    }
    if (!resultHandler || !asset.localIdentifier) {
        return 0;
    }

    if (!asset.actualObject) {
        [asset generatePHAssetWithLocalIdentifier];
    }
    if (asset.actualObject && [asset.actualObject isKindOfClass:[PHAsset class]]) {
        return [_imageManager requestImageForAsset:asset.actualObject
                                        targetSize:targetSize
                                       contentMode:contentMode
                                           options:options
                                     resultHandler:^(UIImage *result, NSDictionary *info)
                {
                    BOOL isDegraded = ([[info objectForKey:PHImageResultIsDegradedKey] intValue] == 1);
                    // 视频忽略低质量图(视频的低质量图带有视频标识水印)
                    if (asset.mediaType == UPAssetMediaTypeVideo) {
                        if (!isDegraded) {
                            dispatch_main_sync_safe(^{
                                resultHandler(result, info);
                            });
                        }
                        return;
                    }
//#warning iOS bug，照片流里的资源获取不到原图需要从iCloud下载，故先用缩略图替代
                    if (!isDegraded && !result && !CGSizeEqualToSize(targetSize, kThumbnailSize)) {
//                        DDLogError(@"*** 获取原图image为空");
                        // 获取缩略图
                        [self requestThumbnailForAsset:asset resultHandler:^(UIImage *image, NSDictionary *info) {
//                            DDLogError(@"*** Thumbnail info:%@", info);
                            resultHandler(image, info);
                        }];
                        // 从网络iCloud下载照片流原图
                        if (!options || !options.networkAccessAllowed) {
                            PHImageRequestOptions *tmpOptions = [[PHImageRequestOptions alloc] init];
                            tmpOptions.networkAccessAllowed = YES;
                            tmpOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                            [self requestImageForAsset:asset targetSize:targetSize contentMode:contentMode fixOrientation:fixOrientation options:tmpOptions resultHandler:^(UIImage *image, NSDictionary *info) {
//                                DDLogError(@"*** iCloud info:%@", info);
                                resultHandler(image, info);
                            }];
                        }
                        return;
                    }
                    
                    // PHImageManager 返回的图片方向不正确需要手动调整
                    if (!isDegraded && fixOrientation) {
                        @autoreleasepool {
                            result = [result fixOrientation];
                        }
                    }
                    dispatch_main_sync_safe(^{
                        resultHandler(result, info);
                    });
                }];
    }
    resultHandler(nil, nil);
    return 0;
}

- (void)cancelImageRequest:(int32_t)requestID
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (requestID > 0) {
        [_imageManager cancelImageRequest:requestID];
    }
}

- (void)requestImageForALAsset:(ALAsset *)asset imageType:(UPAssetImageType)imageType resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    NSString *key = asset.defaultRepresentation.url.absoluteString;
    if (!resultHandler) {
        return;
    }
    if (!key) {
        resultHandler(nil, nil);
        return;
    }
    // key = type + url
    key = [NSString stringWithFormat:@"Asset%d%@", (int)imageType, key];
    
    // 图片缓存中是否存在
    UIImage *cacheImage = [_oldImageCache imageFromMemoryCacheForKey:key];
    if (cacheImage) {
        if (resultHandler) {
            resultHandler(cacheImage, nil);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [self imageForALAsset:asset imageType:imageType];
        dispatch_main_sync_safe(^{
            if (image) {
                [_oldImageCache storeImage:image forKey:key toDisk:NO];
            }
            if (resultHandler) {
                resultHandler(image, nil);
            }
        });
    });
}

- (void)requestImageForALAssetURL:(NSURL *)assetURL imageType:(UPAssetImageType)imageType resultHandler:(UPAssetManagerResultHandler)resultHandler
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (!resultHandler) {
        return;
    }
    __weak UPAssetManager *wSelf = self;
    [_assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        [wSelf requestImageForALAsset:asset imageType:imageType resultHandler:resultHandler];
    } failureBlock:^(NSError *error) {
        resultHandler(nil, nil);
    }];
}


#pragma mark - Video Request

- (int32_t)requestVideoAVAssetForAsset:(UPAsset *)asset resultHandler:(void (^)(AVAsset *asset, NSDictionary *info))resultHandler
{
    if ([UPAssetManager unauthorized]) {
        return 0;
    }
    if (!resultHandler) {
        return 0;
    }
    if (!asset) {
        resultHandler(nil, nil);
    }
    if (kIsIOS8) {
        if (!asset.actualObject) {
            [asset generatePHAssetWithLocalIdentifier];
        }
        return [_imageManager requestAVAssetForVideo:asset.actualObject options:nil resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            dispatch_main_sync_safe(^{
                resultHandler(asset, info);
            });
        }];
    }
    else {
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:asset.url options:nil];
        resultHandler(avAsset, nil);
        return 0;
    }
}


#pragma mark - Write Data

- (void)writeImage:(UIImage *)image completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (!image) {
        if (completionHandler)
            completionHandler(nil, nil);
        return;
    }
    if (kIsIOS8) {
        [self writeDataPerformChange:^NSString *{
            PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            return [request placeholderForCreatedAsset].localIdentifier;
        } completionHandler:completionHandler];
    }
    else {
        [self writeImageWithAssetLibrary:image completionHandler:completionHandler];
    }
}

- (void)writeImage:(UIImage *)image metadata:(NSDictionary *)metadata completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if ([UPAssetManager unauthorized] || !image) {
        if (completionHandler) {
            completionHandler(nil, nil);
        }
        return;
    }
    if (!self.assetsLibrary) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    __weak UPAssetManager *wSelf = self;
    [_assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error.code == ALAssetsLibraryWriteBusyError) {
            [wSelf writeImage:image metadata:metadata completionHandler:completionHandler];
            return;
        }
        if (!completionHandler) {
            return;
        }
        if (error || !assetURL) {
            dispatch_main_sync_safe(^{
//                DDLogError(@"***** writeImage error:%@", error);
                [Flurry logError:@"writeImageError" message:[assetURL absoluteString] error:error];
                if (completionHandler)
                    completionHandler(nil, error);
            });
        }
        else {
            if (kIsIOS8) {
                PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
                id result = nil;
                if (fetchResult.count > 0) {
                    result = [UPAsset assetWithPHAsset:fetchResult.firstObject];
                }
                dispatch_main_sync_safe(^{
                    if (completionHandler)
                        completionHandler(result, nil);
                });
            }
            else {
                [wSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (!asset) {
//                        DDLogError(@"***** writeImage assetForURL is null");
                        [Flurry logError:@"writeImageAssetForURLInexistent" message:[assetURL absoluteString] error:error];
                    }
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler([UPAsset assetWithALAsset:asset], nil);
                    });
                } failureBlock:^(NSError *error) {
                    dispatch_main_sync_safe(^{
                        [Flurry logError:@"writeImageAssetForURLError" message:[assetURL absoluteString] error:error];
                        if (completionHandler)
                            completionHandler(nil, error);
                    });
                }];
            }
        }
    }]; 
}

- (void)writeImageData:(NSData *)imageData metadata:(NSDictionary *)metadata completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if ([UPAssetManager unauthorized] || !imageData) {
        if (completionHandler) {
            completionHandler(nil, nil);
        }
        return;
    }
    if (!self.assetsLibrary) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    __weak UPAssetManager *wSelf = self;
    [_assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error.code == ALAssetsLibraryWriteBusyError) {
            [wSelf writeImageData:imageData metadata:metadata completionHandler:completionHandler];
            return;
        }
        if (completionHandler) {
            if (error) {
//                DDLogError(@"***** writeImage error:%@", error);
                dispatch_main_sync_safe(^{
                    if (completionHandler)
                        completionHandler(nil, error);
                });
            }
            else {
                [wSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler([UPAsset assetWithALAsset:asset], nil);
                    });
                } failureBlock:^(NSError *error) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler(nil, error);
                    });
                }];
            }
        }
    }];
}

- (void)writeVideoAtURL:(NSURL *)url completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (!url) {
        completionHandler(nil, nil);
        return;
    }
    if (kIsIOS8) {
        [self writeDataPerformChange:^NSString *{
            PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            return [request placeholderForCreatedAsset].localIdentifier;
        } completionHandler:completionHandler];
    }
    else {
        [self writeVideoWithAssetLibraryAtURL:url completionHandler:completionHandler];
    }
}


#pragma mark - Export Video

- (void)exportVideoForAsset:(UPAsset *)asset outputURL:(NSURL *)outputURL completionHandler:(void(^)(BOOL success))completionHandler
{
    [self requestVideoAVAssetForAsset:asset resultHandler:^(AVAsset *avAsset, NSDictionary *info) {
        if (avAsset) {
            [self exportVideoForAVAsset:avAsset presetName:AVAssetExportPresetMediumQuality outputURL:outputURL maxLength:60 completionHandler:completionHandler];
        }
        else {
            dispatch_main_sync_safe(^{
                if (completionHandler) {
                    completionHandler(NO);
                }
            });
        }
    }];
}

- (void)exportVideoForAVAsset:(AVAsset *)avAsset presetName:(NSString *)presetName outputURL:(NSURL *)outputURL maxLength:(NSInteger)maxLength completionHandler:(void(^)(BOOL success))completionHandler
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:presetName];
    NSString *outputPath = [outputURL path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    if (maxLength == 0) {
        maxLength = 60;
    }
    session.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(600 * maxLength, 600));
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_main_sync_safe(^{
            if (completionHandler) {
                completionHandler(session.status == AVAssetExportSessionStatusCompleted);
            }
        });
    }];
}

- (void)requestAssetWithLocalIdentifier:(NSString *)localIdentifier completionHandler:(void (^)(UPAsset *asset))completionHandler
{
    if (!completionHandler) {
        return;
    }
    if ([UPAssetManager unauthorized] || localIdentifier.length == 0) {
        completionHandler(nil);
        return;
    }
    if (kIsIOS8) {
//#warning iOS bug, fetchAssetsWithLocalIdentifiers获取不到“照片流”和“最近删除”相册的数据，
        PHFetchResult *assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
        if (assetResult.count > 0) {
            completionHandler([UPAsset assetWithPHAsset:[assetResult firstObject]]);
        }
        else {
            completionHandler(nil);
        }
    }
    else {
        [_assetsLibrary assetForURL:[NSURL URLWithString:localIdentifier] resultBlock:^(ALAsset *alAsset) {
            completionHandler([UPAsset assetWithALAsset:alAsset]);
        } failureBlock:^(NSError *error) {
            completionHandler(nil);
        }];
    }
}

- (void)requestAssetWithAssetURL:(NSURL *)assetURL completionHandler:(void (^)(UPAsset *asset))completionHandler
{
    NSString *localIdentifier = [UPAsset localIdentifierWithURL:assetURL];
    [self requestAssetWithLocalIdentifier:localIdentifier completionHandler:completionHandler];
}

#pragma mark - Check Asset

- (void)checkAssetExist:(UPAsset *)asset completionHandler:(void (^)(BOOL success))completionHandler
{
    [self requestAssetWithLocalIdentifier:asset.localIdentifier completionHandler:^(UPAsset *asset) {
        completionHandler(asset != nil);
    }];
}

#pragma mark - Image Cache

- (void)startCachingThumbnailForAssets:(NSArray *)assets
{
    [self startCachingImagesForAssets:assets imageType:UPAssetImageTypeThumbnail];
}

- (void)startCachingImagesForAssets:(NSArray *)assets imageType:(UPAssetImageType)imageType
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    NSArray *assetArray = [self phAssetsForUPAssets:assets];
    if (assetArray) {
        [self.imageManager startCachingImagesForAssets:assetArray
                                            targetSize:[self imageTargetSizeForImageType:imageType]
                                           contentMode:[self imageContentModeForImageType:imageType]
                                               options:nil];
    }
}

- (void)stopCachingThumbnailForAssets:(NSArray *)assets
{
    [self stopCachingImagesForAssets:assets imageType:UPAssetImageTypeThumbnail];
}

- (void)stopCachingImagesForAssets:(NSArray *)assets imageType:(UPAssetImageType)imageType
{
    if ([UPAssetManager authorized]) {
        NSArray *assetArray = [self phAssetsForUPAssets:assets];
        if (assetArray) {
            [self.imageManager stopCachingImagesForAssets:assetArray
                                               targetSize:[self imageTargetSizeForImageType:imageType]
                                              contentMode:[self imageContentModeForImageType:imageType]
                                                  options:nil];
        }
    }
}

- (void)stopCachingImagesForAllAssets
{
    if ([UPAssetManager authorized]) {
        [self.imageManager stopCachingImagesForAllAssets];
    }
}


#pragma mark - Private Reload Album Data

- (void)reloadPHPhotoLibraryForMediaType:(UPAssetMediaType)mediaType completionHandler:(void(^)(NSError *error))completionHandler
{
    self.currentMediaType = mediaType;
    [self setupAssetFetchOptionsForMediaType:mediaType];
    [self.mCurrentAssetArray removeAllObjects];
    self.currentAssetCollection = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //生成资源集合(相册)
        @synchronized(self.mAssetCollectionArray){
            [self.mAssetCollectionArray removeAllObjects];
        }
        
        self.assetCollectionFetchResultArray = [self UPFetchResultsOfAssetCollection];
        for (PHFetchResult *itemAssetCollectionFetchResult in self.assetCollectionFetchResultArray) {
            for (PHAssetCollection *itemAssetCollection in itemAssetCollectionFetchResult) {
                PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:itemAssetCollection options:self.assetFetchOptions];
                // “视频”相册与“所有照片”相册中的视频数据重复故忽略掉
                if (itemAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) {
                    continue;
                }
                
                // 保留“相机胶卷”，如果没有“相机胶卷”(<8.1)时创建“所有照片”
//                // iOS8.1“相机胶卷”和“我的照片流”相册回归了，与“所有照片”相册中的数据重复并且“相机胶卷”数据小于“所有照片”故忽略掉
//                if (itemAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
//                    continue;
//                }
                // 去掉最近删除资源集，最近删除=1000000201
                if (itemAssetCollection.assetCollectionType == PHAssetCollectionTypeSmartAlbum &&
                    itemAssetCollection.assetCollectionSubtype > 10000) {
                    continue;
                }
                
                if (assetFetchResult.count > 0) {
                    // 创建相册
                    UPAssetCollection *upAC = [UPAssetCollection assetCollectionWithPHAssetCollection:itemAssetCollection];
                    upAC.numberOfAssets = assetFetchResult.count;
                    // 取相册的预览头图
                    [_imageManager requestImageForAsset:[assetFetchResult firstObject] targetSize:kThumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                        upAC.posterImage = result;
                    }];
                    // 将“最近添加”相册置顶
                    if (upAC.subType == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                        @synchronized(self.mAssetCollectionArray){
                            [self.mAssetCollectionArray insertObject:upAC atIndex:0];
                        }
                    }
                    else {
                        @synchronized(self.mAssetCollectionArray){
                            [self.mAssetCollectionArray addObject:upAC];
                        }
                    }
                }
            }
        }
        @synchronized(self){
            BOOL hasCameraRoll = NO;
            // 是否包括“相册胶卷”并将其置顶
            for (NSUInteger i = 0; i < self.mAssetCollectionArray.count; i++) {
                UPAssetCollection *itemAC = self.mAssetCollectionArray[i];
                if ([itemAC subType] == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    hasCameraRoll = YES;
                    [self.mAssetCollectionArray removeObject:itemAC];
                    [self.mAssetCollectionArray insertObject:itemAC atIndex:0];
                    break;
                }
            }

            if (!hasCameraRoll) {
                // 没有“相册胶卷”时创建“所有照片”相册集并置顶
                [self createAllPhotoAssetCollection];
            }

            // 加载默认相册集照片
            [self reloadCurrentAssetCollection:self.mAssetCollectionArray.firstObject];
        }
        dispatch_main_sync_safe(^{
            if (completionHandler)
                completionHandler(nil);
        });
    });

}

- (void)reloadAssetsLibraryForMediaType:(UPAssetMediaType)mediaType completionHandler:(void(^)(NSError *error))completionHandler
{
    self.currentAssetCollection = nil;
    self.currentMediaType = mediaType;
    [self.mAssetCollectionArray removeAllObjects];
    [self.mCurrentAssetArray removeAllObjects];
//    static NSInteger loadCount = 0;
    __weak UPAssetManager *wSelf = self;
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            switch(mediaType) {
                case UPAssetMediaTypeImage: [group setAssetsFilter:[ALAssetsFilter allPhotos]]; break;
                case UPAssetMediaTypeVideo: [group setAssetsFilter:[ALAssetsFilter allVideos]]; break;
                default: [group setAssetsFilter:[ALAssetsFilter allAssets]]; break;
            }
            
            if (group.numberOfAssets > 0) {
//                loadCount ++;
                UPAssetCollection *assetCollection = [UPAssetCollection assetCollectionWithALAssetsGroup:group];
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                    wSelf.currentAssetCollection = assetCollection;
                }
                else {
                    @synchronized(wSelf.mAssetCollectionArray) {
                        [wSelf.mAssetCollectionArray addObject:assetCollection];
                    }
                }
            }
        }
        //为空时说明遍历结束
        else {
            //相机胶卷是否存在
            if (wSelf.currentAssetCollection) {
                //相机胶卷置顶
                @synchronized(wSelf.mAssetCollectionArray) {
                    [wSelf.mAssetCollectionArray insertObject:wSelf.currentAssetCollection atIndex:0];
                }
            }
            else {
                if (wSelf.mAssetCollectionArray.count > 0) {
                    wSelf.currentAssetCollection = [wSelf.mAssetCollectionArray firstObject];
                }
            }
            //加载默认相册集照片
            [wSelf reloadCurrentAssetCollection:wSelf.currentAssetCollection];
            if (completionHandler)
                completionHandler(nil);
        }
    } failureBlock:^(NSError *error) {
        if (completionHandler)
            completionHandler(error);
    }];
}

- (void)reloadAssetLibraryCurrentAssetCollection:(UPAssetCollection *)assetCollection
{
    if ([UPAssetManager unauthorized]) {
        return;
    }
    if (![assetCollection.actualObject isKindOfClass:[ALAssetsGroup class]]) {
        return;
    }
    self.currentAssetCollection = assetCollection;
    [self.mCurrentAssetArray removeAllObjects];
    ALAssetsGroup *group = self.currentAssetCollection.actualObject;
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            UPAsset *photoAsset = [UPAsset assetWithALAsset:result];
//            if ([self checkAssetCanBeSelected:photoAsset]) {
                [self.mCurrentAssetArray addObject:photoAsset];
//            }
        }
    }];
}

- (BOOL)checkAssetCanBeSelected:(UPAsset *)asset
{
    BOOL isCan = YES;
    CGFloat maxImgRatio = 10;//[[UpdateCheckObject sharedCheckObject] waterfallLongMaxRatio];
    CGFloat maxImgHeight = 10;//[[UpdateCheckObject sharedCheckObject] publishImgMaxHeight];
    if ([asset.actualObject isKindOfClass:[ALAsset class]]) {
        //        UIImage *tempImg = [UIImage imageWithCGImage:originalItem.aspectRatioThumbnail];
        ALAsset *originalItem = (ALAsset *)asset.actualObject;
        CGFloat thumbnailImgWidth = CGImageGetWidth(originalItem.aspectRatioThumbnail);
        CGFloat thumbnailImgHeight = CGImageGetHeight(originalItem.aspectRatioThumbnail);
        if ((thumbnailImgWidth / thumbnailImgHeight) > maxImgRatio ||
            (thumbnailImgHeight / thumbnailImgWidth) > maxImgRatio) {
            isCan = NO;
        }
        //        else if (thumbnailImgWidth >= maxImgHeight || thumbnailImgHeight >= maxImgHeight) {
        //            isCan = NO;
        //        }
    }
    else if ([asset.actualObject isKindOfClass:[PHObject class]]) {
        PHAsset *originalItem = (PHAsset *)asset.actualObject;
        CGFloat origiImgWidth = originalItem.pixelWidth;
        CGFloat origiImgHeight = originalItem.pixelHeight;
        if ((origiImgWidth / origiImgHeight) > maxImgRatio ||
            (origiImgHeight / origiImgWidth) > maxImgRatio) {
            isCan = NO;
        }
        else if (origiImgWidth >= maxImgHeight || origiImgHeight >= maxImgHeight) {
            isCan = NO;
        }
    }
    return isCan;
}


/*
- (void)reloadAssetLibraryCurrentAssetCollection:(UPAssetCollection *)assetCollection
{
    if (![assetCollection.actualObject isKindOfClass:[ALAssetsGroup class]]) {
        return;
    }
    self.currentAssetCollection = assetCollection;
    [self.mCurrentAssetArray removeAllObjects];
    [self fetchAssetLibraryCurrentAssetCollection:NULL];
}

- (void)fetchAssetLibraryCurrentAssetCollection:(ExecVoidBlock)block
{
    if ([UPAssetManager unauthorized]) {
        if (block) {
            block();
        }
        return;
    }
    
//#warning modify by zhangyx
//    NSInteger pageCount = OnePageMaxCount;
    ALAssetsGroup *group = self.currentAssetCollection.actualObject;
//    if (self.fetchPhotoIndex == NSNotFound || self.fetchPhotoIndex <= 0 || self.fetchPhotoIndex > group.numberOfAssets) {
//        self.fetchPhotoIndex = group.numberOfAssets-OnePageMaxCount;
//    }
//    else {
//        if (self.fetchPhotoIndex >= OnePageMaxCount) {
//            self.fetchPhotoIndex = self.fetchPhotoIndex-OnePageMaxCount;
//        }
//        else {
//            pageCount = self.fetchPhotoIndex;
//            self.fetchPhotoIndex = 0;
//        }
//    }
//    __block NSInteger fetchCount = 0;
//    NSIndexSet *fetchRange = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.fetchPhotoIndex, pageCount)];
//    [group enumerateAssetsAtIndexes:fetchRange options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//        fetchCount ++;
//        if (result) {
////            NSLog(@"index = %lu",(unsigned long)index);
//            self.fetchPhotoIndex = index;
//            [self.mCurrentAssetArray addObject:[UPAsset assetWithALAsset:result]];
//        }
//        if (fetchCount == pageCount) {
//            if (block) {
//                block ();
//            }
//        }
//    }];
}
*/

#pragma mark - Private Write

- (void)writeDataPerformChange:(UPAssetWritePerformChangeBlock)changeBlock completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if (!changeBlock) {
        if (completionHandler)
            completionHandler(nil, nil);
        return;
    }
    __block NSString *localIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        localIdentifier = changeBlock();
    } completionHandler:^(BOOL success, NSError *error) {
        if (completionHandler) {
            if (success) {
                PHFetchResult *fetch = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
                if (fetch.count > 0) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler([UPAsset assetWithPHAsset:[fetch firstObject]], nil);
                    });
                    return;
                }
            }
            dispatch_main_sync_safe(^{
                if (completionHandler)
                    completionHandler(nil, error);
            });
        }
    }];
}

- (void)writeImageWithAssetLibrary:(UIImage *)image completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if ([UPAssetManager unauthorized]) {
        if (completionHandler) {
            completionHandler(nil, nil);
        }
        return;
    }
    __weak UPAssetManager *wSelf = self;
    [_assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error.code == ALAssetsLibraryWriteBusyError) {
            [wSelf writeImageWithAssetLibrary:image completionHandler:completionHandler];
            return;
        }
        if (completionHandler) {
            if (error) {
                dispatch_main_sync_safe(^{
                    if (completionHandler)
                        completionHandler(nil, error);
                });
            }
            else {
                [wSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler([UPAsset assetWithALAsset:asset], nil);
                    });
                } failureBlock:^(NSError *error) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler(nil, error);
                    });
                }];
            }
        }
    }];
}

- (void)writeVideoWithAssetLibraryAtURL:(NSURL *)url completionHandler:(UPAssetManagerWriteCompletionHandler)completionHandler
{
    if ([UPAssetManager unauthorized]) {
        if (completionHandler) {
            completionHandler(nil, nil);
        }
        return;
    }
    __weak UPAssetManager *wSelf = self;
    [_assetsLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error.code == ALAssetsLibraryWriteBusyError) {
            [wSelf writeVideoWithAssetLibraryAtURL:url completionHandler:completionHandler];
            return;
        }
        if (completionHandler) {
            if (error) {
                dispatch_main_sync_safe(^{
                    if (completionHandler)
                        completionHandler(nil, error);
                });
            }
            else {
                [wSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler([UPAsset assetWithALAsset:asset], nil);
                    });
                } failureBlock:^(NSError *error) {
                    dispatch_main_sync_safe(^{
                        if (completionHandler)
                            completionHandler(nil, error);
                    });
                }];
            }
        }
    }];
}


#pragma mark - Notification

- (void)appWillEnterForeground:(NSNotification *)notification
{
    [self performSelector:@selector(doPhotoLibraryChanged) withObject:nil afterDelay:0.2];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    self.photoLibraryChanged = YES;
}

- (void)assetsLibraryChangedNotification:(NSNotification *)notification
{
    self.photoLibraryChanged = YES;
}

- (void)doPhotoLibraryChanged
{
    if (self.photoLibraryChanged) {
        dispatch_main_sync_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:UPPhotoLibraryChangedNotification object:nil];
        });
        self.photoLibraryChanged = NO;
    }
}

#pragma mark - Private

- (PHImageRequestOptions *)requestOptionsWithAsset:(UPAsset *)asset
{
    PHImageRequestOptions *options = nil;
    // 不加resizeMode选项默认获取的FullScreen图片太大，故需要设置resizeMode参数
    if (asset.imageType == UPAssetImageTypeLowFullScreen) {
        options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
//    else if (asset.imageType == UPAssetImageTypeThumbnail ||
//             asset.imageType == UPAssetImageTypeAspectRatioThumbnail) {
//        options = [[PHImageRequestOptions alloc] init];
//        options.resizeMode = PHImageRequestOptionsResizeModeFast;
//        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//    }
    return options;
}

- (UIImage *)imageForALAsset:(ALAsset *)asset imageType:(UPAssetImageType)imageType
{
    UIImage *image = nil;
    ALAssetRepresentation *rep = asset.defaultRepresentation;
    switch (imageType) {
        case UPAssetImageTypeThumbnail:
            image = [UIImage imageWithCGImage:asset.thumbnail];
            break;
        case UPAssetImageTypeAspectRatioThumbnail:
            image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
            break;
        case UPAssetImageTypeLowFullScreen:
            image = [self imageForALAsset:asset imageType:UPAssetImageTypeFullScreenEx];
            break;
        case UPAssetImageTypeFullScreen:
            image = [UIImage imageWithCGImage:rep.fullScreenImage];
            break;
        case UPAssetImageTypeFullScreenEx:{
            // 超长图取原始高清图
//            if ([BizCommon imageSizeIsLong:rep.dimensions]) {
//                return [self imageForALAsset:asset imageType:UPAssetImageTypeOriginalAdjustment];
//            }
//            else {
                image = [self imageForALAsset:asset imageType:UPAssetImageTypeFullScreen];
//            }
        }
            break;
        case UPAssetImageTypeOriginal:
            image = [UIImage imageWithCGImage:rep.fullResolutionImage];
            break;
        case UPAssetImageTypeOriginalAdjustment: {
            CGImageRef imageRef = CGImageRetain(rep.fullResolutionImage);
            NSString *adjustment = [rep.metadata objectForKey:@"AdjustmentXMP"];
            if (adjustment) {
                NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
                CIImage *image = [CIImage imageWithCGImage:imageRef];
                
                NSError *error = nil;
                NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                             inputImageExtent:image.extent
                                                                        error:&error];
                CIContext *context = [CIContext contextWithOptions:nil];
                if (filterArray && !error) {
                    for (CIFilter *filter in filterArray) {
                        [filter setValue:image forKey:kCIInputImageKey];
                        image = [filter outputImage];
                    }
                    CGImageRelease(imageRef);
                    imageRef = [context createCGImage:image fromRect:[image extent]];
                }
            }
            image = [UIImage imageWithCGImage:imageRef
                                        scale:rep.scale
                                  orientation:(UIImageOrientation)rep.orientation];
            CGImageRelease(imageRef);
            //纠正方向
            image = [image fixOrientation];
        }
            break;
        default: // UPAssetImageTypeOriginalAdjustmentEx
            // 超大图取适配屏幕的全屏图
            if ([BizCommon imageSizeIsBig:rep.dimensions]) {
                image = [self imageForALAsset:asset imageType:UPAssetImageTypeFullScreen];
            }
            else {
                image = [self imageForALAsset:asset imageType:UPAssetImageTypeOriginalAdjustment];
            }
            break;
    }
    if (image == nil && asset.aspectRatioThumbnail) {
        image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    }
    return image;
}

//- (CGSize)aspectRatioThumbnailSize:(PHAsset *)phAsset
//{
//    if (phAsset.pixelHeight <= 0 || phAsset.pixelWidth <= 0) {
//        return CGSizeMake(kItemWidth, kItemWidth);
//    }
//    CGFloat aspectRatio = (CGFloat)phAsset.pixelWidth / phAsset.pixelHeight;
//    CGFloat targetWidth,targetHeight;
//    if (phAsset.pixelWidth > phAsset.pixelHeight &&
//        phAsset.pixelWidth > kItemWidth) {
//        targetWidth = kItemWidth;
//        targetHeight = targetWidth / aspectRatio;
//    }
//    else if ((phAsset.pixelHeight > phAsset.pixelWidth) &&
//             (phAsset.pixelHeight > kItemWidth)) {
//        targetHeight = kItemWidth;
//        targetWidth = targetHeight * aspectRatio;
//    }
//    else {
//        targetWidth = phAsset.pixelWidth;
//        targetHeight = phAsset.pixelHeight;
//    }
//    return CGSizeMake(targetWidth, targetHeight);
//}

- (CGSize)imageTargetSizeForImageType:(UPAssetImageType)imageType phAsset:(PHAsset *)phAsset
{
    switch (imageType) {
        case UPAssetImageTypeThumbnail: return kThumbnailSize;
        case UPAssetImageTypeAspectRatioThumbnail: return kThumbnailSize;//[self aspectRatioThumbnailSize:phAsset];
        case UPAssetImageTypeLowFullScreen: {
            // 超长图取原始高清图
//            if (phAsset && [BizCommon imageSizeIsLong:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight)]) {
//                return PHImageManagerMaximumSize;
//            }
            return CGSizeMake(kFullScreenSize.width * 2, kFullScreenSize.height * 2);
        }
        case UPAssetImageTypeFullScreen: return kFullScreenSize;
        case UPAssetImageTypeFullScreenEx: {
            // 超长图取原始高清图
//            if (phAsset && [BizCommon imageSizeIsLong:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight)]) {
//                return PHImageManagerMaximumSize;
//            }
            return [self imageTargetSizeForImageType:UPAssetImageTypeFullScreen phAsset:phAsset];
        }
        default: {
            // 超大图取适配屏幕的全屏图
            if (imageType == UPAssetImageTypeOriginalAdjustmentEx && phAsset &&
                [BizCommon imageSizeIsBig:CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight)]) {
                return [self imageTargetSizeForImageType:UPAssetImageTypeFullScreen phAsset:phAsset];
            }
            return PHImageManagerMaximumSize;
        }
            break;
    }
}

- (CGSize)imageTargetSizeForImageType:(UPAssetImageType)imageType
{
    return [self imageTargetSizeForImageType:imageType phAsset:nil];
}

- (UPImageContentMode)imageContentModeForImageType:(UPAssetImageType)imageType
{
    if (imageType == UPAssetImageTypeThumbnail) {
        return UPImageContentModeAspectFill;
    }
    return UPImageContentModeAspectFit;
}

- (NSArray *)phAssetsForUPAssets:(NSArray *)upAssets
{
    if (upAssets.count == 0) {
        return nil;
    }
    NSMutableArray *assetArray = [NSMutableArray arrayWithCapacity:upAssets.count];
    for (UPAsset *itemAsset in upAssets) {
        if (itemAsset.actualObject && [itemAsset.actualObject isKindOfClass:[PHAsset class]]) {
            [assetArray addObject:itemAsset.actualObject];
        }
    }
    return assetArray;
}

- (void)createAllPhotoAssetCollection
{
    // 创建“所有照片”相册集 “所有照片”相册集有可能为空，但“最近删除”相册集有可能不为空
    // fetchAssetsWithOptions用来获取系统所有照片和视频资源但不包括“最近删除”中的数据
    PHFetchResult *allAssetResult = [PHAsset fetchAssetsWithOptions:self.assetFetchOptions];
    if (allAssetResult.count > 0) {
        UPAssetCollection *upAC = [UPAssetCollection assetCollectionInAllPhotos];
        @synchronized(self.mAssetCollectionArray){
            [self.mAssetCollectionArray insertObject:upAC atIndex:0];
        }
    }
}

- (NSArray *)UPFetchResultsOfAssetCollection
{
    NSMutableArray *albumArray = [NSMutableArray array];
    // 系统生成的相册集
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 用户自定义相册集
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    if (smartAlbums) {
        [albumArray addObject:smartAlbums];
    }
    if (userAlbums) {
        [albumArray addObject:userAlbums];
    }
    return albumArray;
}

- (void)setupAssetFetchOptionsForMediaType:(UPAssetMediaType)mediaType
{
    if (self.assetFetchOptions == nil) {
        self.assetFetchOptions = [[PHFetchOptions alloc] init];
        self.assetFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    }
    if (mediaType > UPAssetMediaTypeAny) {
        self.assetFetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", mediaType];
    }
}


- (void)requestMetadataWithAsset:(UPAsset *)asset completionHandler:(void (^)(NSDictionary *metadata))completionHandler
{
    if (!completionHandler) {
        return;
    }
    if (kIsIOS8) {
        PHContentEditingInputRequestOptions *editOptions = [[PHContentEditingInputRequestOptions alloc]init];
        editOptions.networkAccessAllowed = YES;
        [asset.actualObject requestContentEditingInputWithOptions:editOptions completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
            CIImage *image = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
            dispatch_main_sync_safe(^{
                completionHandler(image.properties);
            });
        }];
    }
    else {
        completionHandler([asset.actualObject defaultRepresentation].metadata);
    }
}


- (void)clearAsset
{
    self.fetchPhotoIndex = NSNotFound;
    if (self.oldImageCache) {
        [self.oldImageCache clearMemory];
        [self.oldImageCache clearDisk];
    }
    self.currentAssetCollection = nil;
    [self.mCurrentAssetArray removeAllObjects];
    [self.mAssetCollectionArray removeAllObjects];
}

@end
