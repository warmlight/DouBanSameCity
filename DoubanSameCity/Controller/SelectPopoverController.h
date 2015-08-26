//
//  SelectPopoverController.h
//  DoubanSameCity
//
//  Created by yiban on 15/8/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTable.h"
#import "TypeTable.h"
@interface SelectPopoverController : UIViewController<UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) TimeTable *timeTableView;
@property (strong, nonatomic) TypeTable *typeTableView;
@property (assign, nonatomic) NSInteger whitchTable;    //当前应该显示的table 1.timetalbe 2.typetable
@end
