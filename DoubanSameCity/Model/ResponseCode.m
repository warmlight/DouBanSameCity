//
//  ResponseCode.m
//  DoubanSameCity
//
//  Created by yiban on 15/8/25.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "ResponseCode.h"

@implementation ResponseCode
- (instancetype)init{
    self = [super init];
    if (self) {
        self.msg = @"";
        self.code = [NSNumber numberWithInt:0];
        self.request = @"";
    }
    return self;
}

+(ResponseCode *)fromJsonString: (NSString *)jsonString {
    ResponseCode * result =[[ResponseCode alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(ResponseCode *)fromJsonData: (NSData *)jsonData {
    ResponseCode * result =[[ResponseCode alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(ResponseCode *)fromJsonObject: (NSJSONSerialization *)json {
    ResponseCode * result =[[ResponseCode alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}
@end
