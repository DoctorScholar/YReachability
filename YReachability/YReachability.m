//
//  YReachability.m
//  YSocketMedo
//
//  Created by IOS_Doctor on 15/7/8.
//  Copyright (c) 2015年 __IOS_Doctor__. All rights reserved.
//

#import "YReachability.h"


NSString *yReachabilityConnectFlagChangeNoticeKey               = @"yReachabilityConnectFlagChangeNoticeKey";
NSString *yReachabilityConnectFlagChangeNoticeUserInfoObjectKey = @"yReachabilityConnectFlagChangeNoticeUserInfoObjectKey";
NSString *yReachabilityConnectFlagChangeNoticeUserInfoFlagkey   = @"yReachabilityConnectFlagChangeNoticeUserInfoFlagkey";


@implementation YReachability

SCNetworkConnectionFlags _connectionFlags;
SCNetworkReachabilityRef _reachability;

#pragma mark Checking Connections

+ (void)pingReachabilityInternal
{
    if (!_reachability) {
        
        BOOL ignoresAdHocWiFi = NO;
        struct sockaddr_in ipAddress;
        bzero(&ipAddress, sizeof(ipAddress));
        ipAddress.sin_len = sizeof(ipAddress);
        ipAddress.sin_family = AF_INET;
        ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);
        
        _reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);
        CFRetain(_reachability);
    }
    
    // 检查兼容状态
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(_reachability, &_connectionFlags);
    if (!didRetrieveFlags) {
#if DEBUG
        printf("Error. Could not recover network reachability flags\n");
#endif
    }
}

#pragma mark - Monitoring reachability

static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void *info)
{
    YReachabilityConnectFlag flag = rosterFlags(flags);
    [[NSNotificationCenter defaultCenter] postNotificationName:yReachabilityConnectFlagChangeNoticeKey
                                                        object:nil userInfo:@{
                                                                              yReachabilityConnectFlagChangeNoticeUserInfoObjectKey : (info)? (__bridge id)info : @"",
                                                                              yReachabilityConnectFlagChangeNoticeUserInfoFlagkey : (flag)? @(flag) : @""}
                                                                              ];
}

// 开启网络连接监视
+ (BOOL)startMonitorReachability
{
    [self pingReachabilityInternal];
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    if(SCNetworkReachabilitySetCallback(_reachability, reachabilityCallback, &context)) {
        if(!SCNetworkReachabilityScheduleWithRunLoop(_reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) {
#if DEBUG
            NSLog(@"Error: Could not schedule reachability");
#endif
            SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
            return NO;
        }
    }
    else{
#if DEBUG
        NSLog(@"Error: Could not set reachability callback");
#endif
        return NO;
    }
    return YES;
}

+ (void)stopMonitorReachability
{
    SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
    if (SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) {
#if DEBUG
        NSLog(@"Unscheduled reachability");
#endif
    }
    else{
#if DEBUG
        NSLog(@"Error: Could not unschedule reachability");
#endif
    }
    CFRelease(_reachability);
    _reachability = nil;
}

+ (YReachabilityConnectFlag)fetchCurrentConnectFlag
{
    [self pingReachabilityInternal];
    return rosterFlags(_connectionFlags);
}

+ (NSString *)fetchCurrentConnectForChinese
{
    [self pingReachabilityInternal];
    NSString *flag = @"";
    switch (_connectionFlags) {
        case 0:
            flag = @"没网络";
            break;
        case 262151:
            flag = @"3G或者4G";
            break;
        case 262147:
            flag = @"4G";
            break;
        case 131074:
            flag = @"WiFi";
            break;
            
        default:
            flag = @"没网络";
            break;
    }
    return flag;
}

#pragma mark - SCNetworkReachabilityFlags to YReachabilityConnectFlag (convert)

static YReachabilityConnectFlag rosterFlags(SCNetworkReachabilityFlags flags)
{
    YReachabilityConnectFlag flag;
    switch (flags) {
        case 0:
            flag = YReachabilityConnectFlagNoNetwork;
            break;
        case 262151:
            flag = YReachabilityConnectFlag3G_4G;
            break;
        case 262147:
            flag = YReachabilityConnectFlag4G;
            break;
        case 131074:
            flag = YReachabilityConnectFlagWiFi;
            break;
            
        default:
            flag = YReachabilityConnectFlagNoNetwork;
            break;
    }
    return flag;
}

@end
