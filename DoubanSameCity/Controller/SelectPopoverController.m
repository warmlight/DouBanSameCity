//
//  SelectPopoverController.m
//  DoubanSameCity
//
//  Created by yiban on 15/8/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "SelectPopoverController.h"

@implementation SelectPopoverController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.timeTableView = [[TimeTable alloc] initWithFrame:self.view.frame];
    self.timeTableView.backgroundColor = [UIColor clearColor];
    self.timeTableView.hidden = YES;
    [self.view addSubview:self.timeTableView];
    
    self.typeTableView = [[TypeTable alloc] initWithFrame:self.view.frame];
    self.typeTableView.backgroundColor = [UIColor clearColor];
    self.typeTableView.hidden = YES;
    [self.view addSubview:self.typeTableView];
}

- (CGSize)preferredContentSize{
//    if (self.presentingViewController && self.timeTableView != nil ) {
//        CGSize tempSize = self.presentingViewController.view.bounds.size;
//        tempSize.width = 150;
//        CGSize size = [self.timeTableView sizeThatFits:tempSize];
//        return size;
//    }else {
//        return [super preferredContentSize];
//    }
  
    if (self.whitchTable == 1 && self.timeTableView != nil) {
        self.timeTableView.hidden = NO;
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 150;
        CGSize size = [self.timeTableView sizeThatFits:tempSize];
        return size;
    }else if (self.whitchTable == 2 && self.typeTableView != nil) {
        self.typeTableView.hidden = NO;
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 150;
        CGSize size = [self.typeTableView sizeThatFits:tempSize];
        return size;
    }else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}
@end
