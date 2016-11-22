//
//  MBProgressHUD+CMBProgressHUD.h
//  WherePlay
//
//  Created by An Mingyang on 13-1-22.
//  Copyright (c) 2013年 An Mingyang. All rights reserved.
//

//为了不更改原作者代码故新加个分类定义新类方法

#import "MBProgressHUD.h"

@interface MBProgressHUD (CMBProgressHUD)

/*  对原有showHUDAddedTo方法的扩展,增加了labelText参数方便直接调用
    显示完后需要手动调动hideHUDForView 或 hideAllHUDsForView方法关闭隐藏
*/
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view
                        labelText:(NSString *)labelText;

/*  不带动画只显示纯文本,指定afterDelay的时间间隔后自动释放   */
+ (MBProgressHUD *)showHUDOnlyTextAddedTo:(UIView *)view
                     labelText:(NSString *)labelText
                    afterDelay:(NSTimeInterval)afterDelay;

/*  不带动画显示带"对号"的图片和纯文本,指定afterDelay的时间间隔后自动释放   */
+ (void)showHUDCheckmarkAddedTo:(UIView *)view
                     labelText:(NSString *)labelText
                    afterDelay:(NSTimeInterval)afterDelay;

/*  不带动画显示带"对号"的图片和纯文本 第三个参数为执行的代码块 第四个参数为显示完后要执行的代码块
    是对自带方法的扩展- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion 
*/
+ (void)showHUDCheckmarkAddedTo:(UIView *)view
                      labelText:(NSString *)labelText
            whileExecutingBlock:(dispatch_block_t)block
                completionBlock:(void (^)())completion;


@end
