//
//  Notification.h
//  SuperEducation
//
//  Created by yangming on 2017/3/8.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#ifndef Notification_h
#define Notification_h

#define  SENotificationCenter [NSNotificationCenter defaultCenter]

//kvo 列表联动
#define ContentCollectionContentOffset @"contentCollectionContentOffset"
#define TopTagCollectionContentOffset @"topTagCollectionContentOffset"

//Skin
#define SKINCHANGESUCCESS @"skinChangeSuccess"

//直播
#define LIVESENDMESSAGE @"liveSendMessage"
#define LIVESENDGIFT @"liveSendGift"
#define LIVEREVICEMESSAGE @"LiveReviceMessage"
#define LIVEREVICEGIFT @"LiveReviceGift"
#define LIVEJOINROOM @"LivejoinRoom"
#define LIVEMUTE @"LiveMute" //禁言
#define LIVEUNMUTE @"LiveUnmute"
#define FOLLOWTRAINER @"FollowTrainer" //关注老师
#define LIVEREMIND @"liveRemind" //直播提醒
#define LIVECOINNOTENOUGH @"LiveCoinNotEnough" //奇迹币不足
#define LIVEGIFT_ACK @"LiveGift_Ack" //发送成功服务器返回消费的奇迹币
#define LIVEPLAYAD @"livePlayAD" //直播插播广告

//个人信息登录
#define MINEDITNICKSUCCESS @"editNickNameSuccess"
#define MINEUPTEHEADERSUCCESS @"updateHeaderSuccess"
#define MINELINKMOBILESUCCESS @"linkMobileSuccess"
//path
#define HeaderCachePath @"http://user/avatar.jpg"//头像缓存路径
#define LOGINSUCCESS @"LoginSuccess"
#define LOGOUTSUCCESS @"logoutSuccess"

//支付
#define PUSHCONTROLLERNOTIFICATION @"pushConroller"
#define FREECOURSEBUYSUCCESS @"freeCourseBuySuccess" //免费课程购买成功
#define WECHATBUYSUCCESS @"WeChatBuySuccess" //微信购买成功


//编辑成功时 发送
#define ARTICLERLEASESUCCESS @"articleReleaseSuccess"//文章发表成功
#define LIVERELEASESUCCESS @"liveReleaseSuccess" //直播发布成功
#define BUNDLERELEASESUCCESS @"bundleReleaseSuccess" //专栏发布成功
#define COMMUNITYRELEASESUCCESS @"communityReleaseSuccess" //社群发布成功
#define AUDIORELEASESUCCESS @"audioReleaseSuccess" //音频课程发布成功
#define VIDEORELEASESUCCESS @"videoReleaseSuccess" //视频课程发布成功
#define PRODUCTRELEASESUCCESS @"productReleaseSuccess" //商品发布成功


//音视频
#define VIDEOFULLSCREEN @"VideoFullScreen" //平面视频旋转到全屏
#define VIDEOFULLSIZE @"VideoFullSize" //平面视频旋转到全屏的size
#define RECORDSTATE @"RecordPlayEnd" //录音播放结束

//音视频上传
#define STARTUPlOAD @"startUpload" //开始上传
#define UPlOADSUCCESS @"uploadSuccess" //上传成功
#define UPLOADFAILER @"uploadFailer" //上传失败
#define UPLOADBREAK @"uploadBreak" //上传中断
#define RESUMEUPLOADFAILERFROMZERO @"resumeUploadFromZero" //从0开始续传
#define FONTDOWNLOADDONE @"fontDownloadDone" //单个字体下载完成
#define ALLFONTDOWNLOADDONE @"allFontDownloadDone" //字体下载完成
#define USEDEFAULTFONT @"useDefaultFont" //用默认字体

#pragma mark - store
#define UPDATESTOREINFO @"UpdateStoreInfo" //修改店铺信息

//IM
#define RESUMESENDSUCCESS @"resumeSendSuccess" //重传成功
#define PUSHMESSAGEINSERTSUCCESS @"PushMessageInsertrSuccess" //推送消息插入数据成功
#define REVICENEWCHATMESSGAE @"ReviceNewChatMessgae" //收到新聊天消息
#define RECONNECTIONSUCCESS @"reconnectionSuccess" //重连网络成功
#define UPLOADNETWORKBREAK @"uploadNetworkBreak" //上传资源网络错误
#define NETBREAK @"netBreak" //网络中断



//社区成员管理
#define BLACKSUCCESS @"blackdSuccess" //拉黑成功
#define MUTESUCCESS @"muteSuccess" //禁言成功



//选择商品
#define PRODUCTSELECTED @"productSelected" //选中
#define PRODUCTNORMAL @"productNormal" //未选中

#define CONTENTEDITFINISH @"contentEditFinish"
#define EDITEINFO @"editInfo"

//积分 人民币 兑换率
#define Spread 10
#define MAXVisit 1000000

#endif /* Notification_h */
