//
//  PublicObject.h
//  刷新
//
//  Created by uper on 16/1/29.
//  Copyright © 2016年 uper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>
#import "NSDate-Utilities.h"
#import <UIKit/UIKit.h>

#import "PXAlertView+Customization.h"

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]



@interface PublicObject : NSObject

+ (NSString *)upAppChannelId;

+ (NSString *)upAK;

//获取当前版本号
+ (NSString *)getLocalVerson;
//是否越狱
+ (BOOL)isJailbroken;
+ (NSString *)platformType;

+ (NSMutableDictionary *)upCommonParameters;

//格式化接口参数: parameters为参数字典，secondKey为第二参数名称
+ (NSDictionary *)formatParameters:(NSDictionary *)parameters secondKey:(NSString *)secondKey;

+ (NSDictionary *)formatParameters:(NSDictionary *)parameters firstKey:(NSString *)firstKey secondKey:(NSString *)secondKey;

//MD5加密算法
+ (NSString *)MD5ForString:(NSString *)str;
+ (NSString *)upDecryptWithText:(NSString *)text;
+ (NSString *)upEncryptWithText:(NSString *)text;
+ (NSString *)upEncryptWithText:(NSString *)text key:(NSString *)key;
+ (NSString *)upDecryptWithText:(NSString *)text key:(NSString *)key;

//将文本转换为base64格式字符串
+ (NSString *)base64StringFromText:(NSString *)text;
//将base64格式字符串转换为文本
+ (NSString *)textFromBase64String:(NSString *)base64;

//判断邮箱地址格式是否正确
+ (BOOL)isValidateEmail:(NSString *)email;
//判断昵称是否有效
+ (BOOL)isValidNickName:(NSString *)nickName;
+ (BOOL)isValidateNumberForString:(NSString *)string;

////检测网络是否可用
+ (BOOL)networkIsReachable;
////检测网络是否可用 是否显示提示框
+ (BOOL)networkIsReachableForShowAlert:(BOOL)showAlert;
// 计算中英文混编字符串长度
+ (NSInteger)convertToInt:(NSString*)strtemp;
//是否为空字符
+ (BOOL)isBlankString:(NSString *)string;
+ (CGSize)sizeForString:(NSString *)strValue font:(UIFont *)font;
+ (CGSize)sizeForString:(NSString *)strValue font:(UIFont *)font withMaxWidth:(CGFloat)maxWidth;
+ (CGSize)sizeForString:(NSString *)strValue font:(UIFont *)font model:(NSLineBreakMode)model;
//计算字符串长度
+ (CGFloat)widthForString:(NSString *)strValue font:(UIFont *)font;
+ (CGFloat)widthForString:(NSString *)strValue font:(UIFont *)font model:(NSLineBreakMode)model;
+ (CGFloat)heightForString:(NSString *)strValue font:(UIFont *)font andWidth:(CGFloat)width;
+ (CGFloat)heightForString:(NSString *)strValue font:(UIFont *)font andWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (CGFloat)heightWithFont:(UIFont *)font;
+ (CGFloat)textWidthForUILabel:(UILabel *)label;
+ (NSString *)subString:(NSString *)string withLocation:(NSUInteger)location length:(NSUInteger)length;

+ (void)setButton:(UIButton *)button
   textAttributes:(NSDictionary *)textAttributes
     controlState:(UIControlState)controlState;


// 设置font参数
+(UIFont *)fontWithSize:(float)fontSize fontName:(NSString *)fontName isBold:(BOOL)isBold;

+ (UIImage *)fixOrientationForImage:(UIImage *)image;

+ (CGSize )sizeWithImage:(UIImage *)image adjustToSize:(CGSize)contentSize;

//判断手机型号
+ (BOOL)isiPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isiPhone6plus;
+ (NSString *)systemDocumentPath;
+ (NSString *)systemCachesPath;
+ (NSString *)generateUUID;
+ (NSString *)generateNoLineUUID;
// 判断字符串是否为空
+(BOOL) isEmpty:(NSString *)str;

+ (UILabel *)barTitleLabel:(NSString *)title;
// 获取当前日期
+ (NSString *)getCurrentDate;
//+ (NSString *)getCurrentDateWithAanosecond;
+ (NSString *)getCurrentDay;
+ (NSString *)getCurrentWeekDay:(BOOL)isEnglish;
//是否是中国
+ (BOOL)isChinaRegion;

+ (NSString *)getCurrentCountryCode;

+(BOOL)isRetina;

+ (NSString *)getCurrentLanguage;

+ (BOOL)isChaneseLanguage;

+ (void)removeNavigationBarShadowImage:(UINavigationController *)nc;


+ (UINavigationController *)ncForVC:(UIViewController *)vc;
+ (UINavigationController *)blackNcForVC:(UIViewController *)vc;
+ (UINavigationController *)sliderBackNCForVC:(UIViewController *)vc;

//显示提示对话框
+ (void)showAlertViewForMessage:(NSString *)aMessage;
+ (void)showAlertViewForTitle:(NSString *)title message:(NSString *)message;

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelTitle:(NSString *)cancelTitle
                    otherTitle:(NSString *)otherTitle
                    completion:(PXAlertViewCompletionBlock)completion;

+ (void)showAlertViewWithMessage:(NSString *)message completion:(PXAlertViewCompletionBlock)completion;
/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     需要转化的数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(NSDecimalNumber *)price afterPoint:(NSInteger)position;
//连续动画
+ (void)ActionWithImageName:(NSString *)imageName imageCount:(NSInteger)imageCount praiseImage:(UIImageView *)praiseImage duration:(NSTimeInterval)duration;
//判断字符串是否为纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;
//检验是否为手机号
+ (BOOL) isMobile:(NSString *)mobileNumbel;
//日期格式转换
+ (NSString *)getShowDateWithTime:(NSString *)time;
//根据生日计算星座
+ (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;

+ (BOOL)isNeedLongTransitionTime;
//获取视频截图根据url
+ (UIImage *)videoThumbnailForLastFrame:(BOOL)lastFrame withVideoUrl:(NSString *)videoUrl;
+ (NSDictionary *)splitQuery:(NSString *)query;
+ (NSString *)getUperAppRateURL;
+ (void)convertVideoQualityWithInputURL:(NSURL *)inputURL outputURL:(NSURL *)outputURL completedBlock:(void(^)(BOOL isSuccess, NSString *errorString))completedBlock;//视频压缩
@end

CG_INLINE UIColor *ColorForRGB(CGFloat r, CGFloat g, CGFloat b, CGFloat alpha)
{
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

CG_INLINE NSString *VideoURL10s(NSString *videoURL)
{
    return [NSString stringWithFormat:@"%@_10s.mp4", videoURL];
}

CG_INLINE NSString *BizDateString(NSString *dateStr)
{
    NSDate *date = [NSDate dateFromString:dateStr];
    NSDate *today = [NSDate date];
    //日期相等 忽略时间
    
    if ([date isEqualToDateIgnoringTime:today]) {
        return [date stringWithFormat:@"今天 HH:mm"];
    }
    else {
        //年相待
        if ([date isSameYearAsDate:today]) {
            return [date stringWithFormat:@"MM-dd HH:mm"];
        }
        else {
            return [date stringWithFormat:[NSDate dateFormatString]];
        }
    }
}
