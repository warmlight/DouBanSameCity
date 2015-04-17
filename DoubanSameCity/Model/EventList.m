//
//  EventList.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventList.h"

@implementation EventList
- (instancetype)init{
    self = [super init];
    if (self) {
        self.count = [NSNumber numberWithInt:0];
        self.star = [NSNumber numberWithInt:0];
        self.total = [NSNumber numberWithInt:0];
        self.events = [[NSMutableArray alloc] init];
    }
    return self;
}

+(EventList *)fromJsonString: (NSString *)jsonString {
    EventList * result =[[EventList alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(EventList *)fromJsonData: (NSData *)jsonData {
    EventList * result =[[EventList alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(EventList *)fromJsonObject: (NSJSONSerialization *)json {
    EventList * result =[[EventList alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}
@end
