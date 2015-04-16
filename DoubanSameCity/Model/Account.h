//
//  Account.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"
@class  Account;

@interface Account : NSObject
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSNumber *expires_in;
@property (strong, nonatomic) NSString *refresh_token;
@property (strong, nonatomic) NSString *douban_user_id;

+(Account *)fromJsonString: (NSString *)jsonString;
+(Account *)fromJsonData: (NSData *)jsonData;
+(Account *)fromJsonObject: (NSJSONSerialization *)json;
-(NSString *)toString;
@end
