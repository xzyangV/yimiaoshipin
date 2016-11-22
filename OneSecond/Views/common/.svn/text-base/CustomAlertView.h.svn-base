//
//  CustomAlertView.h
//  AlertView
//
//  Created by wujing on 16/4/12.
//  Copyright © 2016年 wujing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

@property (nonatomic) BOOL leftLeave;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIView *tvContent;
@property (nonatomic, strong) UIView *tvBottom;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;



+ (void)popViewWithTitle:(NSString *)title
             contentText:(UIView *)content
            contentFrame:(CGRect)contentFrame
              bottomView:(UIView*)bottomView
             bottomFrame:(CGRect)bottomFrame
         leftButtonTitle:(NSString *)leftTitle
        rightButtonTitle:(NSString *)rigthTitle
               leftBlock:(dispatch_block_t)leftBlock
              rightBlock:(dispatch_block_t)rightBlock
            dismissBlock:(dispatch_block_t)dismissBlock;





@end
