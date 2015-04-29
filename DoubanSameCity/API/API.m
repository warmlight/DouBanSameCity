//
//  API.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "API.h"

@implementation API
+ (Account*)get_access_token:(NSString *)code{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:APIKey forKey:@"client_id"];
    [params setObject:Secret forKey:@"client_secret"];
    [params setObject:RedirectURL forKey:@"redirect_uri"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [params setObject:code forKey:@"code"];
    NSArray *result = [HttpUtils postSync:@"https://www.douban.com/service/auth2/token" dict:params];
    return (result == nil? nil : [Account fromJsonData:result[0]]);
}

+ (User *)get_user:(NSString *)id{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/user/%@", id];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [User fromJsonData:result[0]]);
}

+ (EventList *)get_eventlist:(NSNumber *)count star:(NSNumber *)star loc:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/list?loc=%@&day_type=%@&type=%@&count=%@&start=%@", loc, day_type, type, count, star];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [EventList fromJsonData:result[0]]);
}

+ (CityList *)get_cityList:(NSNumber *)count start:(NSNumber *)start{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/loc/list?count=%@0&start=%@", count, start];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [CityList fromJsonData:result[0]]);
}

@end
