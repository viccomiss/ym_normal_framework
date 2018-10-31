//
//  APIManager.m
//  UNIS-LEASE
//
//  Created by runlin on 2016/11/4.
//  Copyright © 2016年 unis. All rights reserved.
//


#import "APIManager.h"
#import "AFSecurityPolicy.h"
#import "AFNetworkActivityIndicatorManager.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import "JKAlert.h"
#import "Constant.h"

//#import "SEUserDefaults.h"
#import "CommonUtils.h"
#import "BaseNavigationController.h"
#import "SEHUD.h"
#import "NSString+JLAdd.h"

static dispatch_once_t onceToken;
static APIManager *_sharedManager = nil;

NetWorkState state;

@implementation APIManager

+ (instancetype)sharedManager {
    
    dispatch_once(&onceToken, ^{
        //设置服务器根地址
        _sharedManager = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:URI_BASE_SERVER]];
        //        [_sharedManager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
        
        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy  defaultPolicy];
        //        securityPolicy.allowInvalidCertificates = YES;
        
        //        securityPolicy.validatesDomainName = NO;
        
        [_sharedManager setSecurityPolicy:securityPolicy];
        
        [_sharedManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G网络已连接");
                    state = NetWorkConnected;
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WiFi网络已连接");
                    state = NetWorkConnected;
                    [SENotificationCenter postNotificationName:RECONNECTIONSUCCESS object:nil];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"网络连接失败");
                    [SENotificationCenter postNotificationName:NETBREAK object:nil];
                    state = NetWorkUnknow;
                    break;
                    
                default:
                    break;
            }
        }];
        [_sharedManager.reachabilityManager startMonitoring];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

        //发送http数据
        _sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //响应json数据
        _sharedManager.responseSerializer  = [AFJSONResponseSerializer serializer];

        _sharedManager.responseSerializer.acceptableContentTypes =  [_sharedManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",@"image/jpg",nil]];
          //设置 x-client
        [_sharedManager.requestSerializer setValue:[self generateUserAgent]?:@"" forHTTPHeaderField:@"x-client"];
    });
   
    return _sharedManager;
}

+ (NetWorkState)currentNetWorkState{
    return state;
}

+ (NSString *)generateUserAgent{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return [NSString stringWithFormat:@"ios(%@;%@)", [UIDevice currentDevice].systemVersion,
            platform];
}

+ (NSURLSessionDataTask *)SafePOST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(NSURLResponse *respone, id responseObject))success
                           failure:(void (^)(NSURLResponse *respone, NSError *error))failure{
    APIManager *manager = [self setHttpHeader];
    
    NSLog(@"HTTP:\n%@%@",manager.baseURL,URLString);
    
    NSLog(@"Header:\n%@",manager.requestSerializer.HTTPRequestHeaders);

    NSLog(@"POST JSON:\n%@",[NSString dictionaryToJson:parameters?:@{}]);
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        NSLog(@"server respone  JSON:\n%@",responseObject);
        
        if ([[responseObject objectForKey:@"errcode"] integerValue] == 0) {
            success(task.response,responseObject);
        }
        
//        if (![responseObject objectForKey:@"error"]) {
//            success(task.response,responseObject);
//
//        }
        else{
            
            [SEHUD showAlertWithText:responseObject[@"error"][@"msg"]];
            NSError *errorForJSON = [NSError errorWithDomain:@"接口出错" code:[responseObject[@"error"][@"code"] integerValue] userInfo:@{@"接口请求失败": [responseObject objectForKey:@"errorMsg"]?:@""}];
            NSLog(@"error%@",[errorForJSON description]);
            failure(task.response,errorForJSON);
            //登录失效
            NSInteger errorCode = [responseObject[@"error"][@"code"] integerValue];
            if (errorCode == 5 ) {
                [APIManager loginFailure];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //todo 统一处理错误
//         NSString *responseString =  [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
//        NSLog(@"server respone  Error JSON:\n%@",responseString);
        return ;
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            if (errorDict) {
                [SEHUD showAlertWithText:errorDict[@"error"][@"msg"]];
            }
        }else{
            [SEHUD showAlertWithText:@"请检查网络状态"];
            
        }

        failure(task.response,error);
    }];
}

+ (NSURLSessionDataTask *)SafeGET:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLResponse *respone, id responseObject))success
                          failure:(void (^)(NSURLResponse *respone, NSError *error))failure{
    APIManager *manager = [self setHttpHeader];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"client request HTTP interface:\n%@%@",manager.baseURL,URLString);
    NSLog(@"client request POST JSON:\n%@",[NSString dictionaryToJson:parameters?:@{}]);
//    NSString *url = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string mj_JSONObject];
        
        
        if ([[dic objectForKey:@"errcode"] integerValue] == 0) {
            success(task.response,dic);
        }else{
            
            [SEHUD showAlertInWindowWithText:responseObject[@"error"][@"msg"]];
            NSError *errorForJSON = [NSError errorWithDomain:@"接口出错" code:2015 userInfo:@{@"接口请求失败": [responseObject objectForKey:@"errorMsg"]?:@""}];
            NSLog(@"error%@",[errorForJSON description]);
            failure(task.response,errorForJSON);
        }
        
    
        
//        if ([responseObject isKindOfClass:[NSJSONSerialization class]]) {
//
//            if (![responseObject objectForKey:@"error"]) {
//                success(task.response,responseObject);
//            }else{
//
//                [SEHUD showAlertInWindowWithText:responseObject[@"error"][@"msg"]];
//                NSError *errorForJSON = [NSError errorWithDomain:@"接口出错" code:2015 userInfo:@{@"接口请求失败": [responseObject objectForKey:@"errorMsg"]?:@""}];
//                NSLog(@"error%@",[errorForJSON description]);
//                failure(task.response,errorForJSON);
//            }
//
//        }else{
//            [self reset];
//            success(task.response,responseObject);
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            if (errorDict) {
                [SEHUD showAlertWithText:errorDict[@"error"][@"msg"]];
            }
        }else{
            [SEHUD showAlertWithText:@"请检查网络状态"];
            
        }
        //todo
        failure(task.response,error);
    }];
}

//配置header
+(APIManager *)setHttpHeader{
    APIManager *manager = [APIManager sharedManager];
//    for (NSString *key in [self headerDic]) {
//        [manager.requestSerializer setValue:[[self headerDic] objectForKey:key]?:@"" forHTTPHeaderField:key];
//    }
    return manager;

}
//header
//+ (NSDictionary *)headerDic{
//    return @{@"x-api-version":API_VERSION,_sessionType == SessionNormalType ? @"x-mdi-sess" : @"x-usr-sess":@"9d9b49ee8ee84050b303e9e50d0204f9N67zEKJioB9ZyjYVaZQ1JR8LmaFqanXn",@"x-client":[self generateUserAgent]};
//    if ([[SEUserDefaults shareInstance] userIsLogin]) {
//        UserModel *user = [SEUserDefaults shareInstance].getUserModel;
//        return @{@"x-api-version":API_VERSION, @"x-mdi-sess": user.session.ID,@"x-client":[self generateUserAgent]};
//    }else{
//        return @{@"x-api-version":API_VERSION, @"x-mdi-sess":@"",@"x-client":[self generateUserAgent]};
//    }
//    return nil;
//}

////设置ip要重置单例 生效
+ (void)reset {
    _sharedManager = nil;
    onceToken = 0;
}

//登录失效
//+ (void)loginFailure{
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[SEUserDefaults shareInstance] userLogout];
//        [IMTool isConnectedOrNot:NO];
//        UIViewController *vc = [CommonUtils currentViewController];
//        if ([vc isKindOfClass:[LoginViewController class]]) {
//            return;
//        }
//        [SENotificationCenter postNotificationName:LOGOUTSUCCESS object:nil];
//        LoginViewController *loginVC =[[LoginViewController alloc]init];
//        [vc.navigationController pushViewController:loginVC animated:YES];
//    });
//}

@end
