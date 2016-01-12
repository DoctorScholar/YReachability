//
//  YReachability.h
//  YSocketMedo
//
//  Created by IOS_Doctor on 15/7/8.
//  Copyright (c) 2015年 __IOS_Doctor__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


/**
 * @author 颜青山
 *
 * 基于 C 和 objective - C 语言的 SCNetworkRechabilityRef 封装 ， 实现通过
 *     SCNetworkReachabilityCallBack(SCNetworkReachabilityRef ref, SCNetworkReachabilityCallBack callBack,
 *     SCNetworkReachabilityContext *context) 函数实现网络连接状态实时监听 。
 *
 */


FOUNDATION_EXPORT NSString *yReachabilityConnectFlagChangeNoticeKey;   // 在 NSNotificationCenter 检测网络状态变化用的 key 。
FOUNDATION_EXPORT NSString *yReachabilityConnectFlagChangeNoticeUserInfoObjectKey; // 在 NSNotification 的通知信息字典中 object 的 key 。
FOUNDATION_EXPORT NSString *yReachabilityConnectFlagChangeNoticeUserInfoFlagkey; // 在 NSNotification 的通知信息字典中 flag 的 key 。


enum {
    YReachabilityConnectFlagNoNetwork = 0,  // 没网络
    YReachabilityConnectFlagWiFi,           // .
    YReachabilityConnectFlag2G,             // .
    YReachabilityConnectFlag3G,             // .
    YReachabilityConnectFlag3G_4G     = 4,  // 3G或4G
    YReachabilityConnectFlag4G              // .
};

typedef uint YReachabilityConnectFlag;


@interface YReachability : NSObject

#if TARGET_OS_IPHONE
+ (BOOL)startMonitorReachability; // 开始检测网络状态
+ (void)stopMonitorReachability; // 停止检测网络状态

+ (NSString *)fetchCurrentConnectForChinese; // 获取中文当前的网络状态
+ (YReachabilityConnectFlag)fetchCurrentConnectFlag; // 获取当前的网络状态
#endif

@end
