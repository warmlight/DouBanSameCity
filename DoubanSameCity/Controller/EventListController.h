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
#import <MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationUtils.h"
#import <MJRefresh.h>
#import "Toast.h"
#import "EventDetailController.h"


#define Count 10

@interface EventListController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) UITableView *tabelView;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSNumber *totalEvent;
@property (strong, nonatomic) LocationUtils *lu;

@end
