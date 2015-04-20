//
//  EventListController.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SideMenu.h"
#import "API.h"
#import "SameCityUtils.h"
#import "Owner.h"
#import "EventCell.h"
#import <UIImageView+WebCache.h>

@interface EventListController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tabelView;
@property (strong, nonatomic) NSMutableArray *eventsArray;

@end
