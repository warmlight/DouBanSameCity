//
//  User.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype)init{
    self = [super init];
    if (self) {
        self.id = @"";
        self.uid = @"";
        self.name = @"";
        self.avatar = @"";
        self.large_avatar = @"";
        self.alt = @"";
        self.created = @"";
        self.loc_id = @"";
        self.loc_name = @"";
        self.desc = @"";
    }
    return self;
}

+(User *)fromJsonString: (NSString *)jsonString {
    User * result =[[User alloc] init];
    [JsonUtils fillJsonToObject:result jsonString:jsonString];
    return result;
}

+(User *)fromJsonData: (NSData *)jsonData {
    User * result =[[User alloc] init];
    [JsonUtils fillJsonToObject:result jsonData:jsonData];
    return result;
}

+(User *)fromJsonObject: (NSJSONSerialization *)json {
    User * result =[[User alloc] init];
    [JsonUtils fillJsonToObject:result json:json];
    return result;
}

-(NSString *)toString {
    return [JsonUtils objectToJsonString:self];
}

@end
