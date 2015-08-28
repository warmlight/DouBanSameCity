//
//  ResponseCode.h
//  DoubanSameCity
//
//  Created by yiban on 15/8/25.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"
@interface ResponseCode : NSObject

@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSNumber *code;
@property (strong, nonatomic) NSString *request;

+(ResponseCode *)fromJsonString: (NSString *)jsonString;
+(ResponseCode *)fromJsonData: (NSData *)jsonData;
+(ResponseCode *)fromJsonObject: (NSJSONSerialization *)json;
-(NSString *)toString;
@end
