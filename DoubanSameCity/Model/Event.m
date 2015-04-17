//
//  Event.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "Event.h"

@implementation Event
- (instancetype)init{
    self = [super init];
    if (self) {
        self.begin_time = @"";
        self.image = @"";
        self.owner = [[NSMutableDictionary alloc] init];
        self.loc_name = @"";
        self.id = @"";
        self.title = @"";
        self.wisher_count = [NSNumber numberWithInt:0];
        self.content = @"";
        self.participant_count = @"";
        self.album = @"";
        self.geo = @"";
        self.category_name = @"";
        self.loc_id = @"";
        self.end_time = @"";
    }
    return self;
}

+(Event *)fromJsonString: (NSString *)jsonString {
    Event * result =[[Event alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(Event *)fromJsonData: (NSData *)jsonData {
    Event * result =[[Event alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(Event *)fromJsonObject: (NSJSONSerialization *)json {
    Event * result =[[Event alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}


@end
