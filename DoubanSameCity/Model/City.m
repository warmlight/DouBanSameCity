//
//  City.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/23.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)init{
    self = [super init];
    if (self) {
        self.parent = @"";
        self.habitable = @"";
        self.name = @"";
        self.uid = @"";
    }
    return self;
}

+(City *)fromJsonString: (NSString *)jsonString {
    City * result =[[City alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(City *)fromJsonData: (NSData *)jsonData {
    City * result =[[City alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(City *)fromJsonObject: (NSJSONSerialization *)json {
    City * result =[[City alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}
@end
