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

@interface SameCityUtils : NSObject
+ (NSMutableArray *)get_eventArray:(NSArray *)eventlist_events;
+ (Owner *)get_owner:(NSMutableArray *)owner;
@end
