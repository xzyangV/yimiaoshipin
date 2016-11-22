//
//  ShareQzone.m
//  TestShareDemo
//
//  Created by zhangyx on 13-4-19.
//  Copyright (c) 2013年 zhangyx. All rights reserved.
//

#import "ShareQzone.h"
#import "MBProgressHUD.h"
#import "ShareUserInfo.h"
#define kUserDefaultKeyListAlbumId @"kUserDefaultKeyListAlbumId"
//
@interface ShareQzone () <TencentSessionDelegate> {
    NSMutableArray* _permissions;
    BOOL _isAuthLogin;

}
@property (nonatomic,copy) GetUserInfoEventHandler getUserInfoResult;
@property (nonatomic,copy) AuthLoginEventHandler authLoginResult;
@property (nonatomic,copy) PublishContentEventHandler publishContentResult;

@end

@implementation ShareQzone


static ShareQzone *shareqzone;
+ (ShareQzone *)qzoneInstance
{
    if (shareqzone == nil) {
        shareqzone = [[ShareQzone alloc] init];
    }
    return shareqzone;
}


- (TencentOAuth *)qZoneOAuth
{
    
    return self.tencentOAuth;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [TencentOAuth HandleOpenURL:url];
}


- (void)connectQZoneWithAppKey:(NSString *)appId
{
    if (self.tencentOAuth != nil) {
        
        return ;
    }

    _permissions = [NSMutableArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];
    
//    NSLog(@"verson = %@",[TencentOAuth sdkVersion]);
	TencentOAuth *tencentO_auth = [[TencentOAuth alloc] initWithAppId:appId
                                                          andDelegate:self];
    self.tencentOAuth = tencentO_auth;
}

+ (BOOL)isSupportIphoneSSOLogin
{
    return [TencentOAuth iphoneQQSupportSSOLogin];
}


- (void)qzoneAuthLoginWithResult:(AuthLoginEventHandler)result
{
    _isAuthLogin = YES;
    self.authLoginResult = result;
    [self onClickTencentOAuth];
}

- (void)getUserInfoWithresult:(GetUserInfoEventHandler)result
{
    _isAuthLogin = NO;

    self.getUserInfoResult = result;
    
    [self onClickTencentOAuth];
}


- (void)showShareWithContent:(ShareContent *)content
                      result:(PublishContentEventHandler)result
{
    self.publishContentResult = result;
    
//    [self onClickAddShareWithTitle:[content title]
//                       userComment:[content desc]
//                           summary:[content content]
//                          imageUrl:[content imagePath]
//                           website:[content url]];
}


/**
 * tencentOAuth
 */
- (void)onClickTencentOAuth {
	[[self qZoneOAuth] authorize:_permissions];
}

/**
 * tencentOAuthBySafari
- (void)onClickTencentOAuthBySafari {
	[[self qZoneOAuth] authorize:_permissions inSafari:YES];
}
 */

/**
 * Get user info.
 */
- (void)onClickGetUserInfo {
	if(![[self qZoneOAuth] getUserInfo]){
        [self showInvalidTokenOrOpenIDMessage];
        return;
    }
}

- (void)showInvalidTokenOrOpenIDMessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败"
                                                    message:@"可能授权已过期，请重新获取"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

/*
// add Share.
- (void)onClickAddShareWithTitle:(NSString *)shareTitle
                     userComment:(NSString *)comment
                         summary:(NSString *)summary
                        imageUrl:(NSString *)imageurl
                         website:(NSString *)webSite {
    
    TCAddShareDic *params = [TCAddShareDic dictionary];
    params.paramTitle = shareTitle;
    params.paramComment = comment;      
    params.paramSummary = summary;
    params.paramImages = imageurl;
    params.paramUrl = webSite;
	
	if(![[self qZoneOAuth] addShareWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
*/

// uploadPic
- (void)onClickUploadPic {
    
	NSString *path = @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
	NSURL *url = [NSURL URLWithString:path];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img  = [[UIImage alloc] initWithData:data];
    NSString *albumId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyListAlbumId];
    if ([albumId length] == 0)
    {
        albumId = @"c1aa115b-947c-4116-a5fc-128167eaec9f";
    }
	
    TCUploadPicDic *params = [TCUploadPicDic dictionary];
    params.paramPicture = img;
    params.paramAlbumid = albumId;
    params.paramTitle = @"风云乔布斯";
    params.paramPhotodesc = @"比天皇巨星还天皇巨星的天皇巨星";
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
    params.paramX = @"39.909407";
    params.paramY = @"116.397521";
    
	if(![[self qZoneOAuth] uploadPicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}

// Get list album.
- (void)onClickListalbum{
	
	if(![[self qZoneOAuth] getListAlbum]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}


// Add Album.
- (void)onClickAddAlbum{
	
    TCAddAlbumDic *params = [TCAddAlbumDic dictionary];
    params.paramAlbumname = @"iosSDK接口测试相册";
    params.paramAlbumdesc = @"我的测试相册";
    params.paramPriv = @"1";
	
	if(![[self qZoneOAuth] addAlbumWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}

/*

// Add Blog.
- (void)onClickAddBlog{
	
    TCAddOneBlogDic *params = [TCAddOneBlogDic dictionary];
    params.paramTitle = @"title";
    params.paramContent = @"哈哈,测试成功";
    
	if(![[self qZoneOAuth] addOneBlogWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}

// upTopic.
-(void)onClickTopic{
	
    TCAddTopicDic *params = [TCAddTopicDic dictionary];
    params.paramRichtype = @"3";
    params.paramRichval = @"http://www.tudou.com/programs/view/C0FuB0FTv50/";
    params.paramCon = @"腾讯addtopic接口测试--失控小警察视频参数";
    params.paramLbs_nm = @"广东省深圳市南山区高新科技园腾讯大厦";
    params.paramThirdSource = @"2";
    params.paramLbs_x = @"39.909407";
    params.paramLbs_y = @"116.397521";
	if(![[self qZoneOAuth] addTopicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
*/

// Get List Photo
-(void)onClickListPhoto{
    NSString *albumId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyListAlbumId];
    if ([albumId length] == 0)
    {
        albumId = @"c1aa115b-947c-4116-a5fc-128167eaec9f";
    }
    
    TCListPhotoDic *params = [TCListPhotoDic dictionary];
    params.paramAlbumid = albumId;
	
	if(![[self qZoneOAuth] getListPhotoWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
}
// Check Fans
-(void) onClickCheckFans{
    
    TCCheckPageFansDic *params = [TCCheckPageFansDic dictionary];
    [params setParamPage_id:@"973751369"];
	
	if(![[self qZoneOAuth] checkPageFansWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
	
}

// setUserHeadPic
-(void) onClickSetUserHeadPic
{
    /*
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    }
    ipc.delegate = self;
    ipc.allowsImageEditing = NO;
    
    [self presentViewController:ipc animated:YES completion:nil];
    //    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:ipc animated:YES completion:nil];
     */
}

// getVipInfo
- (void)onClickGetVipInfo
{
    if (![[self qZoneOAuth] getVipInfo])
    {
        [self showInvalidTokenOrOpenIDMessage];
    }
}

// getVipRichInfo
- (void)onClickGetVipRichInfo
{
    if (![[self qZoneOAuth] getVipRichInfo])
    {
        [self showInvalidTokenOrOpenIDMessage];
    }
}

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *Title = [alertView title];
    NSString *ButtonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    UITextField *textMatch;
    UITextField *textReqnum;
    
    
    if ([Title isEqualToString:@"请输入匹配字符串"])
    {
        if([ButtonTitle isEqualToString:@"确定"])
        {
            //textMatch = [alertView textFieldAtIndex:0];
            textMatch = (UITextField*)[alertView viewWithTag:0xAA];
            _Marth = [textMatch.text copy];
        }
    }
    else if ([Title isEqualToString:@"请输入请求个数"])
    {
        if([ButtonTitle isEqualToString:@"确定"])
        {
            //textReqnum = [alertView textFieldAtIndex:0];
            textReqnum = (UITextField*)[alertView viewWithTag:0xAA];
            _Reqnum = [textReqnum.text copy];
        }
    }
    
    CFRunLoopStop(CFRunLoopGetCurrent());
}

*/

/**
 * matchNickTips
 */
- (void)onClickMatchNickTips
{
    /*
    TextAlertView *alertMatch = [[TextAlertView alloc] initWithTitle:@"请输入匹配字符串" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alertMatch.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInputMatch = [[UITextField alloc] initWithFrame:CGRectZero];
    textInputMatch.borderStyle = UITextBorderStyleRoundedRect;
    [textInputMatch setPlaceholder:@"要匹配的字符串"];
    textInputMatch.tag = 0xAA;
    [alertMatch addSubview:textInputMatch];
    [textInputMatch release];
    
    [alertMatch show];
    [alertMatch release];
    CFRunLoopRun();
    
    TextAlertView *alertReqnum = [[TextAlertView alloc] initWithTitle:@"请输入请求个数" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alertReqnum.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInputReqnum = [[UITextField alloc] initWithFrame:CGRectZero];
    textInputReqnum.borderStyle = UITextBorderStyleRoundedRect;
    [textInputReqnum setPlaceholder:@"请求个数（1-10）"];
    textInputReqnum.tag = 0xAA;
    [alertReqnum addSubview:textInputReqnum];
    [textInputReqnum release];
    
    [alertReqnum show];
    [alertReqnum release];
    CFRunLoopRun();
    
    _labelTitle.text = @"正在拉取微博好友提示";
    
    TCMatchNickTipsDic *params = [TCMatchNickTipsDic dictionary];
    
    [params setParamMatch:_Marth];
    [params setParamReqnum:_Reqnum];
    
    if (![_tencentOAuth matchNickTips:params])
    {
        [self showInvalidTokenOrOpenIDMessage];
        _labelTitle.text = @"";
    }
     */
}


/**
 * getIntimateFriends
 */

/*
- (void)onClickGetIntimateFriends
{
    TextAlertView *alert = [[TextAlertView alloc] initWithTitle:@"请输入请求个数" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textInput = [[UITextField alloc] initWithFrame:CGRectZero];
    textInput.borderStyle = UITextBorderStyleRoundedRect;
    [textInput setPlaceholder:@"请求个数（1-20）"];
    textInput.tag = 0xAA;
    [alert addSubview:textInput];
    [textInput release];
    
    [alert show];
    [alert release];
    CFRunLoopRun();
    
//    _labelTitle.text = @"正在拉取微博最近联系人";
    
    TCGetIntimateFriendsDic *params = [TCGetIntimateFriendsDic dictionary];
    
    [params setParamReqnum:_Reqnum];
    
    if (![[self qZoneOAuth] getIntimateFriends:params])
    {
        [self showInvalidTokenOrOpenIDMessage];
    }
}
 */

/**
 * logout
 */
- (void)onClickLogout
{
    [[self qZoneOAuth] logout:nil];
}

/*
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    TCSetUserHeadpic *params = [TCSetUserHeadpic dictionary];
    params.paramImage = image;
    params.paramFileName = @"make";
    UIViewController *headController = nil;
    
    [self dismissModalViewControllerAnimated:NO];
    
    
    if(NO == [_tencentOAuth setUserHeadpic:params andViewController:&headController]){
        [self showInvalidTokenOrOpenIDMessage];
    }
    
    if (headController)
    {
        [self presentModalViewController:headController animated:YES];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
 */



/**
 * Called when the user successfully logged in.
 */

#pragma mark tencentDidLogin

- (void)tencentDidLogin {
	// 登录成功
    if ([self qZoneOAuth].accessToken && 0 != [[self qZoneOAuth].accessToken length]) {
        
        if (_isAuthLogin) {
            self.authLoginResult (YES,NO,@"登录成功");
        }
        else {
            [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
            // 获取用户信息
            [self onClickGetUserInfo];
        }
    }
    else {
        if (_isAuthLogin) {
            self.authLoginResult (NO,NO,@"登录失败");
        }
        else {
//            self.getUserInfoResult(NO,nil);
        }
    }

}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled) {
        // 用户取消登录
        if (_isAuthLogin) {
            self.authLoginResult (NO,YES,@"登录取消");
        }
        else {
//            ShareUserInfo *tempInfo = [[ShareUserInfo alloc] init];
//            tempInfo.isSelectedCancelBtn = YES;
//            self.getUserInfoResult(NO,tempInfo);
        }
	}
	else {
        // 登录失败
        if (_isAuthLogin) {
            self.authLoginResult (NO,NO,@"登录失败");
        }
        else {
//            self.getUserInfoResult(NO,nil);
        }
	}
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
    //	无网络连接，请设置网络
    if (_isAuthLogin) {
        self.authLoginResult (NO,NO,@"无网络连接，请设置网络");
    }
    else {
//        self.getUserInfoResult(NO,nil);
    }
}

#pragma mark <TencentSessionDelegate>
/**
 * Called when the logout.
 */

- (void)tencentDidLogout
{
}
/**
 * Called when the get_user_info has response.
 */

#pragma mark getUserInfoResponse
- (void)getUserInfoResponse:(APIResponse*) response {
    
	if (response.retCode == URLREQUEST_SUCCEED) {
        
		NSMutableString *str = [NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
        NSLog(@"str = %@",str);
//        NSLog(@"response.jsonResponse = %@",response.jsonResponse);

        ShareUserInfo *userInfo = [[ShareUserInfo alloc] init];
        [userInfo setUid:[self tencentOAuth].openId];
        [userInfo setNickname:[response.jsonResponse objectForKey:@"nickname"]];
        [userInfo setIcon:[response.jsonResponse objectForKey:@"figureurl_2"]];
        if ([[response.jsonResponse objectForKey:@"gender"] isEqualToString:@"男"]) {
            [userInfo setGender:0];
        }
        else {
            [userInfo setGender:1];
        } 
        
//        self.getUserInfoResult(YES,userInfo);
	}
	else {
        [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
//        self.getUserInfoResult(NO,nil);
	}
}

/**
 * Called when the add_share has response.
 */
- (void)addShareResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
        self.publishContentResult (ShareTypeQQSpace,YES);
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}		
		
		
	}
	else {
        
        self.publishContentResult (ShareTypeQQSpace,NO);

	}
	
}
/**
 * Called when the uploadPic has response.
 */
- (void)uploadPicResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	else {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
}

/**
 * Called when the getListAlbum has response.
 */
-(void)getListAlbumResponse:(APIResponse*) response {
	NSMutableString *str=[NSMutableString stringWithFormat:@""];
	for (id key in response.jsonResponse) {
		[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
	}
	
	
	if (response.retCode == URLREQUEST_SUCCEED)
	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
	
    NSString *albumId = nil;
    NSArray *albumList = [response.jsonResponse objectForKey:@"album"];
    for (NSDictionary *albumDict in albumList)
    {
        NSNumber *picNum = [albumDict objectForKey:@"picnum"];
        albumId = [albumDict objectForKey:@"albumid"];
        if (albumId && [picNum integerValue] > 0)
        {
            break;
        }
    }
    
    if ([albumId length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:albumId forKey:kUserDefaultKeyListAlbumId];
    }
}

/**
 * Called when the getListPhoto has response.
 */
-(void)getListPhotoResponse:(APIResponse*) response {
	NSMutableString *str=[NSMutableString stringWithFormat:@""];
	for (id key in response.jsonResponse) {
		[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
	}
	
	if (response.retCode == URLREQUEST_SUCCEED)
	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[[NSString stringWithFormat:@"%@",str] decodeUnicode]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
}

/**
 * Called when the addTopic has response.
 */
-(void)addTopicResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
}

/**
 * Called when the checkPageFans has response.
 */
-(void)checkPageFansResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
        /*
		if ([[NSString stringWithFormat:@"%@",[response.jsonResponse objectForKey:@"isfans"]] isEqualToString:@"1"]) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您是冷兔的粉丝" message:[NSString stringWithFormat:@"%@",str]
								  
														   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
			[alert show];
            [alert release];
		}
		else
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您不是冷兔的粉丝" message:[NSString stringWithFormat:@"%@",str]
								  
														   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
			[alert show];
            [alert release];
		}
         */
	}
	else
    {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	
}
/**
 * Called when the addAlbum has response.
 */


- (void)addAlbumResponse:(APIResponse*) response{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}		
		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
        
        NSString *albumId = [response.jsonResponse objectForKey:@"albumid"];
        if ([albumId length] > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:albumId forKey:kUserDefaultKeyListAlbumId];
        }
		
	}
	else {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	
}

/**
 * Called when the addOneBlog has response.
 */
- (void)addOneBlogResponse:(APIResponse*) response{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		
		
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//		[alert release];
	}
	else
    {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
}

/**
 *Called when the setUserHeadPic has response.
 */
- (void)setUserHeadpicResponse:(APIResponse *)response
{
    if (nil == response)
    {
        return;
    }
    
    if (URLREQUEST_FAILED == response.retCode
        && kOpenSDKErrorUserHeadPicLarge == response.detailRetCode)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"您的图片大小超标啦，请更换一张试试呢:)"]
//                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//        
//        [alert show];
//        [alert release];
    }
}


/**
 * Called when the getVipInfo has response.
 */
- (void)getVipInfoResponse:(APIResponse *)response
{
	if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode) {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
            NSLog(@"errMsg = %@",errMsg);
        }
	}
	
//	_labelTitle.text=@"拉取基本会员信息完成";
}

/**
 * Called when the getVipRichInfo has response.
 */
- (void)getVipRichInfoResponse:(APIResponse *)response
{
	if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//		[alert release];
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        NSLog(@"errMsg = %@",errMsg);
	}
	
//	_labelTitle.text=@"拉取详细会员信息完成";
}


/**
 * Called when the matchNickTips has response.
 */
- (void)matchNickTipsResponse:(APIResponse*) response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        NSLog(@"errMsg = %@",errMsg);
	}
	
//	_labelTitle.text=@"拉取微博好友提示完成";
}

/**
 * Called when the getIntimateFriends has response.
 */
- (void)getIntimateFriendsResponse:(APIResponse*) response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
	}
	else
    {
        NSString *errMsg = @"网络异常";
        if (URLREQUEST_SUCCEED == response.retCode)
        {
            errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, response.jsonResponse];
        }
        NSLog(@"errMsg = %@",errMsg);
	}
	
//	_labelTitle.text=@"拉取微博最近联系人完成";
}

/**
 * Called when the sendStory has response.
 */
- (void)sendStoryResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
	}
	else
    {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        NSLog(@"errMsg = %@",errMsg);
	}
	
//	_labelTitle.text=@"sendStory操作完成";
}

- (void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController
{
    
//    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
