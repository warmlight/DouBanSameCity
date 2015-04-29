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

+ (Account *)loadAccount{
    Account *account = [[Account alloc] init];
    account.access_token = [ConfigUtils loadConfigString:@"access_token"];
    account.refresh_token = [ConfigUtils loadConfigString:@"refresh_token"];
    account.douban_user_id = [ConfigUtils loadConfigString:@"douban_user_id"];
    account.expires_in = [NSNumber numberWithInt:[ConfigUtils loadConfigInt:@"expires_in"]];
    return account;
}

+ (void)saveUser:(User *)user{
    if (user) {
        [ConfigUtils saveConfigString:@"id" value:user.id];
        [ConfigUtils saveConfigString:@"uid" value:user.uid];
        [ConfigUtils saveConfigString:@"loc_id" value:user.loc_id];
        [ConfigUtils saveConfigString:@"loc_name" value:user.loc_name];
        [ConfigUtils saveConfigString:@"name" value:user.name];
        [ConfigUtils saveConfigString:@"created" value:user.created];
        [ConfigUtils saveConfigString:@"avatar" value:user.avatar];
        [ConfigUtils saveConfigString:@"large_avatar" value:user.large_avatar];
        [ConfigUtils saveConfigString:@"desc" value:user.desc];
        [ConfigUtils saveConfigString:@"alt" value:user.alt];
    }
}

+ (User *)loadUser{
    User *user = [[User alloc] init];
    user.id = [ConfigUtils loadConfigString:@"id"];
    user.uid = [ConfigUtils loadConfigString:@"uid"];
    user.loc_id = [ConfigUtils loadConfigString:@"loc_id"];
    user.loc_name = [ConfigUtils loadConfigString:@"loc_name"];
    user.name = [ConfigUtils loadConfigString:@"name"];
    user.created = [ConfigUtils loadConfigString:@"created"];
    user.avatar = [ConfigUtils loadConfigString:@"avatar"];
    user.large_avatar = [ConfigUtils loadConfigString:@"large_avatar"];
    user.desc = [ConfigUtils loadConfigString:@"desc"];
    user.alt = [ConfigUtils loadConfigString:@"alt"];
    return user;
}

+ (void)logOut{
    [ConfigUtils saveConfigString:@"douban_user_id" value:0];
}

+ (NSString *)getLoginUserId{
    return [ConfigUtils loadConfigString:@"douban_user_id"];
}

@end
