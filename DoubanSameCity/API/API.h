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

#define APIKey @"0431c1b73ffe94340c954525bffbbc9c"
#define Secret @"25b0498a00ab1abd"
#define RedirectURL @"https://www.douban.com/"

@interface API : NSObject
+ (Account*)get_access_token:(NSString *)code;

@end
