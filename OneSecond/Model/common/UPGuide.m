//
//  UPGuide.m
//  Up
//
//  Created by amy on 14-3-18.
//  Copyright (c) 2014年 amy. All rights reserved.
//

#import "UPGuide.h"
#import "UPGuideView.h"


static NSString *ShareSecondVideo = @"ShareSecondVideo8";
static NSString *savedDate = @"savedDate8";

static NSString *Afterburned = @"Afterburned";
static NSString *AfterburnedsavedDate = @"AfterburnedsavedDate8";
@implementation UPGuide

+ (BOOL)whetherShowGuideWithType:(UPGuideType)guideType
{
    NSString *guideKey = [self guideKeyWithType:guideType];
    NSString *version = [self localGuideVersionForKey:guideKey];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cacheVersion = [userDefaults stringForKey:guideKey];
    if (guideKey == nil || version == nil || cacheVersion == nil) {
        return NO;
    }
    return [cacheVersion isEqualToString:version];
}

+ (void)showGuideWithType:(UPGuideType)guideType completed:(void(^)(void))block
{
    [self showGuideWithType:guideType force:NO completed:block];
    
}

+ (void)showGuideWithType:(UPGuideType)guideType WithCustomView:(UIView *)view  completed:(void(^)(void))block
{
    
    [self showGuideWithType:guideType WithCustomView:view force:NO completed:block];
    
}

+ (void)showGuideWithType:(UPGuideType)guideType WithCustomView:(UIView *)view force:(BOOL)force completed:(void (^)(void))block
{
    NSString *guideKey = [self guideKeyWithType:guideType];
    NSString *version = [self localGuideVersionForKey:guideKey];
    if (guideKey == nil || version == nil) {
        return;
    }
    
//    force = YES;//强制打开新手引导
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (force || ![[userDefaults stringForKey:guideKey] isEqualToString:version]) {
        [userDefaults setValue:version forKey:guideKey];
        [userDefaults synchronize];
        
//        [self showGuideViewWithType:guideType WithKeyBoardHeight:0];
        [self showguideViewType:guideType WithCustomView:view];
        
        if (block) {
            block();
        }
    }

}

+ (void)showguideViewType:(UPGuideType)guideType WithCustomView:(UIView *)view
{
    switch (guideType) {
            
        case UPGuideTypeSceondVideoPublish:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeSceondVideoPublish;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeReadTextAfterburned:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeReadTextAfterburned;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeExitSecondVideoAndBeginRecord:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeExitSecondVideoAndBeginRecord;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeCreatMoreSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeCreatMoreSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypePreviewAndEditSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.customeView = view;
            guideView.upGuideType = UPGuideTypePreviewAndEditSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeSaveSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeSaveSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeMoveSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeMoveSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeNextLensSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeNextLensSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeShareSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeShareSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypePreviewSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypePreviewSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
            
        default: return;
    }

    
}

+ (void)showGuideWithType:(UPGuideType)guideType force:(BOOL)force completed:(void(^)(void))block
{
    NSString *guideKey = [self guideKeyWithType:guideType];
    NSString *version = [self localGuideVersionForKey:guideKey];
    if (guideKey == nil || version == nil) {
        return;
    }
    
//    force = YES;//强制打开新手引导
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (force || ![[userDefaults stringForKey:guideKey] isEqualToString:version]) {
        [userDefaults setValue:version forKey:guideKey];
        [userDefaults synchronize];
    
        [self showGuideViewWithType:guideType WithKeyBoardHeight:0];
        
        if (block) {
            block();
        }
    }
}

+ (void)showGuideWithType:(UPGuideType)guideType force:(BOOL)force keyBoardHeight:(float)keyBoardHeight completed:(void(^)(void))block
{
    NSString *guideKey = [self guideKeyWithType:guideType];
    NSString *version = [self localGuideVersionForKey:guideKey];
    if (guideKey == nil || version == nil) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (force || ![[userDefaults stringForKey:guideKey] isEqualToString:version]) {
        [userDefaults setValue:version forKey:guideKey];
        [userDefaults synchronize];
    
        [self showGuideViewWithType:guideType WithKeyBoardHeight:keyBoardHeight];
        
        if (block) {
            block();
        }
    }
}

+ (void)showGuideWithType:(UPGuideType)guideType force:(BOOL)force forView:(UIView *)view completed:(void(^)(void))block
{
    NSString *guideKey = [self guideKeyWithType:guideType];
    NSString *version = [self localGuideVersionForKey:guideKey];
    if (guideKey == nil || version == nil) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (force || ![[userDefaults stringForKey:guideKey] isEqualToString:version]) {
        [userDefaults setValue:version forKey:guideKey];
        [userDefaults synchronize];
        
        if (block) {
            block();
        }
    }
}

+ (void)setHaveSeenGuideWithType:(UPGuideType)guideType
{
    NSString *guideKey = [self guideKeyWithType:guideType];
    NSString *version = [self localGuideVersionForKey:guideKey];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:version forKey:guideKey];
    [userDefaults synchronize];

}
+ (NSString *)localGuideVersionForKey:(NSString *)key
{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"userGuide-info" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    return [dic objectForKey:key];
}

+ (NSString *)guideKeyWithType:(UPGuideType)guideType
{
    switch (guideType) {
       
        case UPGuideTypeSceondVideoPublish: return @"UPGuideTypeSceondVideoPublish";
        case UPGuideTypeReadTextAfterburned: return @"UPGuideTypeReadTextAfterburned";
        case UPGuideTypeExitSecondVideoAndBeginRecord: return @"UPGuideTypeExitSecondVideoAndBeginRecord";
        case UPGuideTypeCreatMoreSecondVideo: return @"UPGuideTypeCreatMoreSecondVideo";
        case UPGuideTypePreviewAndEditSecondVideo: return @"UPGuideTypePreviewAndEditSecondVideo";
        case UPGuideTypeSaveSecondVideo: return @"UPGuideTypeSaveSecondVideo";
        case UPGuideTypeMoveSecondVideo: return @"UPGuideTypeMoveSecondVideo";
        case UPGuideTypeNextLensSecondVideo: return @"UPGuideTypeNextLensSecondVideo";
        case UPGuideTypeShareSecondVideo: return @"UPGuideTypeShareSecondVideo";
        case UPGuideTypePreviewSecondVideo: return @"UPGuideTypePreviewSecondVideo";
        default: return nil;
    }
}

+ (void)showGuideViewWithType:(UPGuideType)guideType WithKeyBoardHeight:(CGFloat)keyboardHeight
{

    switch (guideType) {
        
        case UPGuideTypeSceondVideoPublish:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeSceondVideoPublish;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeReadTextAfterburned:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeReadTextAfterburned;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeExitSecondVideoAndBeginRecord:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeExitSecondVideoAndBeginRecord;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeCreatMoreSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeCreatMoreSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypePreviewAndEditSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypePreviewAndEditSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeSaveSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeSaveSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeMoveSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeMoveSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeNextLensSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeNextLensSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypeShareSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypeShareSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
        case UPGuideTypePreviewSecondVideo:{
            UPGuideView *guideView = [[UPGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            guideView.upGuideType = UPGuideTypePreviewSecondVideo;
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        }break;
            
        default: return;
    }
}

@end
