//
//  CityList.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/23.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "CityList.h"

@implementation CityList
- (instancetype)init{
    self = [super init];
    if (self) {
        self.count = [NSNumber numberWithInt:0];
        self.start = [NSNumber numberWithInt:0];
        self.total = [NSNumber numberWithInt:0];
        self.locs = [[NSMutableArray alloc] init];
    }
    return self;
}

+(CityList *)fromJsonString: (NSString *)jsonString {
    CityList * result =[[CityList alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(CityList *)fromJsonData: (NSData *)jsonData {
    CityList * result =[[CityList alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(CityList *)fromJsonObject: (NSJSONSerialization *)json {
    CityList * result =[[CityList alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}
@end
