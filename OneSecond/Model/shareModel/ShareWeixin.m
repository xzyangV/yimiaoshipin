//
//  ShareWeixin.m
//  Up
//
//  Created by zhangyx on 13-4-27.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "ShareWeixin.h"
#import "AppKeyDefine.h"

@interface ShareWeixin ()  <WXApiDelegate>
{
    enum WXScene _scene; // 会话 WXSceneSession 朋友圈WXSceneTimeline
    UIImage *shareThumbImage;
}
//@property (nonatomic,copy) GetUserInfoEventHandler authLoginBlock;
@property (nonatomic,copy) SNSPayBlock payHandler;
@property (nonatomic,copy) PublishContentEventHandler publishContentResult;

//@property (nonatomic,strong) NSString *openid;

@end


@implementation ShareWeixin

static ShareWeixin *shareWeixin;
+ (ShareWeixin *)weixinInstance
{
    if (shareWeixin == nil) {
        shareWeixin = [[ShareWeixin alloc] init];
        
    }
    return shareWeixin;
}

- (BOOL)connectWeixinWithAppID:(NSString *)appid
{
    //向微信注册
    return [WXApi registerApp:kAppID_weixin withDescription:@"uper"];
//    if () {
//        return [WXApi isWXAppInstalled];
//    }
//    return  NO;
}


//- (void)wechatAuthLogin:(UIViewController *)controller block:(GetUserInfoEventHandler)completedBlock
//{
//    self.authLoginBlock = completedBlock;
//    SendAuthReq *req = [[SendAuthReq alloc] init];
//    req.scope = @"snsapi_userinfo";
//    req.state = [PublicObject generateNoLineUUID];
//    req.openID = kAppID_weixin;
//    [WXApi sendAuthReq:req viewController:controller delegate:self];
////    if (![WXApi sendAuthReq:req viewController:controller delegate:self]) {
////        if (self.authLoginBlock) {
////            self.authLoginBlock (NO,nil);
////        }
////    }
//}

- (void)showSessionShareWithContent:(ShareContent *)content
                             result:(PublishContentEventHandler)result {
    
    if (!content) {
        if (result) {
            result (ShareTypeWeixiSession,NO);
        }
        return;
    }
    _scene = WXSceneSession;
    self.publishContentResult = result;
    if ([content mediaType] == PublishContentMediaTypeText) {
        
        [self sendTextContent:[content content]];
    }
    else if ([content mediaType] == PublishContentMediaTypeImage) {
        
        [self sendImageContent:content];
    }
    else if ([content mediaType] == PublishContentMediaTypeVideo) {
        // 视频
        UIImage *shareThumImg = nil;
        if (content.thumbImage || content.thumbImageData) {
            shareThumImg = content.thumbImage ? : [UIImage imageWithData:content.thumbImageData];
        }
        [self sendVideoContentWithTitle:content.title
                            description:content.desc
                             thumbImage:shareThumImg
                               videoUrl:content.url];
    }
    else if ([content mediaType] == PublishContentMediaTypeNews) {
        // 新闻体
        UIImage *shareThumImg = nil;
        if (content.thumbImage || content.thumbImageData) {
            shareThumImg = content.thumbImage ? : [UIImage imageWithData:content.thumbImageData];
        }
        [self sendNewsContentWithTitle:content.title
                           description:content.desc
                            thumbImage:shareThumImg
                            webPageUrl:content.url];
    }
}

- (void)showTimeLineShareWithContent:(ShareContent *)content
                              result:(PublishContentEventHandler)result
{
    if (!content) {
        if (result) {
            result (ShareTypeWeixiTimeline,NO);
        }
        return;
    }
    _scene = WXSceneTimeline;
    self.publishContentResult = result;
    if ([content mediaType] == PublishContentMediaTypeText) {
        [self sendTextContent:[content content]];
    }
    else if ([content mediaType] == PublishContentMediaTypeImage) {
        [self sendImageContent:content];
    }
    else if ([content mediaType] == PublishContentMediaTypeVideo) {
        // 视频
        [self sendVideoContentWithTitle:content.desc
                            description:content.desc
                             thumbImage:content.thumbImage
                               videoUrl:content.url];
    }
    else if ([content mediaType] == PublishContentMediaTypeNews) {
        // 新闻体
        [self sendNewsContentWithTitle:content.title
                           description:content.desc
                            thumbImage:content.thumbImage
                            webPageUrl:content.url];
    }
}


- (BOOL)handleOpenUrl:(NSURL *)url
{
    
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void)wechatPay:(PayReq *)payObject
           result:(SNSPayBlock)completedBlock
{
    self.payHandler = completedBlock;
    //调起微信支付
//    payObject.package = @"Sign=WXPay";
    
    if (![WXApi sendReq:payObject]) {
        if (self.payHandler) {
            self.payHandler (NO,NO,UPLocStr(@"wechat pay failed"));
        }
    }
}


- (void)setThumbImage:(UIImage *)thumbImage
{
    shareThumbImage = thumbImage;
}


#pragma mark -
#pragma mark WXApiDelegate

- (void)onReq:(BaseReq *)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]]) {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        //显示微信传过来的内容
        /*
         ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
         WXMediaMessage *msg = temp.message;
         
         WXAppExtendObject *obj = msg.mediaObject;
         */
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]]) {
        //从微信启动App
    }
    else if ([req isKindOfClass:[SendAuthReq class]]) {
        // 微信登录
//        SendAuthReq *authReq = (SendAuthReq *)req;
//        NSLog(@"authReq openid = %@",authReq.openID);
//        self.openid = authReq.openID;
    }
}

// 发送媒体消息结果返回
- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        /*
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];
         */
        ShareType shareType;
        if (_scene == WXSceneSession) {
            shareType = ShareTypeWeixiSession;
        }
        else if (_scene == WXSceneTimeline) {
            shareType = ShareTypeWeixiTimeline;
        }
        else {
            shareType = 0;
        }
        if (resp.errCode == WXSuccess) {
            self.publishContentResult(shareType,YES);
        }
        else {
            self.publishContentResult(shareType,NO);
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        
//        if (resp.errCode == WXSuccess) {
//            SendAuthResp *authResp = (SendAuthResp *)resp;
//            NSString *fetchUserInfoPath = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kAppID_weixin,kAppSecret_weixin,authResp.code];
//            [UPNetworkManager notUPServerRequesPath:fetchUserInfoPath parameters:nil completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"responseObject = %@",responseObject);
//                NSString *openID = [responseObject objectForKey:@"openid"];
//                ShareUserInfo *userInfo = nil;
//                BOOL isSuccess = NO;
//                if (![PublicObject isEmpty:openID]) {
//                    userInfo = [[ShareUserInfo alloc] init];
//                    userInfo.uid = openID;
//                    isSuccess = YES;
//                }
//                if (self.authLoginBlock) {
//                    self.authLoginBlock (isSuccess,userInfo);
//                }
//            } errorHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
//                if (self.authLoginBlock) {
//                    self.authLoginBlock (NO,nil);
//                }
//            }];
//        }
//        else {
//            if (self.authLoginBlock) {
//                self.authLoginBlock (NO,nil);
//            }
//        }
//    }
//    else if([resp isKindOfClass:[PayResp class]]){
//        NSString *errstr = UPLocStr(@"wechat pay failed");
//        if (resp.errCode == WXErrCodeUserCancel) {
//            errstr = UPLocStr(@"pay cancel");
//        }
//        else if (resp.errCode == WXSuccess) {
//            errstr = UPLocStr(@"pay success");
//        }
//        if (self.payHandler) {
//            self.payHandler ((resp.errCode == WXSuccess),(resp.errCode == WXErrCodeUserCancel),errstr);
//        }
//    }
}
}

#pragma mark
#pragma mark  send content

- (void)sendImageContent:(ShareContent *)shareContent
{
    
    // 发送内容给微信  分享到微信朋友圈  文字和图片 只能选其一 缩略图不能大于32k
    
    // 分享到微信朋友圈
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = shareContent.shareImageData ? : UIImagePNGRepresentation(shareContent.shareImage);
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:shareContent.thumbImage];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    if (![WXApi sendReq:req]) {
        ShareType shareType;
        if (_scene == WXSceneSession) {
            shareType = ShareTypeWeixiSession;
        }
        else if (_scene == WXSceneTimeline) {
            shareType = ShareTypeWeixiTimeline;
        }
        else {
            shareType = 0;
        }
        self.publishContentResult(shareType,NO);
    }
    
    /*
     WXImageObject *ext = [WXImageObject object];
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"commentWorksBg" ofType:@"png"];
     ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
     
     
     WXMediaMessage *message = [WXMediaMessage message];
     [message setThumbImage:[UIImage imageNamed:@"commentWorksBg.png"]];
     message.mediaObject = ext;
     
     SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
     req.bText = NO;
     req.message = message;
     req.scene = _scene;
     
     [WXApi sendReq:req];
     */
}

- (void) RespImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res2" ofType:@"jpg"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    if (![WXApi sendReq:req]) {
        ShareType shareType;
        if (_scene == WXSceneSession) {
            shareType = ShareTypeWeixiSession;
        }
        else if (_scene == WXSceneTimeline) {
            shareType = ShareTypeWeixiTimeline;
        }
        else {
            shareType = 0;
        }
        self.publishContentResult(shareType,NO);
    }
}

-(void) RespTextContent:(NSString *)nsText
{
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.text = nsText;
    resp.bText = YES;
    
    [WXApi sendResp:resp];
}


- (void)sendNewsContentWithTitle:(NSString *)title
                     description:(NSString *)des
                      thumbImage:(UIImage *)thumbImage
                      webPageUrl:(NSString *)urlStr
{
    // 分享新闻体到朋友圈显示的时候只显示标题不显示介绍
    WXMediaMessage *message = [WXMediaMessage message];
    if (![title isEqualToString:@""] && title) {
        message.title = title;
    }
    if (![des isEqualToString:@""] && des) {
        message.description = des;
        if (_scene == WXSceneTimeline) {
            message.title = des;
        }
    }
    [message setThumbImage:thumbImage];

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlStr;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    if (![WXApi sendReq:req]) {
        ShareType shareType;
        if (_scene == WXSceneSession) {
            shareType = ShareTypeWeixiSession;
        }
        else if (_scene == WXSceneTimeline) {
            shareType = ShareTypeWeixiTimeline;
        }
        else {
            shareType = 0;
        }
        self.publishContentResult(shareType,NO);
    }
}

-(void) RespNewsContent
{
    NSLog(@"RespNewsContent");
    /*
     WXMediaMessage *message = [WXMediaMessage message];
     message.title = @"麦当劳“销售过期食品”其实不是卫生问题";
     message.description = @"3.15晚会播出当晚，麦当劳该店所在辖区的卫生、工商部门就连夜登门调查，并对腾讯财经等媒体公布初步结果；而尽管未接到闭店处罚通知，麦当劳中国总部还是在发布道歉声明后暂停了该店营业。\
     \
     不得不承认，麦当劳“销售过期食品”固然是事实，但这个“过期”仅仅是他们自己定义的过期，普通中国家庭也不会把刚炸出来30分钟的鸡翅拿去扔掉。麦当劳在食品卫生上的严格程度，不仅远远超出了一般国内企业，而且也超出了一般中国民众的心理预期和生活想象。大多数人以前并不知道，麦当劳厨房的食品架上还有计时器，辣鸡翅等大多数食品存放半个小时之后，按规定就应该扔掉。也正因如此，甚至有网友认为央视3.15晚会的曝光是给麦当劳做的软广告。\
     \
     央视视频中反映的情况，除了掉到地上的的食品未经任何处理继续加工显得很过分外，其它的问题都源于麦当劳自己制定的标准远远超出了国内一般快餐店的标准。比如北京市卫生监督所相关负责人介绍，麦当劳内部要求熟菜在70℃环境下保存2小时，是为了保存食品风味，属于企业内部卫生规范。目前的检查结果显示，麦当劳的保温盒温度在93℃，但在这种环境下保存的熟菜即便超过2小时，对公众也没有危害。也就是说麦当劳的一些保持时间标准是基于保持其食品的独特风味的要求，并非食品发生变质可能损害消费者身体健康的标准，麦当劳这家门店超时存放食品的行为，违反的是企业制定的内部标准，并不违反食品安全规定，政府应该依据法律法规来监管食品卫生，而不是按照食品公司自己制定的标准，从这个角度来看，麦当劳在食品卫生上没有责任（除了使用掉在地上的食物）。…[详细]\
     \
     但三里屯麦当劳的行为确实违背了诚信\
     麦当劳的内部卫生规定虽然并未被作为卖点进行宣扬，但洋快餐在中国是便捷和卫生的代名词，却是不争的事实。谁也不是活雷锋，麦当劳制定的严苛内部标准，为的是树立自己的品牌优势，进而在市场定位上取得明显的价格优势，或者说让自己“贵得有理由”。但如果他的员工在执行上不能贯彻这一企业标准，相对于其价格水平而言，就有欺诈和损害消费者权益之嫌，这也是不言而喻的。从这个意义上来说，央视曝光麦当劳的问题并无不妥，麦当劳至少涉嫌消费欺诈，因为它没有向消费者提供它向人们承诺的标准的食品。也就是说，工商部门而非食品卫生监管部门约谈麦当劳，也并非师出无名。";
     [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
     
     WXWebpageObject *ext = [WXWebpageObject object];
     ext.webpageUrl = @"http://view.news.qq.com/zt2012/mdl/index.htm";
     
     message.mediaObject = ext;
     
     GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
     resp.message = message;
     resp.bText = NO;
     
     [WXApi sendResp:resp];
     */
}

-(void)sendVideoContentWithTitle:(NSString *)title
                     description:(NSString *)des
                      thumbImage:(UIImage *)thumbImage
                        videoUrl:(NSString *)videoUrlStr
{
    // 分享视频到朋友圈显示的时候只显示标题不显示介绍
    WXMediaMessage *message = [WXMediaMessage message];
    if (![title isEqualToString:@""] && title) {
        message.title = title;
    }
    if (![des isEqualToString:@""] && des) {
        message.description = des;
        if (_scene == WXSceneTimeline) {
            message.title = des;
        }
    }
    message.description = des;
    [message setThumbImage:thumbImage];

    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoUrlStr;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    if (![WXApi sendReq:req]) {
        ShareType shareType;
        if (_scene == WXSceneSession) {
            shareType = ShareTypeWeixiSession;
        }
        else if (_scene == WXSceneTimeline) {
            shareType = ShareTypeWeixiTimeline;
        }
        else {
            shareType = 0;
        }
        self.publishContentResult(shareType,NO);
    }
    
    /*
     WXMediaMessage *message = [WXMediaMessage message];
     message.title = @"步步惊奇";
     message.description = @"只能说胡戈是中国广告界的一朵奇葩！！！这次真的很多人给跪了、、、";
     [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
     
     WXVideoObject *ext = [WXVideoObject object];
     ext.videoUrl = @"http://www.tudou.com/programs/view/6vx5h884JHY/?fr=1";
     
     message.mediaObject = ext;
     
     SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
     req.bText = NO;
     req.message = message;
     req.scene = _scene;
     
     [WXApi sendReq:req];
     */
}

-(void) RespVideoContent
{
    NSLog(@"RespVideoContent");
    /*
     WXMediaMessage *message = [WXMediaMessage message];
     message.title = @"步步惊奇";
     message.description = @"只能说胡戈是中国广告界的一朵奇葩！！！这次真的很多人给跪了、、、";
     [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
     
     WXVideoObject *ext = [WXVideoObject object];
     ext.videoUrl = @"http://www.tudou.com/programs/view/6vx5h884JHY/?fr=1";
     
     message.mediaObject = ext;
     
     GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
     resp.message = message;
     resp.bText = NO;
     
     [WXApi sendResp:resp];
     */
}


-(void) sendMusicContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"五月天<后青春期的诗>";
    message.description = @"人群中哭着你只想变成透明的颜色\
    你再也不会梦或痛或心动了\
    你已经决定了你已经决定了\
    你静静忍着紧紧把昨天在拳心握着\
    而回忆越是甜就是越伤人\
    越是在手心留下密密麻麻深深浅浅的刀割\
    你不是真正的快乐\
    你的笑只是你穿的保护色\
    你决定不恨了也决定不爱了\
    把你的灵魂关在永远锁上的躯壳\
    这世界笑了于是你合群的一起笑了\
    当生存是规则不是你的选择\
    于是你含着眼泪飘飘荡荡跌跌撞撞地走着\
    你不是真正的快乐\
    你的笑只是你穿的保护色\
    你决定不恨了也决定不爱了\
    把你的灵魂关在永远锁上的躯壳\
    你不是真正的快乐\
    你的伤从不肯完全的愈合\
    我站在你左侧却像隔着银河\
    难道就真的抱着遗憾一直到老了\
    然后才后悔着\
    你不是真正的快乐\
    你的笑只是你穿的保护色\
    你决定不恨了也决定不爱了\
    把你的灵魂关在永远锁上的躯壳\
    你不是真正的快乐\
    你的伤从不肯完全的愈合\
    我站在你左侧却像隔着银河\
    难道就真的抱着遗憾一直到老了\
    你值得真正的快乐\
    你应该脱下你穿的保护色\
    为什么失去了还要被惩罚呢\
    能不能就让悲伤全部结束在此刻\
    重新开始活着";
    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
    
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D";
    ext.musicDataUrl = @"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespMusicContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"五月天<后青春期的诗>";
    message.description = @"人群中哭着你只想变成透明的颜色\
    你再也不会梦或痛或心动了\
    你已经决定了你已经决定了\
    你静静忍着紧紧把昨天在拳心握着\
    而回忆越是甜就是越伤人\
    越是在手心留下密密麻麻深深浅浅的刀割\
    你不是真正的快乐\
    你的笑只是你穿的保护色\
    你决定不恨了也决定不爱了\
    把你的灵魂关在永远锁上的躯壳\
    这世界笑了于是你合群的一起笑了\
    当生存是规则不是你的选择\
    于是你含着眼泪飘飘荡荡跌跌撞撞地走着\
    你不是真正的快乐\
    你的笑只是你穿的保护色\
    你决定不恨了也决定不爱了\
    把你的灵魂关在永远锁上的躯壳\
    你不是真正的快乐\
    你的伤从不肯完全的愈合\
    我站在你左侧却像隔着银河\
    难道就真的抱着遗憾一直到老了\
    然后才后悔着\
    你不是真正的快乐\
    你的笑只是你穿的保护色\
    你决定不恨了也决定不爱了\
    把你的灵魂关在永远锁上的躯壳\
    你不是真正的快乐\
    你的伤从不肯完全的愈合\
    我站在你左侧却像隔着银河\
    难道就真的抱着遗憾一直到老了\
    你值得真正的快乐\
    你应该脱下你穿的保护色\
    为什么失去了还要被惩罚呢\
    能不能就让悲伤全部结束在此刻\
    重新开始活着";
    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D";
    ext.musicDataUrl = @"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3";
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}


#define BUFFER_SIZE 1024 * 100
- (void) sendAppContent
{
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这是App消息";
    message.description = @"你看不懂啊， 看不懂啊， 看不懂！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>test</xml>";
    ext.url = @"http://www.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"这是App消息";
    message.description = @"你看不懂啊， 看不懂啊， 看不懂！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>test</xml>";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendNonGifContent
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res1thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespNonGifContent{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res1thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendGifContent
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespGifContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) RespEmoticonContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    WXEmoticonObject *ext = [WXEmoticonObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res2" ofType:@"jpg"];
    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}




@end
