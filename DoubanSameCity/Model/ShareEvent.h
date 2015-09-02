//
//  ShareEvent.h
//  DoubanSameCity
//
//  Created by yiban on 15/9/1.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareEvent : NSObject
@property (strong, nonatomic) NSMutableArray *wishArray;
@property (strong, nonatomic) NSMutableArray *joinArray;

+ (instancetype)sharedInstance;
@end
