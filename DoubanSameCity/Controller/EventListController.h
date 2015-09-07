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
#import "Toast.h"
#import "EventDetailController.h"
#import "PHJTransformPinyin.h"
#import "CityList.h"
#import "City.h"
#import "OAutoController.h"
#import "AboutMeController.h"
#import "SettingController.h"
#import "TimeTable.h"

#define Daytable [tableView isKindOfClass:[TimeTable class]]
#define Count 10

@interface EventListController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSNumber *totalEvent;
@property (strong, nonatomic) NSMutableString *locName;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *day_type;
@property (strong, nonatomic) UIButton *day_typeButton;
@property (strong, nonatomic) UIButton *type_Button;    //选择活动类型按钮
@property (strong, nonatomic) TimeTable *timeTable;
@property (assign, nonatomic) BOOL dayTableIsAdd;


@end
