
#import "ShareTypeDef.h"
#import "ShareUserInfo.h"


/**
 *	@brief	获取用户信息事件处理器
 *
 *  @param  result  回复标识，YES：获取成功，NO：获取失败
 *  @param  userInfo     用户信息
 *  @param  error   获取失败的错误信息
 */


typedef void(^LoginAndGetInfoHandler) (BOOL result, BOOL isCancel, NSString *error, ShareUserInfo *userInfo);

typedef void(^AuthLoginEventHandler) (BOOL result, BOOL isCancel, NSString *error);

typedef void(^GetUserInfoEventHandler) (BOOL result, ShareUserInfo *userInfo);

typedef void(^PublishContentEventHandler) (ShareType type, BOOL result);

typedef void(^GetImageData) (UIImage *image);

typedef void(^GetFriendIdolList) (NSArray *idolList,NSInteger totalNumber,NSInteger next_index,NSInteger pre_index);

typedef void(^GetFriendList) (NSArray *idolList,NSInteger totalNumber,NSString *pre_cursor,NSString *next_cursor);

typedef void(^SendMessageToFiend) (BOOL result);

typedef void(^SNSPayBlock) (BOOL isSuccess, BOOL isCancel, NSString *error);

