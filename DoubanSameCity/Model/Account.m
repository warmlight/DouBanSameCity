//
//  Account.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "Account.h"

@implementation Account

- (instancetype)init{
    self = [super init];
    if (self) {
        self.access_token = @"";
        self.expires_in = [NSNumber numberWithInt:0];
        self.refresh_token = @"";
        self.douban_user_id = @"";
    }
    return self;
}

+(Account *)fromJsonString: (NSString *)jsonString {
    Account * result =[[Account alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(Account *)fromJsonData: (NSData *)jsonData {
    Account * result =[[Account alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(Account *)fromJsonObject: (NSJSONSerialization *)json {
    Account * result =[[Account alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}
@end
