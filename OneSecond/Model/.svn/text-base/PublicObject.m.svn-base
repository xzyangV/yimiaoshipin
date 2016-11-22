//
//  PublicObject.m
//  刷新
//
//  Created by uper on 16/1/29.
//  Copyright © 2016年 uper. All rights reserved.
//

#import "PublicObject.h"
#import "ConfigureObject.h"
#import <CommonCrypto/CommonCryptor.h>
#import "SlideBackNavigationController.h"
#import "Reachability.h"
#import "NSData+AES256.h"
#import "Base64.h"
#import "UIImage-Extension.h"
#import "PushManager.h"
#include <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>

#include <sys/sysctl.h>
typedef uint32_t CC_LONG;       /* 32 bit unsigned integer */
typedef uint64_t CC_LONG64;     /* 64 bit unsigned integer */
#define kDefaultFirstKey @"user_id"

/*** MD5 ***/

#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES      64          /* block size in bytes */
#define CC_MD5_BLOCK_LONG       (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))

//空字符串
#define     LocalStr_None           @""
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
@implementation PublicObject



static NSString * const kUPAESKey = @"p6QNQAVe6twsUbFu";

+ (NSString *)upAppChannelId
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kChannelStatistic ofType:@"plist"];
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *key = [[dataDict allKeys] firstObject];
    NSString *channelID = [dataDict objectForKey:key];//@"ChannelId"
    if ([PublicObject isEmpty:channelID]) {
        channelID = @"appStore";
    }
    return channelID;
}

+ (NSString *)upAK
{
    NSString *key = [PublicObject MD5ForString:kUPAESKey];
    return [key substringWithRange:NSMakeRange(3, key.length - 7)];
}

+ (NSDictionary *)formatParameters:(NSDictionary *)parameters secondKey:(NSString *)secondKey
{
    return [self formatParameters:parameters firstKey:kDefaultFirstKey secondKey:secondKey];
}

+ (NSDictionary *)formatParameters:(NSDictionary *)parameters firstKey:(NSString *)firstKey secondKey:(NSString *)secondKey
{
    if (parameters.count == 0 || firstKey.length == 0 || secondKey.length == 0) {
        return nil;
    }
    id firstValue = [parameters objectForKey:firstKey];
    if ([firstValue isKindOfClass:[NSNumber class]]) {
        firstValue = [NSString stringWithFormat:@"%@", firstValue];
    }
    id secondValue = [parameters objectForKey:secondKey];
    if ([secondValue isKindOfClass:[NSNumber class]]) {
        secondValue = [NSString stringWithFormat:@"%@", secondValue];
    }
    if (firstValue == nil) {
        if ([firstKey isEqualToString:kDefaultFirstKey]) {
            firstValue = @"0";
        }
        if (firstValue == nil) {
            NSLog(@"****** 靠，居然不给值 firstKey:%@ ******", firstKey);
            firstValue = @"";
        }
    }
    if (secondValue == nil) {
        NSLog(@"****** 靠，居然不给值 secondKey:%@ ******", secondKey);
        secondValue = @"";
    }
    const NSString *firstStr = [self upEncryptWithText:firstValue];
    const NSString *secondStr = [self upEncryptWithText:secondValue];
    NSString *signStr = [PublicObject MD5ForString:[NSString stringWithFormat:@"%@%@", firstValue, secondValue]];
    signStr = [signStr substringWithRange:NSMakeRange(5, signStr.length - 10)];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mDict setObject:firstStr forKey:firstKey];
    [mDict setObject:secondStr forKey:secondKey];
    [mDict setObject:signStr forKey:@"sign"];
    
    //公共参数
    [mDict addEntriesFromDictionary:[self upCommonParameters]];
    return mDict;
}

+ (NSMutableDictionary *)upCommonParameters
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"iPhone" forKey:@"client"];
    [mDict setObject:[NSNumber numberWithInteger:ClientTypeIphone] forKey:@"client_type"];
    
    NSString *platformType = [PublicObject platformType];
    if (platformType) {
        [mDict setObject:platformType forKey:@"mobile_type"];
    }
    if ([PushManager deviceToken].length > 0) {
        [mDict setValue:[PushManager deviceToken] forKey:@"token"];
    }

    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if (systemVersion) {
        [mDict setObject:systemVersion forKey:@"os_version"];
    }
    
    NSString *deviceName = [UIDevice currentDevice].name;
    if (deviceName) {
        [mDict setObject:deviceName forKey:@"device_name"];
    }
    
    [mDict setObject:[NSString stringWithFormat:@"%d", [PublicObject isJailbroken] ? 1 : 0] forKey:@"jbk"];
    
    NSString *market = [PublicObject upAppChannelId];
    if (market) {
        [mDict setObject:market forKey:@"market"];
    }
    
    NSString *UDIDStr = [self upEncryptWithText:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    if (UDIDStr) {
        [mDict setObject:UDIDStr forKey:@"udid"];
    }
    
//    NSString *localVersion = [PublicObject getLocalVerson];
//    if (localVersion) {
//        [mDict setObject:localVersion forKey:@"app_version"];
//    }
    
    NSString *curLanguage = [PublicObject getCurrentLanguage];
    if (curLanguage) {
        [mDict setObject:curLanguage forKey:@"lang"];
    }
    
    NSString *curCountryCode = [PublicObject getCurrentCountryCode];
    if (curCountryCode) {
        [mDict setObject:curCountryCode forKey:@"country_code"];
    }
    
    NSString *bundleIdenfi = [ConfigureObject appBundleID];
    if ([PublicObject isEmpty:bundleIdenfi]) {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        bundleIdenfi = [plistDic objectForKey:(NSString *)kCFBundleIdentifierKey];
    }
    NSString *bundleIDStr = [self upEncryptWithText:bundleIdenfi];
    if (bundleIDStr) {
        [mDict setObject:bundleIDStr forKey:@"bundle_id"];
    }
    
//    NSString *lat = [UserObject loginUserObject].latitude;
//    NSString *lng = [UserObject loginUserObject].longitude;
//    NSString *locAddress = nil;
//    if (![PublicObject isEmpty:[UserObject loginUserObject].currentCity]) {
//        locAddress = [UserObject loginUserObject].currentCity;
//    }
//    if (![PublicObject isEmpty:[UserObject loginUserObject].currentSubLocality]) {
//        locAddress = [locAddress stringByAppendingString:[UserObject loginUserObject].currentSubLocality];
//    }
//    if (lat.length > 0 && lng.length > 0) {
//        NSString *locString = [NSString stringWithFormat:@"%@,%@", lat, lng];
//        if (![PublicObject isEmpty:locAddress]) {
//            locString = [locString stringByAppendingFormat:@",%@",locAddress];
//        }
//        //        NSLog(@"locAddress = %@",locAddress);
//        NSString *encLoc = [self upEncryptWithText:locString];
//        if (encLoc) {
//            [mDict setObject:encLoc forKey:@"loc"];
//        }
//    }
//    [UserObject loginUserObject].latitude = nil;
//    [UserObject loginUserObject].longitude = nil;
    
    return mDict;
}

+ (NSString *)getLocalVerson
{
    NSDictionary *localDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [localDic objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil) {
        localVersion = @"";
    }
    return localVersion;
}

+ (BOOL)isJailbroken
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:@"/Applications/Cydia.app"]){
        return YES;
    }
    if ([fileManager fileExistsAtPath:@"/private/var/lib/apt/"]){
        return YES;
    }
    return NO;
}

+ (NSString *)platformType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *result = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *platform = result;
    if (platform == nil) {
        platform = [UIDevice currentDevice].model;
    }
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (GSM)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}



//MD5加密算法
+ (NSString *)MD5ForString:(NSString *)str{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)upDecryptWithText:(NSString *)text
{
    NSData *decodeData = [text base64DecodedData];
    NSData *data = [decodeData AES256DecryptWithKey:[self upAK]];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)upEncryptWithText:(NSString *)text
{
    NSData *encodeData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [encodeData AES256EncryptWithKey:[self upAK]];
    return [data base64EncodedString];
}

+ (NSString *)upEncryptWithText:(NSString *)text key:(NSString *)key
{
    NSData *encodeData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [encodeData AES256EncryptWithKey:key];
    return [data base64EncodedString];
}

+ (NSString *)upDecryptWithText:(NSString *)text key:(NSString *)key
{
    NSData *decodeData = [text base64DecodedData];
    NSData *data = [decodeData AES256DecryptWithKey:key];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



+ (BOOL)isValidateEmail:(NSString *)email
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)isValidNickName:(NSString *)nickName
{
    NSString *regex = @"[0-9]*[A-Z|a-z|\u4e00-\u9fa5]+[0-9]*";//@"^[a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:nickName];
}
+ (BOOL)isValidateNumberForString:(NSString *)string
{
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSRange range = [string rangeOfCharacterFromSet:charSet];
    return (range.location == NSNotFound) ? YES : NO;
}

+ (BOOL)networkIsReachable
{
    
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}

+ (BOOL)networkIsReachableForShowAlert:(BOOL)showAlert
{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        if (showAlert && [UIApplication sharedApplication].keyWindow) {
            [MBProgressHUD showHUDOnlyTextAddedTo:[UIApplication sharedApplication].keyWindow
                                        labelText:@"请检查是否开启了网络服务!"
                                       afterDelay:kStayTime];
        }
        return NO;
    }
    else
        return YES;
}

// 计算中英文混编字符串长度
+ (NSInteger)convertToInt:(NSString*)strtemp
{
    NSInteger i,n = [strtemp length],l = 0,a = 0,b = 0;
    unichar c;
    for(i = 0;i < n;i ++) {
        c = [strtemp characterAtIndex:i];
        if(isblank(c)){
            b++;
        }
        else if(isascii(c)) {
            a++;
        }
        else {
            l++;
        }
    }
    if (a==0 && l==0) {
        return 0;
    }
    return l + (NSInteger)ceilf((CGFloat)(a+b)/2.0);
}
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define UP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define UP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif
+ (CGSize)sizeForString:(NSString *)strValue font:(UIFont *)font
{
    return UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX), NSLineBreakByWordWrapping);
}

+ (CGSize)sizeForString:(NSString *)strValue font:(UIFont *)font withMaxWidth:(CGFloat)maxWidth
{
    return UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(maxWidth, CGFLOAT_MAX), NSLineBreakByWordWrapping);
}

+ (CGSize)sizeForString:(NSString *)strValue font:(UIFont *)font model:(NSLineBreakMode)model
{
    return UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX), model);
}
+ (CGFloat)widthForString:(NSString *)strValue font:(UIFont *)font
{
    CGSize strSize = UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(MAXFLOAT, font.pointSize), NSLineBreakByWordWrapping);
    return strSize.width;
}
+ (CGFloat)widthForString:(NSString *)strValue font:(UIFont *)font model:(NSLineBreakMode)model
{
    CGSize strSize = UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(MAXFLOAT, font.pointSize), model);
    return strSize.width;
}

+ (CGFloat)heightForString:(NSString *)strValue font:(UIFont *)font andWidth:(CGFloat)width
{
    CGSize strSize = UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(width, CGFLOAT_MAX), NSLineBreakByWordWrapping);
    return strSize.height;
}

+ (CGFloat)heightForString:(NSString *)strValue font:(UIFont *)font andWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize strSize = UP_MULTILINE_TEXTSIZE(strValue, font, CGSizeMake(width, CGFLOAT_MAX), lineBreakMode);
    return strSize.height;
    //    CGSize strSize = [strValue sizeWithFont:font
    //                          constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
    //                              lineBreakMode:lineBreakMode];
    //
    //    return strSize.height;
}

+ (CGFloat)heightWithFont:(UIFont *)font
{
    return [PublicObject heightForString:@"测试" font:font andWidth:MAXFLOAT];//@"测试"
}

+ (CGFloat)textWidthForUILabel:(UILabel *)label
{
    return [self widthForString:label.text font:label.font];
}

+ (NSString *)subString:(NSString *)string withLocation:(NSUInteger)location length:(NSUInteger)length
{
    NSUInteger strLength = string.length;
    if (location >= strLength || strLength == 0 || length == 0) {
        return nil;
    }
    
    __block BOOL beginContainEmoji = NO;
    BOOL beginOffset = NO;
    
    if (location > 0) {
        beginOffset = YES;
        location--;
    }
    NSRange strRange = NSMakeRange(location, strLength - location);
    
    
    __block NSRange resultRange = NSMakeRange(strRange.location, 0);
    __block NSInteger firstLength = 0;
    [string enumerateSubstringsInRange:strRange
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         if (beginOffset) {
             if (firstLength == 0) {
                 firstLength = substringRange.length;
             }
             if (resultRange.length == 0 && substringRange.length == 2) {
                 beginContainEmoji = YES;
             }
         }
         resultRange.length+=substringRange.length;
         
         if (resultRange.length >= length + firstLength) {
             *stop = YES;
             return;
         }
     }];
    
    if (beginOffset) {
        resultRange.location++;
        resultRange.length-=firstLength;
        if (resultRange.length == 0) {
            return nil;
        }
        if (beginContainEmoji) {
            resultRange.location++;
            resultRange.length--;
        }
    }
    
    __block BOOL endContainEmoji = NO;
    
    if (resultRange.location + resultRange.length < strLength) {
        [string enumerateSubstringsInRange:NSMakeRange(resultRange.location + resultRange.length -1, 2)
                                   options:NSStringEnumerationByComposedCharacterSequences
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
         {
             if (substringRange.length == 2) {
                 endContainEmoji = YES;
             }
         }];
        if (endContainEmoji) {
            resultRange.length--;
        }
    }
    return [string substringWithRange:resultRange];
}

+ (void)setButton:(UIButton *)button
   textAttributes:(NSDictionary *)textAttributes
     controlState:(UIControlState)controlState
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    id textFont = [textAttributes objectForKey:UITextAttributeFont];
    if ([textFont isKindOfClass:[UIFont class]]) {
        button.titleLabel.font = textFont;
    }
    id textColor = [textAttributes objectForKey:UITextAttributeTextColor];
    if ([textColor isKindOfClass:[UIColor class]]) {
        [button setTitleColor:textColor forState:controlState];
    }
    id textShadowColor = [textAttributes objectForKey:UITextAttributeTextShadowColor];
    if ([textShadowColor isKindOfClass:[UIColor class]]) {
        [button setTitleShadowColor:textShadowColor forState:controlState];
    }
    id textShadowOffset = [textAttributes objectForKey:UITextAttributeTextShadowOffset];
    if ([textShadowOffset isKindOfClass:[NSValue class]]) {
        CGSize textOffset;
        [textShadowOffset getValue:&textOffset];
        button.titleLabel.shadowOffset = shadowOffset;
    }
#else
    id textFont = [textAttributes objectForKey:NSFontAttributeName];
    if ([textFont isKindOfClass:[UIFont class]]) {
        button.titleLabel.font = textFont;
    }
    id textColor = [textAttributes objectForKey:NSForegroundColorAttributeName];
    if ([textColor isKindOfClass:[UIColor class]]) {
        [button setTitleColor:textColor forState:controlState];
    }
    NSShadow *shadowObject = [textAttributes objectForKey:NSShadowAttributeName];
    if ([shadowObject isKindOfClass:[NSShadow class]] && shadowObject) {
        [button setTitleShadowColor:shadowObject.shadowColor forState:controlState];
        button.titleLabel.shadowOffset = shadowObject.shadowOffset;
    }
#endif
}


// 设置font参数
+(UIFont *)fontWithSize:(float)fontSize fontName:(NSString *)fontName isBold:(BOOL)isBold {
    if ([self isEmpty:fontName]) {
        if (isBold) {
            return [UIFont boldSystemFontOfSize:fontSize];
        }
        return [UIFont systemFontOfSize:fontSize];
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIImage *)fixOrientationForImage:(UIImage *)image
{
    return [image fixOrientation];
}

+ (CGSize )sizeWithImage:(UIImage *)image adjustToSize:(CGSize)newSize
{
    //    CGSize size;
    //    if (image.size.width > image.size.height){
    //        size.width = contentSize.width;
    //        size.height = contentSize.width * image.size.height / image.size.width;
    //    }else{
    //        size.height = contentSize.height;
    //        size.width = contentSize.height * image.size.width / image.size.height;
    //    }
    //    return size;
    
    if (image.size.width < newSize.width && image.size.height < newSize.height) {
        
        return image.size;
    }
    
    /// Keep aspect ratio
    size_t destWidth, destHeight;
    if (image.size.width > image.size.height)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(image.size.height * newSize.width / image.size.width);
    }
    else
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(image.size.width * newSize.height / image.size.height);
    }
    if (destWidth > newSize.width)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(image.size.height * newSize.width / image.size.width);
    }
    if (destHeight > newSize.height)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(image.size.width * newSize.height / image.size.height);
    }
    
    return CGSizeMake(destWidth, destHeight);
}


+ (BOOL)isiPhone5
{
    return ([UIScreen mainScreen].bounds.size.height > 480);
}

+ (BOOL)isIPhone6
{
    return ([UIScreen mainScreen].bounds.size.width > 320 && [UIScreen mainScreen].bounds.size.width < 400);
}

+ (BOOL)isiPhone6plus
{
    //6plus 的宽度为414 6的宽度为375 5s及以下为320
    return ([UIScreen mainScreen].bounds.size.width > 400);
}

+ (NSString *)systemDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)systemCachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)generateUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidRef));
    CFRelease(uuidRef);
    return uuidString;
}

+ (NSString *)generateNoLineUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidRef));
    CFRelease(uuidRef);
    return [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
// 判空字符串
+(BOOL) isEmpty:(NSString *)str{
    if (str == nil || [str isEqualToString:@""]) {
        return TRUE;
    }
    NSString *tem = [str  stringByReplacingOccurrencesOfString: @" " withString:@""];
    return [tem length]==0;
}

+ (UILabel *)barTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = kBarTitleFont;
    titleLabel.textAlignment = MYTextAlignmentCenter;
    titleLabel.text = title;
    return titleLabel;
}

+ (NSString *)getCurrentDate {
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian_date = [[NSCalendar alloc]
                                  initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian_date components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:today];
    
    int year = (int)[weekdayComponents year];
    int month = (int)[weekdayComponents month];
    int day1 = (int)[weekdayComponents day];
    int hour = (int)[weekdayComponents hour];
    int minute = (int)[weekdayComponents minute];
    int second = (int)[weekdayComponents second];
    NSString *currentDate = [NSString stringWithFormat:@"%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d", year, month, day1,hour,minute,second];
    //    NSString *currentDate = [NSString stringWithFormat:@"%0.4d-%0.2d-%0.2d", year, month, day1];
    
    return currentDate;
}

//+ (NSString *)getCurrentDateWithAanosecond {
//
//    NSDate *today = [NSDate date];
//    NSCalendar *gregorian_date = [[NSCalendar alloc]
//                                  initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *weekdayComponents =
//    [gregorian_date components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:today];
//
//    int year = (int)[weekdayComponents year];
//    int month = (int)[weekdayComponents month];
//    int day1 = (int)[weekdayComponents day];
//    int hour = (int)[weekdayComponents hour];
//    int minute = (int)[weekdayComponents minute];
//    int second = (int)[weekdayComponents second];
//    int nanosecond = (int)[weekdayComponents nanosecond];
//    NSLog(@"nanosecond = %ld,%@",(long)[weekdayComponents nanosecond],today);
//    NSString *currentDate = [NSString stringWithFormat:@"%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d:%0.2d", year, month, day1,hour,minute,second,nanosecond];
////    NSString *currentDate = [NSString stringWithFormat:@"%0.4d-%0.2d-%0.2d", year, month, day1];
//
//    return currentDate;
//}


+ (NSString *)getCurrentDay {
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian_date = [[NSCalendar alloc]
                                  initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian_date components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:today];
    
    int year = (int)[weekdayComponents year];
    int month = (int)[weekdayComponents month];
    int day1 = (int)[weekdayComponents day];
    NSString *currentDate = [NSString stringWithFormat:@"%0.4d.%0.2d.%0.2d", year, month, day1];//@"%0.4d年%d月%d日
    return currentDate;
}

+ (NSString *)getCurrentWeekDay:(BOOL)isEnglish
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian_date = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian_date components:(NSWeekdayCalendarUnit) fromDate:today];
    
    NSInteger weekDay = [weekdayComponents weekday];
    NSString *weedDayString = @"";
    switch (weekDay) {
        case 1:
            weedDayString = isEnglish ? @"Sun." : @"星期日";
            break;
        case 2:
            weedDayString = isEnglish ? @"Mon." : @"星期一";
            break;
        case 3:
            weedDayString = isEnglish ? @"Tues." : @"星期二";
            break;
        case 4:
            weedDayString = isEnglish ? @"Wed." : @"星期三";
            break;
        case 5:
            weedDayString = isEnglish ? @"Thur." : @"星期四";
            break;
        case 6:
            weedDayString = isEnglish ? @"Fri." : @"星期五";
            break;
        case 7:
            weedDayString = isEnglish ? @"Sat." : @"星期六";
            break;
            
        default:
            break;
    }
    
    return weedDayString;
}
+ (BOOL)isChinaRegion
{
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    if ([countryCode isEqualToString:@"CN"] || [countryCode isEqualToString:@"Hk"]|| [countryCode isEqualToString:@"TW"]|| [countryCode isEqualToString:@"MO"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getCurrentCountryCode
{
    NSString * countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return countryCode;
}
+ (BOOL)isRetina {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0));
}
+ (NSString *)getCurrentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* currentLanguage = [defaults objectForKey:@"appLanguage"];
    return currentLanguage;
}

+ (BOOL)isChaneseLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* currentLanguage = [defaults objectForKey:@"appLanguage"];
    //繁体中文 简体中文
    if ([currentLanguage hasPrefix:@"zh"]) {
        return YES;
    }
    return NO;
}

+ (void)removeNavigationBarShadowImage:(UINavigationController *)nc
{
    nc.navigationBar.shadowImage = [[UIImage alloc] init];
}


+ (void)showAlertViewForMessage:(NSString *)aMessage
{
    [PublicObject showAlertViewWithTitle:@"提示"//@"提示"
                              message:aMessage
                          cancelTitle:@"确定"//@"确定"
                           otherTitle:nil
                           completion:NULL];
}

+ (void)showAlertViewForTitle:(NSString *)title message:(NSString *)message
{
    [PublicObject showAlertViewWithTitle:title
                              message:message
                          cancelTitle:UPLocalizedString(@"sure", nil)//@"确定"
                           otherTitle:nil
                           completion:NULL];
}

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelTitle:(NSString *)cancelTitle
                    otherTitle:(NSString *)otherTitle
                    completion:(PXAlertViewCompletionBlock)completion
{
    [self showAlertViewWithTitle:title message:message cancelTitle:cancelTitle otherTitle:otherTitle tapBlankNotCancel:NO completion:completion];
}

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelTitle:(NSString *)cancelTitle
                    otherTitle:(NSString *)otherTitle
             tapBlankNotCancel:(BOOL)tapBlankNotCancel
                    completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                              otherTitle:otherTitle
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (completion) {
                                                      completion(cancelled, buttonIndex);
                                                  }
                                              }];
    [alert setCancelButtonBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [alert setOtherButtonBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [alert setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [alert setWindowTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [alert setTitleColor:[UIColor blackColor]];
    [alert setMessageColor:[UIColor blackColor]];
    [alert setButtonTitleColor:[UIColor blueColor]];//[UIColor colorWithRed:0 green:97.0/255.0 blue:137.0/255.0 alpha:1]];
    alert.tapBlankNotCancel = tapBlankNotCancel;
//    NSLog(@"[alert superclass]--%@",[alert superclass]);
}
+ (void)showAlertViewWithMessage:(NSString *)message completion:(PXAlertViewCompletionBlock)completion
{
    [self showAlertViewWithTitle:@"提示"//@"提示"
                         message:message
                     cancelTitle:@"取消"//@"取消"
                      otherTitle:@"确定"//@"确定"
                      completion:completion];
}
+ (NSString *)notRounding:(NSDecimalNumber *)price afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces;
    roundedOunces = [price decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (void)ActionWithImageName:(NSString *)imageName imageCount:(NSInteger)imageCount praiseImage:(UIImageView *)praiseImage duration:(NSTimeInterval)duration{
    //存储一组图片的数组
    NSMutableArray *imageArry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 1; i <= imageCount; i++) {
        //图片名
        NSString *name = [NSString stringWithFormat:@"%@%d.png",imageName, i];
        //图片对象
        UIImage *image = [UIImage imageNamed:name];
        //image 添加到数组 imageArry
        [imageArry addObject:image];
    }
    //设置动态播放的图片
    praiseImage.animationImages = imageArry;
    //设置图片播放的时间
    praiseImage.animationDuration = duration;
    //设置图片播放的次数
    praiseImage.animationRepeatCount = 2;
    //播放图片
    [praiseImage startAnimating];
    
}
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
+ (NSString *)getShowDateWithTime:(NSString *)time {
    /**
     传入时间转NSDate类型
     */
    NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]];
    
    /**
     初始化并定义Formatter
     :returns: NSDate
     */
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm";
    /**
     *  使用Formatter格式化时间（传入时间和当前时间）为NSString
     */
    NSString *timeStr = [dateFormatter stringFromDate:timeDate];
    NSString *nowDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    /**
     *  判断前四位是不是本年，不是本年直接返回完整时间
     */
    if ([[timeStr substringWithRange:NSMakeRange(0, 4)] rangeOfString:[nowDateStr substringWithRange:NSMakeRange(0, 4)]].location == NSNotFound) {
        return timeStr;
    }else{
        /**
         *  判断是不是本天，是本天返回HH:mm,不是返回MM-dd HH:mm
         */
        if ([[timeStr substringWithRange:NSMakeRange(5, 5)] rangeOfString:[nowDateStr substringWithRange:NSMakeRange(5, 5)]].location != NSNotFound) {
            NSString *str = [NSString stringWithFormat:@"今天%@",[timeStr substringWithRange:NSMakeRange(11, 5)]];
            return str;
        }else{
            return [timeStr substringWithRange:NSMakeRange(5, 11)];
        }
    }
}
+ (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

+ (UINavigationController *)ncForVC:(UIViewController *)vc
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    return nav;
}

+ (UINavigationController *)sliderBackNCForVC:(UIViewController *)vc
{
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    SlideBackNavigationController *nav = [[SlideBackNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    return nav;
}

+ (UINavigationController *)blackNcForVC:(UIViewController *)vc
{
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.navigationBar.translucent = NO;
    //    UIImage *navBackground = [UIImage imageNamed:@"blackNB_bj"];
    //    Class ios5Class = (NSClassFromString(@"CIImage"));
    //    if (nil != ios5Class) {
    //        [nc.navigationBar setBackgroundImage:navBackground forBarMetrics:UIBarMetricsDefault];
    //    }else {
    //        nc.navigationBar.layer.contents = (id)navBackground.CGImage;
    //    }
    //
    //#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    //    [nc.navigationBar setTitleTextAttributes:@{
    //                                               UITextAttributeFont : kBarTitleFont,
    //                                               UITextAttributeTextColor : kBarTitleFontColor,
    //                                               UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeZero]}];
    //#else
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    [nc.navigationBar setTitleTextAttributes:@{
                                               NSFontAttributeName : kBarTitleFont,
                                               NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [nc.navigationBar setBarTintColor:[UIColor blackColor]];
    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    
    //#endif
    return nc;
}

+ (BOOL)isNeedLongTransitionTime
{
    size_t size;
    
    // get the length of machine name
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    // get machine name
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform hasPrefix:@"iPhone1"]) {
        //iPhone 1G - 3G
        return YES;
    }
    else if ([platform hasPrefix:@"iPhone2"]) {
        // 3GS
        return YES;
    }
    else if ([platform hasPrefix:@"iPhone3"]) {
        // iphone 4
        return YES;
    }
    else if ([platform hasPrefix:@"iPhone4"]) {
        // 4s
        return NO;
    }
    else if ([platform hasPrefix:@"iPhone5"]) {
        // 5 5c
        return NO;
    }
    else if ([platform hasPrefix:@"iPhone6"]) {
        // 5s
        return NO;
    }
    else if ([platform hasPrefix:@"iPhone7"]) {
        // 6
        return NO;
    }
    else if ([platform hasPrefix:@"iPod1"]) {
        //iPod Touch 1G
        return YES;
    }
    else if ([platform hasPrefix:@"iPod2"]) {
        //iPod Touch 2G
        return YES;
    }
    else if ([platform hasPrefix:@"iPod3"]) {
        //iPod Touch 3G
        return YES;
    }
    else if ([platform hasPrefix:@"iPod4"]) {
        //iPod Touch 4G
        return YES;
    }
    else if ([platform isEqualToString:@"iPod5"]) {
        // iPod Touch 5
        return NO;
    }
    else if ([platform isEqualToString:@"iPad1"]) {
        // ipad
        return YES;
    }
    else {
        return NO;
    }
}

+ (UIImage *)videoThumbnailForLastFrame:(BOOL)lastFrame withVideoUrl:(NSString *)videoUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoUrl] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime duration = asset.duration;
    
    CMTime time = CMTimeMakeWithSeconds(lastFrame ? duration.value : 0, duration.timescale);
    
    NSError *error = nil;
    
    //    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:NULL error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

#pragma -----base64转换
//base64转换
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

+ (NSDictionary *)splitQuery:(NSString *)query {
    
    if(!query || [query length] == 0) return nil;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for(NSString *component in [query componentsSeparatedByString:@"&"]) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        if (subcomponents.count >= 2) {
            [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return parameters;
}
+ (NSString *)getUperAppRateURL
{
    NSString *evaluationAppUrl = [NSString
                                  stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"673070997"];
    if (kIsIOS7) {
        // 在7.0下app评价链接不好用，故先调用下载连接
        evaluationAppUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xiang-shang/id%@?mt=8",@"673070997"];
    }
    return evaluationAppUrl;
}

+ (void)convertVideoQualityWithInputURL:(NSURL *)inputURL outputURL:(NSURL *)outputURL completedBlock:(void(^)(BOOL isSuccess, NSString *errorString))completedBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
        AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (exportSession.status)
            {
                case AVAssetExportSessionStatusUnknown:
                    break;
                case AVAssetExportSessionStatusWaiting:
                    break;
                case AVAssetExportSessionStatusExporting:
                    break;
                case AVAssetExportSessionStatusCompleted: {
                    completedBlock(YES,@"完成");
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                    completedBlock(NO,@"取消了");
                    break;
                case AVAssetExportSessionStatusFailed:
                    if (completedBlock) {
                        completedBlock(NO,[exportSession.error localizedDescription]);
                    }
                    break;
            }
        }];
    });
}

@end
