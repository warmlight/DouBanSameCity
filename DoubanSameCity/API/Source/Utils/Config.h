//
//  Config.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "ConfigUtils.h"
#import "User.h"

@interface Config : NSObject
+ (void)saveAccount :(Account *)account;
+ (Account *)loadAccount;
+ (void)saveUser :(User *)user;
+ (User *)loadUser;
+ (void)logOut;
+ (NSString *)getLoginUserId;
@end
