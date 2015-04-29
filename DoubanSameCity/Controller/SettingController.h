//
//  SettingController.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/29.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#define Span 20
#define ButtonH 50
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SettingController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *loginOutButton;
@property (assign, nonatomic) NSUInteger totalSize;
@end
