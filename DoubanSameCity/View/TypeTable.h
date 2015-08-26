//
//  StyleTable.h
//  DoubanSameCity
//
//  Created by yiban on 15/8/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#define cellH 30
@interface TypeTable : UITableView<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *types;
@end
