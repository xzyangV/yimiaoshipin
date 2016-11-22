//
//  ShareQQ.m
//  Up
//
//  Created by zhangyx on 13-4-27.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "ShareQQ.h"

@interface ShareQQ () <QQApiInterfaceDelegate,TencentSessionDelegate> {
    
}

@property (nonatomic,strong) QQApiObject *qqApiObject;
@property (nonatomic,assign) ShareType shareType;
@property (nonatomic,strong) ShareContent *shareContent;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@property (nonatomic,copy) PublishContentEventHandler publishContentResult;

@end

@implementation ShareQQ

static ShareQQ *qqInstace;
+ (ShareQQ *)QQInstance
{
    if (qqInstace == nil) {
        qqInstace = [[ShareQQ alloc] init];
    }
    return qqInstace;
}

- (void)connectQQWithAppID:(NSString *)appid
{
	TencentOAuth *tempAuth = [[TencentOAuth alloc] initWithAppId:appid
                                                     andDelegate:self];
    self.tencentOAuth = tempAuth;
}

- (void)showShareWithContent:(ShareContent *)content
                   shareType:(ShareType)shareType
                      result:(PublishContentEventHandler)result
{
    self.publishContentResult = result;
    self.shareContent = content;
    self.shareType = shareType;
    if ([content mediaType] == PublishContentMediaTypeText) {
        
        [self onShareText];
    }
    else if ([content mediaType] == PublishContentMediaTypeImage) {
        
        [self onShareImage];
    }
    else if ([content mediaType] == PublishContentMediaTypeNews) {
        [self onShareNewsLocal];
    }
    else {
        
    }
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)self];
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

#pragma mark
#pragma mark  share to qq methods


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    if (sendResult != EQQAPISENDSUCESS) {
        switch (sendResult)
        {
            case EQQAPIAPPNOTREGISTED:
            {
                NSLog(@"App未注册");
                break;
            }
            case EQQAPIMESSAGECONTENTINVALID:
            case EQQAPIMESSAGECONTENTNULL:
            case EQQAPIMESSAGETYPEINVALID:
            {
                NSLog(@"发送参数错误");
                break;
            }
            case EQQAPIQQNOTINSTALLED:
            {
                NSLog(@"未安装手Q");
                break;
            }
            case EQQAPIQQNOTSUPPORTAPI:
            {
                NSLog(@"API接口不支持");
                break;
            }
            case EQQAPISENDFAILD:
            {
                NSLog(@"发送失败");
                break;
            }
            case EQQAPIQZONENOTSUPPORTTEXT:
            {
                NSLog(@"空间分享不支持纯文本分享，请使用图文分享");
                break;
            }
            case EQQAPIQZONENOTSUPPORTIMAGE:
            {
                NSLog(@"空间分享不支持纯图片分享，请使用图文分享");
                break;
            }
            default:
            {
                break;
            }
        }
        
        self.publishContentResult (ShareTypeQQ,NO);
    }
}

- (void)sendMsgWithType:(ShareType)sendType
{
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
    QQApiSendResultCode sent = 0;
    if (sendType == ShareTypeQQSpace) {
        //分享到QZone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    else if (sendType == ShareTypeQQ) {
        //分享到QQ
        sent = [QQApiInterface sendReq:req];
    }
    else {
    }
    [self handleSendResult:sent];
}

- (void)onShareText
{
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:self.shareContent.content ? : @""];
    // 1 直接分享到qq空间 2 不显示分享到qq空间
    [txtObj setCflag:0];
    self.qqApiObject = txtObj;
    // 发送消息
    [self sendMsgWithType:self.shareType];
}

- (void)onShareImage
{
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:[self.shareContent shareImageData]
                                               previewImageData:[self.shareContent thumbImageData]
                                                          title:self.shareContent.title ? : @""
                                                    description:self.shareContent.desc ? : @""];
    [imgObj setCflag:0];
    self.qqApiObject = imgObj;
    
    // 发送消息
    [self sendMsgWithType:self.shareType];
}

- (void)onShareNewsLocal
{
    NSData *thumbImgData = nil;
    if (self.shareContent.thumbImageData || self.shareContent.thumbImage) {
        thumbImgData = self.shareContent.thumbImageData ? :UIImagePNGRepresentation(self.shareContent.thumbImage);
    }
    NSString *utf8String = self.shareContent.url;
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                        title:self.shareContent.title ? : @""
                                                  description:self.shareContent.desc ? : @""
                                             previewImageData:thumbImgData];
    [newsObj setCflag:0];
    self.qqApiObject = newsObj;
    // 发送消息
    [self sendMsgWithType:self.shareType];
}

- (void)onShareNewsWeb
{
    NSString *utf8String = self.shareContent.imagePath;
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                        title: self.shareContent.title
                                                  description: self.shareContent.desc
                                              previewImageURL:[NSURL URLWithString: @""]];
    [newsObj setCflag:0];
    
    self.qqApiObject = newsObj;
    // 发送消息
    [self sendMsgWithType:self.shareType];
}

- (void)onShareAudio
{
    
    NSData *previewData = nil;
    
    NSString *utf8String = @"";
    
    QQApiAudioObject* audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                           title: @""
                                                     description: @""
                                                previewImageData:previewData];
    [audioObj setPreviewImageURL:[NSURL URLWithString: utf8String? : @""]];
    
    [audioObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
    [audioObj setCflag:0];
    
    self.qqApiObject = audioObj;
    // 发送消息
    [self sendMsgWithType:self.shareType];
}

- (void)onShareVideo
{
    
    NSString *utf8String = @"";
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                           title: @""
                                                     description: @""
                                                previewImageData:nil];
    
    [videoObj setFlashURL:[NSURL URLWithString:utf8String ? : @""]];
    [videoObj setCflag:0];
    
    self.qqApiObject = videoObj;
    // 发送消息
    [self sendMsgWithType:self.shareType];
}

#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req
{
    switch (req.type) {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            NSLog(@"share to qq onResp = %@",sendResp.errorDescription);
            break;
        }
        default:
        {
            break;
        }
    }
    
    self.publishContentResult (ShareTypeQQ,YES);
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
//    NSArray *QQUins = [response allKeys];
//    NSMutableString *messageStr = [NSMutableString string];
//    for (NSString *str in QQUins) {
//        if ([[response objectForKey:str] isEqualToString:@"YES"]) {
//            [messageStr appendFormat:@"QQ号码为:%@ 的用户在线\n",str];
//        } else {
//            [messageStr appendFormat:@"QQ号码为:%@ 的用户不在线\n",str];
//        }
//    }
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:messageStr
//                          
//                                                   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//    [alert show];
//    NSLog(@"response:%@",response);
}

/*
- (NSInteger)GetRandomNumber:(NSInteger)start to:(NSInteger)end
{
    return (NSInteger)(start + (arc4random() % (end - start + 1)));
}

- (void)onCreateOrderNum:(QElement *)sender
{
    if (self.requestQRStr)
    {
        self.requestQRStr.delegate = nil;
        [self.requestQRStr cancel];
        self.requestQRStr = nil;
    }
    
    NSNumber *Billno_Tail = [NSNumber numberWithInteger:[self GetRandomNumber:0 to:9999]];
    NSString *Param = [NSString stringWithFormat:@"attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=19000001094949%@&total_fee=1&ver=2.0", [Billno_Tail stringValue]];
    NSString *ParamMD5 = [NSString stringWithFormat:@"%@&key=8934e7d15453e97507ef794cf7b0519d", Param];
    NSString *url = [NSString stringWithFormat:@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?%@&sign=%@", Param, [[ParamMD5 md5Hash] uppercaseString]];
    NSString *PayIDInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    //@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=190000010949497578&total_fee=1&ver=2.0&sign=2CC44AB13B9FD4131240FCC74AD8E988"] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%s|PayIDInfo:\n%@", __FUNCTION__, PayIDInfo);
    
    NSString *PayID = nil;
    NSRange start = [PayIDInfo rangeOfString:@"<token_id>"];
    if (NSNotFound != start.location)
    {
        PayID = [PayIDInfo substringFromIndex:start.location + start.length];
        NSRange end = [PayID rangeOfString:@"</token_id>"];
        if (NSNotFound != end.location)
        {
            PayID = [PayID substringToIndex:end.location];
        }
        else
        {
            PayID = nil;
        }
    }
    
    NSLog(@"%s|PayID:\n%@", __FUNCTION__, PayID);
    // https://graph.qq.com/vendor/open_qr?d=1234567&sign=3bf68cf5669f2a51a65189dc3c13831f&appid=100442986
    //    APP ID：100442986
    //    APP KEY：40836535e61977a2da874ba3ad09607c
    self.tenpayID = PayID;
    if (PayID)
    {
        NSString *appKey = @"40836535e61977a2da874ba3ad09607c";
        NSString *d = PayID;
        NSString *sign = [[NSString stringWithFormat:@"d=%@&type=%@%@", [d urlEncoded], [@"4" urlEncoded], appKey] md5Hash];
        NSString *appId = @"100442986";
        NSMutableDictionary *reqParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                         @"type": @"4",
                                                                                         @"d": d,
                                                                                         @"sign": sign,
                                                                                         @"appid": appId}];
        self.requestQRStr = [TencentRequest getRequestWithParams:reqParams httpMethod:@"POST" delegate:self requestURL:@"https://graph.qq.com/vendor/open_qr"];
        [self.requestQRStr connect];
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"PayID获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
    }
}

- (void)onQQPay:(QElement *)sender
{
    QQApiPayObject *payObj = [QQApiPayObject objectWithOrderNo:self.tenpayID ? : @""];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:payObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)onOpenWPA:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    QQApiWPAObject *wpaObj = [QQApiWPAObject objectWithUin:self.binding_uin];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)getQQUinOnlineStatues:(QElement *)sender
{
    [self.view endEditing:YES];
    [self.root fetchValueUsingBindingsIntoObject:self];
    
    NSArray *ARR = [NSArray arrayWithObjects:self.binding_uin, nil];
    [QQApiInterface getQQUinOnlineStatues:ARR delegate:self];
}


- (void)showQRCode:(NSString *)qrcode
{
    CGFloat size = self.qrcodeImgView.bounds.size.width;
    UIImage *qrcodeImg = [TCQRCodeGenerator qrImageForString:qrcode imageSize:size];
    
    [self.qrcodeImgView setImage:qrcodeImg];
    [self.qrcodePanel setHidden:NO];
}

- (void)onQRCodePanelClick:(id)sender
{
    if (sender == self.qrcodePanel)
    {
        [sender setHidden:YES];
    }
}

#pragma mark - TencentRequestDelegate
- (void)request:(TencentRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TenpayQR获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [msgbox show];
}

- (void)request:(TencentRequest *)request didLoad:(id)result dat:(NSData *)data
{
    NSString *tenpayUrl = [result objectForKey:@"url"];
    if (tenpayUrl)
    {
        [self showQRCode:tenpayUrl];
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TenpayQR解析失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
    }
}
*/

#pragma mark - TencentLoginDelegate

- (void)tencentDidLogin
{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
}

- (void)tencentDidNotNetWork
{
    
}


@end
