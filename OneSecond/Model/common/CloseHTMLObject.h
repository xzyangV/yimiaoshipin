//
//  CloseHTMLObject.h
//  Up
//
//  Created by uper on 16/1/26.
//  Copyright © 2016年 amy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^CloseHTMLBlock)(void);

@protocol CloseJSObjectProtocol <JSExport>

-(void)onClose;

@end
@interface CloseHTMLObject : NSObject<CloseJSObjectProtocol>
@property (nonatomic, copy)CloseHTMLBlock closeBlock;

@property (nonatomic,weak) id<CloseJSObjectProtocol> closeDelegate;
 
@end
