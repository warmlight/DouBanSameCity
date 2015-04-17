//
//  EventList.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtils.h"

@class EventList;
@interface EventList : NSObject
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *star;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSMutableArray *events;

+(EventList *)fromJsonString: (NSString *)jsonString;
+(EventList *)fromJsonData: (NSData *)jsonData;
+(EventList *)fromJsonObject: (NSJSONSerialization *)json;
-(NSString *)toString;
@end
