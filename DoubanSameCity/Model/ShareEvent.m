//
//  ShareEvent.m
//  DoubanSameCity
//
//  Created by yiban on 15/9/1.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "ShareEvent.h"

@implementation ShareEvent
static ShareEvent *shareEvent = nil;

+ (instancetype)sharedInstance
{
    static ShareEvent *shareEvent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareEvent = [[super allocWithZone:NULL]init];
        shareEvent.wishArray = [[NSMutableArray alloc] init];
        shareEvent.joinArray = [[NSMutableArray alloc] init];
    });
    return shareEvent;
}
@end
