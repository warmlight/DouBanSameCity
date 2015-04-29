//
//  LeftController.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadPortraitView.h"
#import "Config.h"
#import "User.h"
#import <UIImageView+WebCache.h>
#import "FullScreenLargeImageShowUtils.h"
#import "LeftHeadView.h"


//#import "OAutoController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface LeftController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HeadPortraitView *headView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *loginButton;
@end
