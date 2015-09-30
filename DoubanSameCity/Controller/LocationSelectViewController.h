//
//  LocationSelectViewController.h
//  DoubanSameCity
//
//  Created by yiban on 15/9/24.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenu.h"

@interface LocationSelectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SideMenuDelegate, UISearchBarDelegate>
@property (strong, nonatomic) UITableView *locationTable;   //显示全部地址的table

@end
