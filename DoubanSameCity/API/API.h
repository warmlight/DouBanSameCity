//
//  API.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"
#import "HttpUtils.h"
#import "Account.h"
#import "User.h"
#import "EventList.h"
#import "Event.h"
#import "CityList.h"

#define APIKey @"0c64cd6d91fb7474252e6848b5f25d5c"
#define Secret @"0e0ee1a0742a7637"
#define RedirectURL @"https://www.douban.com/"
#define BASE_URL @"https://api.douban.com"

#define All @"all"
#define Music @"music"
#define XiJu @"drama"
#define ZhanLan @"exhibition"
#define JiangZuo @"salon"
#define JuHui @"party"
#define YunDong @"sports"
#define LuXing @"travel"
#define GongYi @"commonweal"
#define DianYing @"film"

#define Future @"future"
#define Week @"week"
#define Weekend @"weekend"
#define Today @"today"
#define Tomorrow @"tomorrow"

@interface API : NSObject
+ (Account*)get_access_token:(NSString *)code;
+ (User *)get_user:(NSString *)code;
+ (EventList *)get_eventlist:(NSNumber *)count star:(NSNumber *)star loc:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type;
+ (CityList *)get_cityList:(NSNumber *)count start:(NSNumber *)start;
//用户感兴趣
+ (EventList *)get_wishedEvent:(NSNumber *)count start:(NSNumber *)start;
@end
