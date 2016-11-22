//
//  MBProgressHUD+CMBProgressHUD.m
//  WherePlay
//
//  Created by An Mingyang on 13-1-22.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//

#import "MBProgressHUD+CMBProgressHUD.h"

#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#endif

@implementation MBProgressHUD (CMBProgressHUD)

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view
                        labelText:(NSString *)labelText
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = labelText;
    [hud show:YES];
    hud.color = nil;
    return MB_AUTORELEASE(hud);
}

+ (MBProgressHUD *)showHUDOnlyTextAddedTo:(UIView *)view
                     labelText:(NSString *)labelText
                    afterDelay:(NSTimeInterval)afterDelay
{
    if (labelText != nil && ![labelText isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont systemFontOfSize:13.0];
        hud.detailsLabelText = labelText;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:afterDelay];
        hud.color = nil;
        hud.userInteractionEnabled = NO;
        return MB_AUTORELEASE(hud);
    }
    return nil;
}

+ (void)showHUDCheckmarkAddedTo:(UIView *)view
                      labelText:(NSString *)labelText
                     afterDelay:(NSTimeInterval)afterDelay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.labelText = labelText;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = nil;
    [hud hide:YES afterDelay:afterDelay];
}

+ (void)showHUDCheckmarkAddedTo:(UIView *)view
                      labelText:(NSString *)labelText
            whileExecutingBlock:(dispatch_block_t)block
                completionBlock:(void (^)())completion
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageView;
    hud.removeFromSuperViewOnHide = YES;
	hud.labelText = labelText;
    hud.color = nil;
    [hud showAnimated:YES whileExecutingBlock:block completionBlock:completion];
}

@end
