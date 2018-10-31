//
//  Constant.h
//  AFNetworking-demo
//
//  Created by Jakey on 15/6/3.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifdef SYNTHESIZE_CONSTS
# define CONST(name, value) NSString* const name = @ value
#else
# define CONST(name, value) extern NSString* const name
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#if 0 // 0 测试环境  1生产环境

//---------------------生产环境---------------------
#define SEDebug 0
CONST(API_VERSION, "2.2");
CONST(URI_BASE_SERVER, "https://api.wakkaa.com/1/"); //正式服务器

CONST(KEY_WEIXIN_SSO_ID, "wx18b1e316f5e37e84"); //哇咔咔微信KEY
CONST(KEY_WEIXIN_SECRET, "c8f827370ab19c2c575a9f6cd37259f4"); //哇咔咔
CONST(WEBSOCKET_URL, "wss://liveim.wakkaa.com/");
CONST(IM_URL, "im.wakkaa.com");
CONST(IM_PORT, "19001");

#else

//---------------------测试环境---------------------
#define SEDebug 1
CONST(API_VERSION, "2.2");
CONST(URI_BASE_SERVER, "http://192.168.100.130:8763/"); //测试服务器

CONST(KEY_WEIXIN_SSO_ID, "wx43e39002910d6fc8");
CONST(KEY_WEIXIN_SECRET, "bb39e0ce1c089373a48c4bbaacf90f98");
CONST(WEBSOCKET_URL, "ws://192.168.100.130:8763/");
CONST(IM_URL, "sandbox-im.wakkaa.com");
CONST(IM_PORT, "19001");

#endif

/*====================================接口============================================*/
//socket
CONST(SOCKET_COIN_KCLINE, "coin/kcline"); //币k

//coin
CONST(URI_COIN_RANKS, "coin/ranks"); //币行情列表

//exchange
CONST(URI_EXCHANGE_RANKS, "exchange/ranks"); //交易所列表


@interface Constant : NSObject

@end
