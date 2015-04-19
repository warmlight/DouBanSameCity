//
//  Event.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"
@class Event;
@interface Event : NSObject
@property (strong, nonatomic) NSString *begin_time;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSMutableDictionary *owner;
@property (strong, nonatomic) NSString *loc_name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *wisher_count;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *participant_count;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *geo;
@property (strong, nonatomic) NSString *category_name;
@property (strong, nonatomic) NSString *loc_id;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *address;

+(Event *)fromJsonString: (NSString *)jsonString;
+(Event *)fromJsonData: (NSData *)jsonData;
+(Event *)fromJsonObject: (NSJSONSerialization *)json;
-(NSString *)toString;
@end
