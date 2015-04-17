//
//  Owner.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"

@interface Owner : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *alt;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *large_avatar;

+(Owner *)fromJsonString: (NSString *)jsonString;
+(Owner *)fromJsonData: (NSData *)jsonData;
+(Owner *)fromJsonObject: (NSJSONSerialization *)json;
@end
