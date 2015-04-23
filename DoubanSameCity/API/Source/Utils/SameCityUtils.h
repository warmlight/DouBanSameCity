//
//  SameCityUtils.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventList.h"
#import "Event.h"
#import "JsonUtils.h"
#import "Owner.h"
#import "CityList.h"
#import "City.h"

@interface SameCityUtils : NSObject
+ (NSMutableArray *)get_eventArray:(NSArray *)eventlist_events;
+ (Owner *)get_owner:(NSMutableDictionary *)owner;
+ (NSMutableArray *)get_cityArray:(NSMutableArray *)cityList_locs;

@end
