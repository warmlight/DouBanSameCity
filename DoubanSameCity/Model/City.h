//
//  City.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/23.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"
@class City;
@interface City : NSObject

@property (strong, nonatomic) NSString *parent;
@property (strong, nonatomic) NSString *habitable;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uid;

+(City *)fromJsonString: (NSString *)jsonString;
+(City *)fromJsonData: (NSData *)jsonData;
+(City *)fromJsonObject: (NSJSONSerialization *)json;
-(NSString *)toString;
@end
