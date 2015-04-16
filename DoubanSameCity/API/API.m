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
//    NSString *u = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/token?client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code&code=%@", APIKey, Secret, RedirectURL, code];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:APIKey forKey:@"client_id"];
    [params setObject:Secret forKey:@"client_secret"];
    [params setObject:RedirectURL forKey:@"redirect_uri"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [params setObject:code forKey:@"code"];
    NSArray *result = [HttpUtils postSync:@"https://www.douban.com/service/auth2/token" dict:params];
    return (result == nil? nil : [Account fromJsonData:result[0]]);
}
@end
