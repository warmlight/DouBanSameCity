//
//  User.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUtils.h"
#import "JsonUtils.h"

@class User;
@interface User : NSObject
@property (strong, nonatomic) NSString *id;                 //id和uid相等
@property (strong, nonatomic) NSString *uid;                //userid
@property (strong, nonatomic) NSString *name;               //用户姓名
@property (strong, nonatomic) NSString *avatar;             //用户头像
@property (strong, nonatomic) NSString *large_avatar;       //用户头像
@property (strong, nonatomic) NSString *alt;                //豆瓣主页
@property (strong, nonatomic) NSString *created;            //注册时间
@property (strong, nonatomic) NSString *loc_id;             //城市id
@property (strong, nonatomic) NSString *loc_name;           //城市名
@property (strong, nonatomic) NSString *desc;               //签名

+(User *)fromJsonString: (NSString *)jsonString;
+(User *)fromJsonData: (NSData *)jsonData;
+(User *)fromJsonObject: (NSJSONSerialization *)json;
-(NSString *)toString;
@end
