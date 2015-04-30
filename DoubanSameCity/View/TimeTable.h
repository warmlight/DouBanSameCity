//
//  TimeTable.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/30.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

#define cellH 40
@interface TimeTable : UITableView<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *timeTypes;

@end
