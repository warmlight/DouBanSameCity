//
//  Config.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "Config.h"

@implementation Config
+ (void)saveAccount:(Account *)account{
    if (account) {
        [ConfigUtils saveConfigString:@"access_token" value:account.access_token];
        [ConfigUtils saveConfigString:@"refresh_token" value:account.refresh_token];
        [ConfigUtils saveConfigString:@"douban_user_id" value:account.douban_user_id];
        [ConfigUtils saveConfigInt:@"expires_in" value:[account.expires_in intValue]];
    }
}

+ (NSString *)getLoginUserId{
    return [ConfigUtils loadConfigString:@"douban_user_id"];
}
@end
