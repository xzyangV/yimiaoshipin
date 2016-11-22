//
//  UPBusinessDefine.h
//  Up
//
//  Created by amy on 13-4-24.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#ifndef Up_UPBusinessDefine_h
#define Up_UPBusinessDefine_h



#endif

#pragma mark ----------<Interface>----------

// 更新检查
static NSString * const kNewUPInterfaceUpdateCheck = @"service_v223.php/version/updatecheck";
// 上传日志
static NSString * const kNewUPInterfaceUploadMessageLog = @"service_v223.php/upload/uplog";
// 搜索用户或者动态时，联想词
static NSString * const kNewUPInterfaceMeetGetSearchAssociateWords = @"service_v240.php/find/getwords";
// up news list
static NSString * const kNewUPInterfaceUPNewsList = @"service_v240.php/upnews/getupnewslist";
static NSString * const kNewUPBeautyAuthInterfaceURL = @"f/user/getBeautyValue";

/*** 动态相关 ***/
static NSString * const kNewUPInterfacePublishSpotNews = @"f/activity/addActivity";
static NSString * const kNewUPInterfaceGetMyUserTimeLine = @"f/activity/getUserActivityList";
static NSString * const kNewUPInterfaceSpotNewsList = @"f/activity/getActivityList";
static NSString * const kNewUPInterfaceSearchSpotNewsWithContent = @"service_v240.php/find/getSearch";
static NSString * const kNewUPInterfaceDeleteDynamic = @"service_v223.php/spot/deleteSpotNews";
static NSString * const kNewUPInterfaceGetSpotNewsById = @"f/activity/getActivity";
static NSString * const kNewUPInterfaceDeleteComment = @"service_v223.php/review/delReview";
static NSString * const kNewUPInterfaceSendComment = @"service_v223.php/review/sendreview";//发表评论
static NSString * const kNewUPInterfaceSendCommentAndPraise = @"u/activity/praiseAndSendReview";//发表评论
static NSString * const kNewUPInterfaceGetReviewList = @"service_v223.php/review/getreviewlist";
static NSString * const kNewUPInterfaceFetchRmdSNObjectList = @"f/activity/getRecommendActivityImages";
static NSString * const kNewUPInterfaceGetSpotNewsShareImage = @"f/activity/getActivityShareImage";
static NSString * const kNewUPInterfaceGetPopupAction = @"f/popup/getPopupList";// 获取弹幕数据
static NSString * const kNewUPInterfaceFetchMagazineList = @"f/activity/getMagazinePage";
static NSString * const kNewUPInterfaceGetMagazineInfo = @"/f/activity/viewMagazineInfo";         // 获取单个杂志
static NSString * const kNewUPInterfaceGetFindObjectList = @"/f/discovery/getInfo";     //获取发现页数据
static NSString * const kNewUPInterfaceDeleteFindUser = @"/f/discovery/deleteRecommendUser";// 发现页删除推荐的人

static NSString * const kNewUPInterfacecancelActivityAward = @"/f/activity/cancelActivityAward";//取消红包动态
static NSString * const kNewUPInterfaceacquireActivityAward = @"u/pay/acquireActivityAward";//领取动态红包
static NSString * const kNewUPInterfacesetMuteNotification = @"/u/info/setMuteNotification";//静音模式
/*** 动态标签 ***/
static NSString * const kNewUPInterfaceAddLabel = @"service_v223.php/label/addlabel";
static NSString * const kNewUPInterfaceGetUserLabelList = @"service_v223.php/label/getuserlabellist";
static NSString * const kNewUPInterfaceGetLabelList = @"service_v223.php/label/getlabellist";
static NSString * const kNewUPInterfaceHotEliteList = @"service_v223.php/list/gethotlist";
static NSString * const kNewUPInterfaceGetSuperUsers = @"/f/user/getSuperUsers";

/*** 用户相关 ***/
static NSString * const kNewUPInterfaceRegister = @"service_v240.php/user/userRegister";
static NSString * const kNewUPInterfaceRegistAccount = @"f/user/registerUser";
static NSString * const kNewUPInterfaceLogin = @"service_v240.php/user/userLogin";
static NSString * const kNewUPInterfaceSnsLogin = @"service_v240.php/user/threeLogin";
static NSString * const kNewUPInterfaceModifyUserInfo = @"service_v223.php/user/userPerfectInfo";
static NSString * const kNewUPInterfaceResetPassword = @"service_v223.php/user/resetPwd";
static NSString * const kNewUPInterfaceSetPayPassword = @"u/pay/setWalletPassword";

/*** 轮询消息相关 ***/
static NSString * const kNewUPInterfaceGetMessagesInfo = @"/f/user/getMessagesInfo";
static NSString * const kNewUPInterfaceGEtMessages = @"/f/user/getMessages";

// 绑定通讯录获取验证码
static NSString * const kNewUPInterfaceGetVerifyCode = @"service_v223.php/phonebook/sendSms";
// 注册获取验证码
static NSString * const kNewUPInterfaceRegisterGetVerifyCode = @"service_v223.php/user/sendSms";
// 忘记密码获取验证码 （手机验证码/邮箱验证码）
static NSString * const kNewUPInterfaceFindPasswordGetVerifyCode = @"service_v223.php/user/findPwd";
// 解除手机绑定获取验证码
static NSString * const kNewUPInterfaceCancelPhoneBindGetVerifyCode = @"service_v223.php/phonebook/sendUnbindPhoneSms";
// 设置支付密码获取验证码
static NSString * const kNewUPInterfaceSendVCodeForWalletPwd = @"u/pay/sendSmsForWalletPassword";
// 绑定通讯录验证码验证
static NSString * const kNewUPInterfacePhoneVerify = @"service_v223.php/phonebook/phoneVerify";
// 解除绑定验证手机验证码
static NSString * const kNewUPInterfaceCancelPhoneCoedeVerify = @"service_v223.php/phonebook/phoneverifyUnbind";
// 注册\忘记密码 手机验证,邮箱验证
static NSString * const kNewUPInterfaceRegisterPhoneVerify = @"service_v223.php/user/phoneVerify";
static NSString * const kNewUPInterfaceUpdateAddressBook = @"service_v223.php/phonebook/uploadPhone";
static NSString * const kNewUPInterfaceUpdateUserRemarkName = @"service_v223.php/friend/addFriendRemark";
static NSString * const kNewUPInterfaceUserRemarkNameList = @"service_v223.php/friend/getFriendRemarkList";
static NSString * const kNewUPInterfacekUploadLoginUserHeadImg = @"service_v223.php/user/uploadThirdHeadImg";
static NSString * const kNewUPInterfaceGetUserInfoByID = @"service_v240.php/user/get_userinfo_byid";
static NSString * const kNewUPInterfaceCheckLoginState = @"service_v223.php/user/getloginuuid";
static NSString * const kNewUPInterfaceSearchUser = @"service_v240.php/user/searchuser";
static NSString * const kNewUPInterfaceUpdateUserLocation = @"service_v223.php/position/updateUserPosition";
static NSString * const kNewUPInterfaceGetAllFriendList = @"service_v240.php/friend/getAllFriendList";
static NSString * const kNewUPInterfaceSAManager = @"service_v223.php/manage/adminmanage";
static NSString * const kNewUPInterfacekRegistRecommendList = @"f/user/getGetRecommendUsers";
static NSString * const kNewUPInterfaceFollowAll = @"service_v223.php/friend/addallfriend";
static NSString * const kNewUPInterfaceGetFollowList = @"f/follow/getFollowList";
static NSString * const kNewUPInterfaceGetWalletInfo = @"u/pay/getWallet";
static NSString * const kNewUPInterfaceGetDetailTransation = @"u/pay/getDealRecorders";
static NSString * const kNewUPInterfacegetActivityDealRecorders = @"/u/pay/getActivityDealRecorders";//动态收益详情
static NSString * const kNewUPInterfaceSpotnewsWXPay = @"u/pay/requestTransferFromWX";
static NSString * const kNewUPInterfaceSpotnewsUPPocketPay = @"u/pay/requestOrder";
static NSString * const kNewUPInterfaceSpotnewsWXWithdrawCash = @"u/pay/requestTransferToWX";
static NSString * const kNewUPInterfaceRechargeWXPay = @"/u/pay/recharge";  //微信充值
static NSString * const kNewUPInterfaceSelectSong = @"/f/system/getMusicInfos";  //选择配乐充值

/*** 地图/附近 **/
static NSString * const kNewUPInterfaceDiscoverPhotoMapList = @"service_v223.php/find/getAround";
static NSString * const kNewUPInterfaceNearbyUserList = @"service_v240.php/find/getarounduser";
static NSString * const kNewUPInterfaceMeetGetArroundUsers = @"/f/user/getArountUsers";
static NSString * const kNewUPInterfaceExploreMap = @"f/activity/getMapActivities";

//榜单
static NSString * const kNewUPInterfaceGetTopConsumeUsers = @"u/pay/getTopConsumeUsers";//消费榜
static NSString * const kNewUPInterfaceGetTopIncomeUsers = @"u/pay/getTopIncomeUsers";//消费榜
/*** 水印相关 ***/
static NSString * const kNewUPInterfaceGetWeather = @"service_v223.php/watermark/getWeather";
static NSString * const kNewUPInterfaceGetWaterMarkListByTime = @"f/watermark/getMarkList";
static NSString * const kNewUPInterfaceUnlockWatermark = @"service_v223.php/watermark/unlockwatermark";
static NSString * const kNewUPInterfaceGetWatermarkById = @"service_v223.php/watermark/getweathernamebyid";
static NSString * const kNewUPInterfaceWatermarkSpotNewsList = @"f/watermark/getActivityImagesByWid";
static NSString * const kNewUPInterfaceWatermarkPackageLis = @"service_v240.php/watermark/getPackageListInfo";
static NSString * const kNewUPInterfaceWatermarkPackageStatistic = @"service_v240.php/watermark/savePackageDown"; // 水印包安装/卸载统计

/*** 消息/推送设置 **/
static NSString * const kNewUPInterfacekSetMsgPush = @"service_v240.php/set/setpushmsg";
static NSString * const kNewUPInterfacekBindingSns = @"service_v223.php/set/bindingSns";
static NSString * const kNewUPInterfacekCacelBindingSns = @"service_v223.php/set/cancelBindingSns";
static NSString * const kNewUPInterfacekUploadSnsFriends = @"service_v223.php/set/uploadSnsFriends";
static NSString * const kNewUPInterfaceFirstIntoUP = @"service_v223.php/user/sendletter";

/*** 活动找玩伴 ***/
static NSString * const kNewUPInterfaceSetActivityMeetStatus = @"f/activity/setActivityMeetState";
static NSString * const kNewUPInterfaceCheckActivityMeetValid = @"f/activity/setActivityUser";
static NSString * const kNewUPInterfaceMeetGetMeetTags = @"service_v240.php/meet/getmeettag";
static NSString * const kNewUPInterfaceMeetGetThemeMeetTag = @"/f/activity/getThemeMeetTag";
static NSString * const kNewUPInterfaceGetThemeMeetInfo = @"f/activity/getThemeMeetActivities";
static NSString * const kNewUPInterfaceGetRecommendMeetActivities = @"/f/activity/getRecommendMeetActivities";

// 废弃不用的
static NSString * const kNewUPInterfaceMeetGetMeetCheckValid = @"service_v240.php/meet/addmeetuser";           // 检查活动过期和统计点击私信人
static NSString * const kNewUPInterfacekChannelList = @"service_v242.php/list/getChannelList";               // 频道列表
static NSString * const kNewUPInterfaceMeetAddMeet = @"service_v240.php/meet/addmeet";                        // 发布活动
static NSString * const kNewUPInterfaceMeetGetMeetList = @"service_v240.php/meet/getmeetlist";                // 获取活动列表
static NSString * const kNewUPInterfaceMeetGetMyMeetList = @"service_v240.php/meet/getmymeetlist";            // 获取我的活动
static NSString * const kNewUPInterfaceMeetDeleteMeet = @"service_v240.php/meet/delmeet";                     // 取消约会
static NSString * const kNewUPInterfaceMeetGetMeetById = @"service_v240.php/meet/getonemeet";                 // 根据活动id获取活动详情

// 话题列表
static NSString * const kNewUPInterfaceGetHotTopics = @"/f/Topic/getHotTopics";                 // 发现页，话题列表
static NSString * const kNewUPInterfacegetTopicCategories = @"/f/topic/getTopicCategories";                 //话题分类列表
static NSString * const kNewUPInterfaceviewTopicCategory = @"/f/topic/viewTopicCategory";                 //话题分类详情


static NSString * const kNewUPInterfaceGetTextTopicList = @"/f/Topic/getTextTopicInfos";                       // 获取文字话题列表
static NSString * const kNewUPInterfaceViewTextTopic = @"/f/Topic/viewTextTopic";               // 文字话题集成页
static NSString * const kNewUPInterfaceSearchTextTopic = @"/f/Topic/findTextTopicInfos";        // 搜索文字话题
static NSString * const kNewUPInterfaceAddTopicComment = @"/f/topic/addTopicComment";//发表对话题的评论
static NSString * const kNewUPInterfaceDeleteTopicComment = @"/f/topic/deleteTopicComment";// 删除话题里的某条评论
static NSString * const kNewUPInterfaceGetTopicComments = @"/f/topic/getTopicComments"; // 获取某个话题的评论列表



// 后台统计添加
static NSString * const kNewUPInterfaceCountingAdd = @"/f/score/add";                       // 后台统计

// 红包相关
static NSString * const kNewUPInterfaceGetOrderAward = @"/u/pay/getOrderAward";        // 私信领取动态赞赏红包
static NSString * const kNewUPInterfaceSendGetPraiseAwardNotify = @"/u/pay/sendGetPraiseAwardNotification";



#define kUPInterfaceSearchElite @"phone.php?m=Elite&a=elite_search"
#define kUPInterfaceFollowList @"phone.php?m=Follow&a=followlist"
#define kUPInterfaceFriendFollowList @"phone.php?m=Follow&a=follow_by_follow"
#define kUPInterfaceUploadChatData @"phone.php?m=public&a=upload_chat_data"
#define kUPInterfaceGetMapSpotNews @"phone.php?m=map&a=map_spot_list"
#define kUPInterfaceGetUserInfoByID @"phone.php?m=One&a=get_userinfo_byid"
#define kUPInterfaceSpotNewsList @"phone.php?m=Elite&a=spotnewsdata"
#define kUPInterfaceNewSpotNewsList @"phone.php?m=Elitenew&a=spotnewsdata"
#define kUPInterfaceSpotNewsPraise @"phone.php?m=Repr&a=praiset"
#define kUPInterfaceWebVideoParse @"phone.php?m=Webvideoparse&a=videoparse"
#define kUPInterfaceEliteList @"phone.php?m=Elite&a=elitedatanew"
#define kUPInterfaceCheckLoginState @"phone.php?m=one&a=get_loginuuid"
#define kUPInterfaceGetCardByID @"phone.php?m=card&a=get_card_byid"                     //通过cardid获取名片（收藏名片页面）
#define kUPInterfaceSendCard @"phone.php?m=card&a=send_business_card"                   //发名片
#define kUPInterfaceCollectCard @"phone.php?m=card&a=collect_business_card"             //收藏名片
#define kUPInterfaceDeleteCard @"phone.php?m=card&a=delete_business_card"               //删除名片
#define kUPInterfaceCardList @"phone.php?m=card&a=business_card_list"                   //名片夹列表
#define kUPInterfaceUserCards @"phone.php?m=card&a=get_card_list_byuid"                 //名片列表(个人的多张名片)
#define kUPInterfaceUpdateCard @"phone.php?m=card&a=up_card"                            //编辑更新名片
#define kUPInterfaceChannelList @"phone.php?m=index&a=channel_list"
#define kUPInterfaceReviews @"phone.php?m=Repr&a=reviews"                               //评论列表（赞，投片，评论）
#define kUPInterfaceDeleteComment @"phone.php?m=Circle&a=delete_comment"                //删除评论
#define kUPInterfacePulishComment @"phone.php?m=Repr&a=new_comment"
#define kUPInterfaceEliteData @"phone.php?m=Elite&a=elitedata"
#define kUPInterfaceMailVerify @"phone.php?m=code&a=mail_verify"                         //获取验证码
#define kUPInterfaceVerifyPost @"phone.php?m=code&a=verify_post"                         //验证信息
#define kUPInterfaceFilterType @"phone.php?m=index&a=filter_type"
#define kUPInterfaceMailPost @"phone.php?m=code&a=mail_post"                             //重新设置密码
#define kUPInterfaceAddBlackList @"phone.php?m=Black&a=add_blacklist"                    //添加禁言
#define kUPInterfaceDelBlackList @"phone.php?m=Black&a=del_blacklist"                    //解除禁言
#define kUPInterfaceGetBlackList @"phone.php?m=Black&a=get_blacklist"                    //获取禁言列表
#define kUPInterfacePraiseList @"phone.php?m=Repr&a=praiuser"                            //赞列表
#define kUPInterfaceRecommend @"phone.php?m=Referee&a=recommend"                         //注册完推荐用户列表
#define kUPInterfaceFollowAll @"phone.php?m=Referee&a=followaddall"                      //全部关注
#define kUPInterfaceReport @"phone.php?m=public&a=report"                                //举报
#define kUPInterfaceResumeShare @"phone.php?m=Resumeinfo&a=share"                        //发送简历
#define kUPInterfaceLogOut @"phone.php?m=Loginout&a=loginout"                            //退出登录
#define kUPInterfaceOneSpotNewsData @"phone.php?m=one&a=onespotnewsdata"
#define kUPInterfaceDeleteDynamic @"phone.php?m=Dynamic&a=del_dynamic"
#define kUPInterfaceGetMyUserTimeLine @"phone.php?m=Dynamic&a=get_user_timeline"
#define kUPInterfaceAddDynamic @"phone.php?m=Dynamic&a=add_dynamic"
#define kUPInterfaceUPQuestion @"phone.php?m=Public&a=up_question"                       //问题反馈
#define kUPInterfaceSmsVerify @"phone.php?m=Sms&a=sms_verify"
#define kUPInterfaceSmsPost @"phone.php?m=Sms&a=sms_post"                                //
#define kUPInterfaceUpdateCheck @"phone.php?m=index&a=update_check"                      //更新检查
#define kUPInterfaceJoinCircleApply @"phone.php?m=Circle&a=is_agree_apply"               //申请加入圈子
#define kUPInterfaceAgreeJoinCircleApply @"phone.php?m=Circle&a=is_agree_join_circle"    //是否同意加入圈子
#define kUPInterfaceFriendVerify @"phone.php?m=Friend&a=friend_verify"
#define kUPInterfaceAdminManage @"phone.php?m=manage&a=admin_manage"
#define kUPInterfaceAllBlackList @"phone.php?m=Black&a=get_allblacklist"                 //所有黑名单（我拉黑的人，和拉黑我的人）
#define kUPInterfaceFollowCancel @"phone.php?m=Follow&a=followcancel"
#define kUPInterfaceFollowAdd @"phone.php?m=Follow&a=followadd"
#define kUPInterfaceFollowListSearch @"phone.php?m=follow&a=follow_search"
#define kUPInterfaceRegister @"phone.php?m=Register&a=index"                             //账号注册
#define kUPInterfaceLogin @"phone.php?m=Register&a=login"                                //应用内账号登录
#define kUPInterfacePerfectUserInfo @"phone.php?m=Register&a=perfectuserinfo"            //更新用户信息
#define kUPInterfaceAddFriend @"phone.php?m=Friend&a=addfriend"                          //加关注（加好友）
#define kUPInterfaceDelFriend @"phone.php?m=Friend&a=delfriend"                          //取消关注
#define kUPInterfaceSetHeadImage @"phone.php?m=Mycircle&a=set_head_img"                  //修改用户头像
#define kUPInterfaceSetUserBgImage @"phone.php?m=Mycircle&a=set_bg_img"                  //修改个人主页背景图片
#define kUPInterfaceUploadAddressBook @"phone.php?m=Public&a=upload_address_book"        //上传通讯录/微博好友
#define kUPInterfacePublicRecommend @"phone.php?m=public&a=recommend"                    //我的里推荐好友
#define kUPInterfacePublickDelFriend @"phone.php?m=Setting&a=delete_friend"              //我的里忽略好友请求
#define kUPInterfaceAddStarFriend @"phone.php?m=follow&a=add_star_friend"                //加星标关注
#define kUPInterfaceDelStarFriend @"phone.php?m=follow&a=del_star_friend"                //取消星标关注
#define kUPInterfaceSettingRecommendFriends @"phone.php?m=Setting&a=recommend_friends"   //设置是否开启好友推荐
#define kUPInterfaceMessageToPush @"phone.php?m=Setting&a=message_to_push"               //推送设置
#define kUPInterfaceVoteResult @"phone.php?m=vote&a=vote_result"                         //获取投票结果
#define kUPInterfaceAddVote @"phone.php?m=vote&a=add_vote"                               //添加投票
#define kUPInterfaceVoteResultUserList @"phone.php?m=vote&a=vote_result_user"            //获取某个选项下 投票人列表

#define kUPInterfaceField @"interface_verson"
#define kUpInterfaceDeviceField @"device_id"

#pragma mark ----------<Typedef Number>----------

// 好友推荐类型
typedef enum
{
    FriendRecommendedTypeNone = 0,            //
    FriendRecommendedTypeUp = 1,              // up 好友
    FriendRecommendedTypeSina = 2,            // 新浪好友推送
    FriendRecommendedTypeTecentWeibo = 3,     // 腾讯微博好友推送
    FriendRecommendedTypeContact = 4,         // 通讯录好友推送
    FriendRecommendedTypeFaceBook = 6,        // facebook 好友推送
    FriendRecommendedTypeTwitter = 7,         // twitter 好友推送
    FriendRecommendedTypeInstagram = 8,       // Instagram 好友推送
}
FriendRecommendedType;

// 提醒消息类型
typedef enum
{
    RemindMessageTypeNone = 0,               //
    RemindMessageTypeComment = 1,            // 评论，赞，系统通知
    RemindMessageTypeDirectMsg = 2,          // 私信
    RemindMessageTypeReferred = 3,            // @ 人
    RemindMessageTypeNearby = 4,             //附近好友发布动态，系统通知
    RemindMessageTypeChat = 5,              // 所有人都可以给我发私信
    RemindMessageTypeLocation = 6           // 是否让我在探索页面的下面列表里出现
}
RemindMessageType;

// 设置消息推送类型
typedef enum
{
    SettingMsgTypeNone = 0,             //
    SettingMsgTypeRmdFriends = 1,              // 好友推荐
    SettingMsgTypeComment = 2,          // 评论，赞，私信，好友动态通知
}
SettingMsgType;

// 是否推送apns 类型定义
typedef enum ApnsPushType {
    ApnsPushTypeNone = 0,
    ApnsPushTypeDirectMsg = 1 << 0,         // 私信
    ApnsPushTypeCommentMsg = 1 << 1,        // 评论，赞，系统消息
    ApnsPushTypeRemindMeMsg = 1 << 2,       // @我消息
    ApnsPushTypeNearbyMsg = 1 << 3,         // 附近好友发动态时通知
    ApnsPushTypeChatMsg = 1 << 4,           //只有互相关的人给我发私信
    ApnsPushTypeLocationMsg = 1 << 5,       //探索页面的列表是否出现我的信息
} ApnsPushType;

// 是否推荐好友 类型定义
typedef enum RmdFriendType {
    RmdFriendTypeNone = 0,
    RmdFriendTypeSinaWeibo = 1 << 0,
    RmdFriendTypeContact = 1 << 1,
    RmdFriendTypeInstagram = 1 << 2,
    RmdFriendTypeFacebook = 1 << 3,
    RmdFriendTypeTwitter = 1 << 4,
} RmdFriendType;

// 是否绑定其他平台 类型定义
typedef enum BindingPlatformType {
    BindingPlatformTypeNone = 0,
    BindingPlatformTypeSinaWeibo = 1 << 0,
    BindingPlatformTypeContact = 1 << 1,
    BindingPlatformTypeInstagram = 1 << 2,
    BindingPlatformTypeFacebook = 1 << 3,
    BindingPlatformTypeTwitter = 1 << 4,
} BindingPlatformType;

// @brief	评论类型
typedef enum
{
    CommentTypeNone = 1, /**< 评论类型为空 */
    CommentTypeNotice = 2, /**< 评论类型为文章：动态，公告，话题等。 */
    CommentTypeComment = 3, /**< 对某一条评论进行评论 */
}
CommentType;


typedef enum
{
    PublishCategorySpotNews,    //发布动态
    PublishCategoryTopic,       //发布话题
} PublishCategory;

// 作品类型
typedef enum {
    PublishDataTypeSample = -1, // 示例
    PublishDataTypeNone = 0,
    PublishDataTypePhoto,
    PublishDataTypeVideo,       // 视频
    PublishDataTypeVideoLink,   // 视频连接
    //    PublishDataTypeMeet,    // 找玩伴
} PublishDataType;

// 作品子类型
typedef enum {
    PublishDataSubTypeNormal = 0,
    PublishDataSubTypeCustomMeet = 1,
    PublishDataSubTypeThemeMeet = 2,
    PublishDataSubTypeAdv = 3,//h5广告,水印，话题
    PublishDataSubTypeMagazine = 4,//普通杂志
    PublishDataSubTypeRmdMagazine = 5,//推荐杂志
    PublishDataSubTypeRmdSpotNews = 6,//推荐动态
    PublishDataSubTypeOneSecondVideo = 7,// 一秒视频
} PublishDataSubType;

// 发布找玩伴类型
typedef enum {
    PublishMeetTypeCustom,  // 自定义找玩伴
    PublishMeetTypeTheme,   // 主题找玩伴
} PublishMeetType;

typedef enum ImageQualityGroup {
    ImageQualityGroupUpload,
    ImageQualityGroupDownload,
    ImageQualityGroupCount
} ImageQualityGroup;

typedef enum ImageQualityType {
    ImageQualityTypeAuto,
    ImageQualityTypeHigh,
    ImageQualityTypeLow,
    ImageQualityTypeCount
} ImageQualityType;

typedef enum : NSUInteger {
    UPTBItemUP,
    UPTBItemNearby,
    UPTBItemRecord,
    UPTBItemMessage,
    UPTBItemMine,
    UPTBItemCount
} UPTBItem;

typedef enum : NSUInteger {
    VideoAutoPreviewTypeAlway,
    VideoAutoPreviewTypeOnlyWifi,
    VideoAutoPreviewTypeNever,
    VideoAutoPreviewTypeCount
} VideoAutoPreviewType;


typedef enum {
    CircleJoinConditionMyFriend = 1,
    CircleJoinConditionElite = 2,
    CircleJoinConditionApply = 4,
    CircleJoinConditionPublic = 5
} CircleJoinConditionType;

//消息数据类型
typedef enum MessageDataType {
    MessageDataTypeText,            //文字
    MessageDataTypeImage,           //图片
    MessageDataTypeVoice,           //声音
    MessageDataTypeVideo,           //视频
    MessageDataTypePostcard,        //名片
    MessageDataTypeLocation,        //位置
    MessageDataTypeFace,            //表情
    MessageDataTypeMeet,            //活动
    MessageDataTypeWorkWallet,      //赞赏
    MessageDataTypeWorkWalletSuccess//赞赏领取成功
} MessageDataType;

//聊天数据选择类型(某一按钮类型)
typedef enum ChatDataTypeSelectType {
    ChatDataTypeSelectTypePicture,      //照片
    ChatDataTypeSelectTypeShoot,        //拍摄
    ChatDataTypeSelectTypePostcard,     //名片
    ChatDataTypeSelectTypeLocation      //位置
} ChatDataTypeSelectType;

//消息数据状态
typedef enum MessageDataState {
    //数据库中保存的状态
    MessageDataStateNormal,         //正常 为消息的最终状态
    MessageDataStateFailed,         //失败 会变成"消息历史发送成功"状态
    //发送消息回执(待定)
    //    MessageDataStateSendDelivered,  //已送达
    //    MessageDataStateSendRead        //已阅读
    
    //新消息未保存数据库之前的状态
    MessageDataStateNew,            //新消息 会变成"新消息发送成功"或"新消息发送失败"状态
    MessageDataStateNewSendFailed,  //新消息发送失败 会变成"失败"状态存至DB (DB INSERT)
    MessageDataStateNewSendSuccess, //新消息发送成功 会变成"正常"状态存至DB (DB INSERT)
    
    MessageDataStateBurned,         //消息已焚毁
    MessageDataStateResend,         //发送失败重新发送
    
    //发送文件相关
    MessageDataStateNewFile,        //新文件消息
    MessageDataStateNewFileSuccess, //文件发送成功
    MessageDataStateNewFileFailed   //文件发送失败
} MessageDataState;

typedef enum MessageFileDownloadState {
    MessageFileDownloadStateNone,
    MessageFileDownloadStateDownloading,
    MessageFileDownloadStateSuccess,
    MessageFileDownloadStateFailed
} MessageFileDownloadState;

//关注类型
typedef enum FollowType {
    FollowTypeNone,
    FollowTypeMutual,       //互相关注
    FollowTypeFollowing,    //我关注
    FollowTypeFollower      //粉丝 关注我
} FollowType;

//关注接口过滤类型
typedef enum FollowFilterType {
    FollowFilterTypeNothing,
    FollowFilterTypeMutual,                 //互相关注
    FollowFilterTypeMutualAndFollowing,     //互相关注和我关注的
    FollowFilterTypeMutualAndFollower,      //互相关注和关注我的
} FollowFilterType;


//up帐号登录类型
typedef enum LoginType {
    LoginTypeEmail = 1,                 // 邮箱
    LoginTypeSina = 2,                  // 新浪
    LoginTypeTecentWeibo = 3,           // 腾讯微博
    LoginTypeQQSpace = 4,               // qq空间
    LoginTypeMobile = 5,                // 手机
    LoginTypeFaceBook = 6,              // facebook登录
    LoginTypeTwitter = 7,               // twitter登录
} LoginType;

//通知类型
typedef enum BizNotificationType {
    BizNtfTypeSysNotification = 1001,               //系统通知
    BizNtfTypeSysUpdate = 1101,                     //系统更新
    
    BizNtfTypeRecommendFriend = 1201,               //推荐关注好友
    BizNtfTypeBlacklist = 1202,                     //黑名单通知
    
    BizNtfTypeNormal = 2200,                        //普通通知消息(通知列表中显示)
    BizNtfTypeInviteJoinClub = 2202,                //邀请加入俱乐部(通知列表)(同意或忽略动作)
    
    BizNtfTypeTopicIsDeleted = 1305,                //话题被别人(群主或其它人)删除
    BizNtfTypeUserExitsClub = 1306,                 //用户退出了俱乐部
    BizNtfTypeUsersToJoinClub = 1307,               //用户加入了俱乐部
    
    BizNtfTypePublishTopic = 1308,                  //发布话题
    BizNtfTypeCommentTopic = 1309,                  //评论话题
    BizNtfTypeCommentNotice = 1310,                 //评论公告
    
    BizNtfTypeEliteAuthenticationSuccess = 1402,    //达人认证成功
    
    BizNtfTypeCommentWorks = 1501,                  //评论动态/作品
    BizNtfTypePraiseWorks = 1502,                   //赞动态/作品
    
    BizNtfTypeNewFollowSpotNews = 1601,             //关注动态
    
    BizNtfTypeNearbySpotNews = 1701,                //附近动态
    BizNtfTypePublishMeet = 1703,                   //发布活动
    
    BizNtfTypeUserLabelChange = 1801,               //用户当前标签变化
    
    BizNtfTypeNewMagazine = 1901,                   //杂志有更新
    
} BizNotificationType;

// apns 点击进入相应页面类型定义
typedef enum {
    UpApnsClickPushTypeNone = 0,
    UpApnsClickPushTypeMsg = 1,                 //消息
    UpApnsClickPushTypeDirectMsg = 2,           //私信
    UpApnsClickPushTypeSpotNews = 3,            //动态
    UpApnsClickPushTypeElite = 4,               //达人
    UpApnsClickPushTypeNews = 5,                //新闻
    UpApnsClickPushTypeHotElite = 6,            //hot榜首
    UpApnsClickPushTypePublishMeet = 7,         //发布活动
    UpApnsClickPushTypeMeetTimeout = 8,         //活动结束
    UpApnsClickPushTypeSwitchToMagzine = 9,     //切换到杂志页 ps：旧版本
    UpApnsClickPushTypeSwitchToFocus = 10,       //焦点页
    UpApnsClickPushTypeMagazineDetail = 11,      //杂志详情 ps：新版本
    UpApnsClickPushTypeReceiveReward = 12,       //领取赏金（xxx领取了你的赏金）
} UpApnsClickPushType;

//// 动态详情页
//typedef enum {
//    PushFromTypeNone,
//    PushFromHomeView,           // 首页推送过来
//    PushFromEliteUserInfo,      // 个人主页推送过来
//	PushFromEliteList,          // 达人列表推送过来
//    PushFromEliteChannelSpot,   // 频道列表
//    PushFromMessageView,        // 消息列表
//    PushFromUpNewsView,         // uper新闻页
//    PushFromPhotoMapView,       // 地图页
//    PushFromChannelSpotView,    // 频道页面（从详情里面点击频道进来的）
//    PushFromEliteUserInfoView,  // 个人主页
//    PushfromNewSearchView,      // 搜索页
//} WorkPushFromType;

typedef enum SoptFollowType{
    MyFollowTypeAll = 0,                //所有,山南海北
    MyFollowTypeNomal = -3,             //关注
    MyFollowTypeStar = -2,              //星标关注
    MyFollowTypeBackgroundFetch = -10
} MyFollowType;

//应用内语言类型
typedef enum : NSInteger {
    UPLanguageTypeNothing,
    UPLanguageTypeZhHans,                 //简体中文
    UPLanguageTypeEnglish,     //英文
} UPLanguageType;

typedef enum : NSUInteger {
    UPGenderMale,       //男
    UPGenderFemale,     //女
    UPGenderOther       //其他
} UPGender;

// 操作类型
typedef enum
{
    OperationTypeAdd = 1,
    OperationTypeDelete = 2,
    OperationTypeUpdate = 3,
}
OperationType;


typedef enum : NSUInteger {
    GenderFilterTypeAll,
    GenderFilterTypeOnlyGuys,
    GenderFilterTypeOnlyGirls,
    GenderFilterTypeCount
} GenderFilterType;

typedef enum : NSUInteger {
    MeetFilterTypeAll,
    MeetFilterTypeOnlyMeet
} MeetFilterType;

typedef enum : NSInteger {
    MeetStatusClose, // 撤销关闭
    MeetStatusOpen, // 开启
    MeetStatusFinish // 结束
} MeetStatus;

// 用户昵称属性
typedef enum : NSInteger{
    UserNamePropertyTypeCustom, // 正常，纯文字
    UserNamePropertyTypeMerchant,// 商家认证
    UserNamePropertyTypeLabel,// 标签
    UserNamePropertyTypeRecommend,//推荐
}UserNamePropertyType;

//// 终端类型
//typedef enum : NSInteger {
//    ClientTypeIphone=0,
//    ClientTypeAndroid=1
//}ClientType;

// 钱包支付类型
typedef enum : NSInteger {
    UPWalletPayTypePassword,
    UPWalletPayTypeFingerprint
}UPWalletPayType;

// 支付平台类型
typedef NS_ENUM(NSInteger, UPPayKindType)
{
    UPPayKindTypeChange,    // 零钱支付
    UPPayKindTypeWechat     // 微信支付
};

// 提现类型类型
typedef NS_ENUM(NSInteger, UPWithdrawCashType)
{
    UPWithdrawCashTypeWechat     // 提现到微信
};


#pragma mark ----------<Block>----------

typedef void (^ExecCompletedBlock) (BOOL isSuccess, NSString *errorStr);
typedef void (^ExecCompletedResultBlock) (BOOL isSuccess, id result, NSString *errorStr);
typedef void (^ExecVoidBlock)();

typedef void (^ExecAlertCompletedResultBlock) (BOOL cancelled, NSInteger buttonIndex);

#pragma mark ----------<Video>----------

#define kRecordVideoCompressRatio AVAssetExportPresetMediumQuality
#define kSelectAlbumVideoCompressRatio AVAssetExportPresetMediumQuality
#define kAlreadySelectVideoExportRatio AVAssetExportPresetHighestQuality

#pragma mark ----------<FilePath/FileName>----------

#define kChannelStatistic @"ChannelStatistic"
#define kMsgSoundName [[NSBundle mainBundle] pathForResource:@"UPMsgSound" ofType:@"caf"]

#define kChatDataRootFile @"ChatData"
#define kChatDataImageFile @"ChatData/Image"
#define kChatDataVoiceFile @"ChatData/Voice"
#define kChatDataVideoFile @"ChatData/Video"
#define kChatDataRootPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kChatDataRootFile)]
#define kChatDataImagePath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kChatDataImageFile)]
#define kChatDataVoicePath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kChatDataVoiceFile)]
#define kChatDataVideoPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kChatDataVideoFile)]


#define kSpotNewsDataFile @"SpotNewsData"
#define kSpotNewsDataPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kSpotNewsDataFile)]

#define kRecordVideoOneSecondDataFile @"oneSecondVideos"
#define kRecordVideoFinishedDataFile @"finishedVideos"
#define kRecordVideoOneSecondDataPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kRecordVideoOneSecondDataFile)]
#define kRecordVideoFinishedDataPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kRecordVideoFinishedDataFile)]


#define kInternationalDataEnFile @"InternationalData/en"
#define kInternationalDataZhHansFile @"InternationalData/zh-Hans"
#define kInternationalDataZhHantFile @"InternationalData/zh-Hant"
#define kInternationalDataJaFile @"InternationalData/ja"
#define kInternationalDataKoFile @"InternationalData/ko"
#define kInternationalDataEnPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kInternationalDataEnFile)]
#define kInternationalDataZhHansPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kInternationalDataZhHansFile)]
#define kInternationalDataZhHantPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kInternationalDataZhHantFile)]
#define kInternationalDataJaPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kInternationalDataJaFile)]
#define kInternationalDataKoPath [[PublicObject systemDocumentPath] stringByAppendingPathComponent:(kInternationalDataKoFile)]

#pragma mark ----------<Number/Rect/Fontsize>----------

#define kDefaultTectecReqnum 30  // 腾讯每页请求个数
#define kDefaultSinaPageNum 50   // 新浪每页请求个数

#define kStayTime 1.0
#define kAllSinaInputCount 140
#define kAllTwitterInputCount 70

#define kSysAudioReceivedMessage 1003
#define kSysAudioSentMessage 1004
#define kSysAudioVoicemail 1315

#define kImagePickerMaxNum 9
#define kBackgroundViewHeight 180//250// 个人主页背景图片高度

#define kFaceKeyboardBgColor ColorForHex(0xeaeaea)
#define kCustomKeyboardHeight 216.0

#define kFaceDefaultHeight 110.0
#define kFaceDefaultWidth 134.0

#define kHomePageNo 1
#define kDefaultPageNum 1

#define kImageCompressionQuality 0.7 //图片压缩比

#pragma mark ----------<Text>----------

#define kPublicCircleCondition @"公开"
#define kPrivateCircleCondition @"私密"
#define kCircleJoinConditionMyFriend @"我的好友"
#define kCircleJoinConditionElite @"达人"
#define kCircleJoinConditionApply @"向我发送申请"
#define kCircleJoinConditionPublic @"公开圈，对所有人开发"

#define kShareToSNSDefaultLinkUrl @"http://mupup.com"

#define kShieldingAlert UPLocStr(@"shieldingAlert")
#define kPrivacyRightAlert UPLocStr(@"privacyRightAlert")


#pragma mark ----------<Color>----------

//#define kBlackBarTintColor ColorForHex(0x222222)

#define kTabBarBackgroundColor [UIColor blackColor]
#define kNBBarTintColor [UIColor whiteColor]//ColorForHex(0x2e9ae7) //UINavigationBar 颜色

#define kCommonTextColor ColorForHex(0x3365fd)

#define kSectionLabelColor [UIColor colorWithRed:109.0/255.0 green:114.0/255.0 blue:130.0/255.0 alpha:1.0];
#define kSectionBJViewColor [UIColor colorWithRed:219.0/255.0 green:229.0/255.0 blue:236.0/255.0 alpha:1.0];

#define kContactsListTableViewColor ColorForRGB(255,255,255,1)  //联系人,关注列表,追随者列表的tableView背景颜色
#define kMainTableViewColor ColorForHex(0xf2f2f2)
#define kMainViewColor [UIColor whiteColor]

#define kMainButtonBackGroudColor ColorForRGB(44.0, 137.0, 160.0, 1)
#define kMainButtonHlightBackGroudColor ColorForRGB(44.0,137.0,160.0,0.5)

#define kMainLabelColor [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]   // 主标题颜色
#define kSubLabelColor [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]   // 副标题颜色

#define kBaseColor [UIColor colorWithRed:0.5 green:0.09 blue:0.1 alpha:1]
#define kTableDefaultColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]

#define kCellImagePlaceholderColor [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]
#define kCollectionColor [UIColor colorWithRed:8/255.0 green:7/255.0 blue:7/255.0 alpha:1.0]
#define kCollectionCellColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define kMainLineColor ColorForHex(0xefefef)

//海报推荐背景颜色
#define kPosterViewColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]

#define kCellTitleFont [UIFont systemFontOfSize:10]
#define kCellSubTitleFont [UIFont systemFontOfSize:8]
#define kCellTitleColor [UIColor whiteColor]
#define kCellSubTitleColor [UIColor whiteColor]
#define kCellTitleHeight 14.0
#define kCellSubTitleHeight 15.0

// 字体颜色

#define kTextFieldFont [UIFont systemFontOfSize:15]
#define kTextFieldPHColor [UIColor colorWithRed:173/255.0 green:190/255.0 blue:202/255.0 alpha:1.0]
#define kTextFieldFontColor ColorForHex(0x6d7282)//[UIColor colorWithRed:109/255.0 green:114/255.0 blue:130/255.0 alpha:1.0]

#define kTextFieldBgColor [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]

#define kFontShadowColor [UIColor blackColor]
#define kFontShadowColorA ColorForRGB(0, 0, 0, 0.5)
#define kFontShadowColorB ColorForRGB(255, 255, 255, 1)

#define kFontShadowOffset CGSizeMake(0.2, 1)
#define kCardFontShadowOffset CGSizeMake(0, 1.5)
#define kBarTitleFontColor  [UIColor blackColor]//ColorForRGB(255, 255, 255, 1)

#define kBarTitleFont [UIFont systemFontOfSize:15]
#define kBarBtnFont [UIFont systemFontOfSize:15]

#define kBarBtnFontColor ColorForHex(0x3365fd)//ColorForRGB(255, 255, 255, 1)
#define kBarBtnFontHColor ColorForHexAlpha(0x3365fd, 0.5)//ColorForRGB(255, 255, 255, 0.5)

//#define kMainTitleTitleColor ColorForRGB(0, 156, 255, 1)
#define kMainTitleTitleColor ColorForRGB(0, 97, 137, 1)


#define kFollowBtnColor ColorForRGB(0, 179.0, 255.0, 1)
#define kCancelFollowBtnColor ColorForRGB(153.0, 153.0, 153.0, 1)

#define kPhotoGridBgColor ColorForRGB(54, 54, 54, 1)

#pragma mark ----------<Image>----------

// 默认头像背景
#define k32PlaceHolderIcon [UIImage imageNamed:@"headPlaceholder32.png"]
#define k40PlaceHolderIcon [UIImage imageNamed:@"UserHeaderPlaceholder40.png"]
#define k50PlaceHolderIcon [UIImage imageNamed:@"headPlaceholder50.png"]
#define k60PlaceHolderIcon [UIImage imageNamed:@"headPlaceholder60.png"]
#define k70PlaceHolderIcon [UIImage imageNamed:@"headPlaceholder70.png"]
#define k80PlaceHolderIcon [UIImage imageNamed:@"headPlaceholder80.png"]
#define k90PlaceHolderIcon [UIImage imageNamed:@"UserHeaderPlaceholder90.png"]
#define k100PlaceHolderIcon [UIImage imageNamed:@"newHeadPlaceholder100.png"]

// 播放按钮
#define kVideoPlayIcon60 [UIImage imageNamed:@"videoPlayIcon60.png"]
#define kVideoPlayIcon80 [UIImage imageNamed:@"videoPlayIcon80.png"]
#define kVideoPlayIcon100 [UIImage imageNamed:@"videoPlayIcon100.png"]

// 点赞图标
#define kPraiseEnabled [UIImage imageNamed:@"praise_enabled.png"]
#define kPraiseUnEnabled [UIImage imageNamed:@"praise_unenabled.png"]

// 发私信图标
#define kSendMessageIcon [UIImage imageNamed:@"privateMessage"]

// 第三方视频链接图标
#define kVideoLinkIcon [UIImage imageNamed:@"videoLinkIcon"]

#define kSearchIcon [UIImage imageNamed:@"searchIcon"]

// 默认个人主页背景
#define kDefaultProfileBjImage [UIImage imageNamed:@"defaulBackimage"]

// 达人认证图标
#define k20SizeMarkIcon [UIImage imageNamed:@"PHAuthImage.png"]

//名字标签
#define kLabelIconMin [UIImage imageNamed:@"labelMarkMin.png"]

//名字标签大
#define kLabelIcon [UIImage imageNamed:@"labelMark.png"]

// 横线图片
#define kLineImage [UIImage imageNamed:@"tableLine.png"]

// 长蓝色按钮图片
#define kLongBlueBtnImage [UIImage imageNamed:@"blue-button.png"]
#define kLongBlueBtnImageHi [UIImage imageNamed:@"blue-button-Highlighted.png"]

// 长灰色按钮图片
#define kLongGrayBtnImage [UIImage imageNamed:@"gray-button.png"]
#define kLongGrayBtnImageHi [UIImage imageNamed:@"lgray-button-Highlighted.png"]

// 短灰色按钮图片
#define kShortGrayBtnImage [UIImage imageNamed:@"short_gray.png"]
#define kShortGrayBtnImageHi [UIImage imageNamed:@"short_gray_dj.png"]

// 播放视频按钮图片
#define kPlayVideoBtnImage kVideoPlayIcon80
#define kPlayVideoBtnImageH kVideoPlayIcon80
// 播放视频菊花图片
//#define kRotationBJViewImage [UIImage imageNamed:@"rotationView.png"]//rotationViewBj.png
#define kRotationViewImage [UIImage imageNamed:@"rotationView.png"]
// 黑色透明navbar背景图片
#define kBlackTranslucentNavBarImage [UIImage imageNamed:@"blackTranslucentNavBar.png"]
#define kBlackTranslucentNavBarImageIOS7 [UIImage imageNamed:@"blackTranslucentNavBar_ios7.png"]

// 白色关闭按钮图片

// 未晚上完资料红色感叹号提醒图片
#define kRedAlertMarkImage [UIImage imageNamed:@"more_profileMarkImage.png"]
#define kRedAlertMarkImageMin [UIImage imageNamed:@"more_profileMarkImageMin.png"]

#define kWhiteCloseBtnImage [UIImage imageNamed:@"white_close"]

// 水印控制按钮图片
#define kCloseImg [UIImage imageNamed:@"close_watermark"]
#define kResizeImg [UIImage imageNamed:@"scale_watermark"]

// 水印控制图片
#define kMarkImg [UIImage imageNamed:@"watermarklocation.png"]

// 关注图标
#define kAddFollowIcon [UIImage imageNamed:@"meet_add_follow"]
#define kFollowedIcon [UIImage imageNamed:@"FollowIcon"]
#define kMutualFollowIcon [UIImage imageNamed:@"MutualFollowIcon"]
#define kFollowBtnBgImage [UIImage imageNamed:@"meet_button"]
#define kFollowBtnBgImageH [UIImage imageNamed:@"meet_button_dj"]

#pragma mark ----------<NotifyKey>----------


#define kNoticeLatesList @"kNoticeLatesList"  // 话题列表获取最新公告key
#define kRefreshSelectedTopic @"kRefreshSelectedTopic"  // 刷新话题信息
#define kModifyUserInfo @"kModifyUserInfo"  // 修改用户信息

//#define kDeleteMyTimeline @"kDeleteMyTimeline"  // 刷新我的动态
//#define kDeleteHomeViewTimeline @"kDeleteHomeViewTimeline" // 删除首页动态
#define kDeleteSpotNewsNotify @"kDeleteSpotNewsNotify"   // 删除动态冬至
#define kPublishSpotNewsNotify @"kPublishSpotNewsNotify"  // 发布动态通知

#define kUpdateHomeViewWork @"kUpdateHomeViewWork" // 更新首页作品信息
#define kUpdateChannelSpotWork @"kUpdateChannelSpotWork"  // 更新频道页面作品信息
#define kUpdateEliteInfoViewWork @"kUpdateEliteInfoViewWork" // 更新个人主页作品信息
#define kUpdateChannelTypeList @"kUpdateChannelTypeList"       //更新主页频道类型信息
#define kUpdateNewSearchViewSpotList @"kUpdateNewSearchViewSpotList" // 刷新搜索页面作品信息
#define kUpdateWorksDetailVCList @"kUpdateWorksDetailVCList" //更新动态详情作品信息
static NSString *const kUpdateMagazineListPraiseStatus = @"kUpdateMagazineListPraiseStatus";

#define kUpdateFollowListInfo @"kUpdateFollowListInfo" // 更新关注、追随者列表

#define kChangeMsgVCSegmtSelectedIndexNotify @"kChangeMsgVCSegmtSelectedIndexNotify"  // 更新消息页面segmt所选Index

#define kShowWorkDetailNotify @"kShowWorkDetailNotify"   // 动态详情数据通知
#define kShowEliteUserInfoViewNotify @"kShowEliteUserInfoViewNotify"  // 刷新个人主页数据
#define kShowUpNewsViewNotify @"kShowUpNewsViewNotify"   // 刷新up新闻页面
#define kRefreshRemarkNameNotify @"kRefreshRemarkNameNotify"  // 刷新相应页面备注名通知
#define kSwitchLanguageNotification @"SwitchLanguageNotification" //切换语言通知
//#define kShowHotListNotification @"kShowHotListNotify"  //成为hot榜第一的通知
#define kUserLabelChangedNotification @"kUserLabelChangedNotification"  //为某人的动态贴标签时，改变了当前标签的通知
#define kStopSpotListCellStopPlayNotify @"kStopSpotListCellStopPlayNotify"    // 停止动态列表播放视频通知
static NSString *const kAddUPADCoverViewNotify = @"kAddUPADCoverViewNotify";
//static NSString *const kSwitchToMagzineNotification = @"switchToMagzineNotification";   // 跳转到杂志页的通知（APNS）
//static NSString *const kSwitchToFocusNotification = @"switchToFocusNotification";       // 跳转到焦点页的通知（APNS）
static NSString *const kNewMagazineNotification = @"newMagazineNotification";           // open fire 有新杂志更新的通知

#define kDeleteMeetNotify @"kDeleteMeetNotify"  // 删除自己的活动的通知

#define kHomeTableRefreshNotification @"HomeTableRefreshNotification"
#define kEliteTableRefreshNotification @"EliteTableRefreshNotification"
#define kCircleTableRefreshNotification @"CircleTableRefreshNotification"

#define kTabBarSelfTabClickNotification @"kTabBarSelfTabClickNotification"
#define kTabBarClickTabNotification @"kTabBarClickTabNotification"

#define kBackgroundFetchNotification @"BackgroundFetchNotification"













