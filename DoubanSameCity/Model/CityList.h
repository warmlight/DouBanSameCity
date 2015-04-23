//
//  CityList.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/23.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityList : NSObject
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *start;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSMutableArray *users;
@end
