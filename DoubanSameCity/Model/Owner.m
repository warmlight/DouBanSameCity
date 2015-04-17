//
//  Owner.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "Owner.h"

@implementation Owner
- (instancetype)init{
    self = [super init];
    if (self) {
        self.name = @"";
        self.avatar = @"";
        self.uid = @"";
        self.alt = @"";
        self.type = @"";
        self.id = @"";
        self.large_avatar = @"";
    }
    return self;
}

+(Owner *)fromJsonString: (NSString *)jsonString {
    Owner * result =[[Owner alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(Owner *)fromJsonData: (NSData *)jsonData {
    Owner * result =[[Owner alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(Owner *)fromJsonObject: (NSJSONSerialization *)json {
    Owner * result =[[Owner alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}

@end
