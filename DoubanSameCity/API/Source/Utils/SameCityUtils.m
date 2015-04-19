//
//  SameCityUtils.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "SameCityUtils.h"

@implementation SameCityUtils
+ (NSMutableArray *)get_eventArray:(NSArray *)eventlist_events{
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < eventlist_events.count; i ++) {
        Event *event = [Event fromJsonObject:eventlist_events[i]];
        [eventArray addObject:event];
    }
    return eventArray;
}

+ (Owner *)get_owner:(NSMutableDictionary *)owner{
    Owner *host = [Owner fromJsonObject:(NSJSONSerialization *)owner];
    return host;
}

@end
