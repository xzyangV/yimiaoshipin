//
//  CMActionSheet.h
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallbackBlock) ();
typedef void (^CMActionSheetCompletionBlock)(NSInteger buttonIndex);

typedef enum {
//	CMActionSheetButtonTypeWhite = 0,
//	CMActionSheetButtonTypeBlue,
//    CMActionSheetButtonTypeGray,
//	CMActionSheetButtonTypeRed,
    CMActionSheetButtonTypeNormal,
    CMActionSheetButtonTypeCancel
} CMActionSheetButtonType;

@class CMActionSheet;
@protocol CMActionSheetDelegate <NSObject>

- (void)CMActionSheetDidSelectedBackGroundView:(CMActionSheet *)actionSheet;

@end

@interface CMActionSheet : NSObject {
    

}

@property (strong) NSString *title;
@property (nonatomic) int actionSheetTag;
@property (nonatomic,weak) id<CMActionSheetDelegate> delegate;

+ (void)showActionSheetWithTitles:(NSArray *)titles completionBlock:(CMActionSheetCompletionBlock)block;
+ (void)showActionSheetWithTitles:(NSArray *)titles images:(NSArray *)images completionBlock:(CMActionSheetCompletionBlock)block;

- (id)initWithTarget:(id)delegate;

- (void)addButtonWithTitle:(NSString *)btnTitle block:(CallbackBlock)block;
- (void)addButtonWithTitle:(NSString *)btnTitle image:(UIImage *)image block:(CallbackBlock)block;

- (void)addButtonWithTitle:(NSString *)btnTitle type:(CMActionSheetButtonType)type block:(CallbackBlock)block;
- (void)addButtonWithTitle:(NSString *)btnTitle image:(UIImage *)image type:(CMActionSheetButtonType)type block:(CallbackBlock)block;

//- (void)addSeparator;

- (void)present;
- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated;

@end
