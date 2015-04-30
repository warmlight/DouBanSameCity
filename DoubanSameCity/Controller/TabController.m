//
//  TabController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "TabController.h"

@interface TabController ()

@end

@implementation TabController

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    self.tabBar.translucent = NO;
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"table_bkg.png"] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBar.alpha = 0.5;
    
    EventListController *eventlist = [[EventListController alloc] init];
    MyEventController *myevent = [[MyEventController alloc] init];
    
    eventlist.tabBarItem.title = @"活动";
    myevent.tabBarItem.title = @"我的活动";
    
    [self addChildViewController:eventlist];
    [self addChildViewController:myevent];
    self.navigationController.title = eventlist.tabBarItem.title;
    self.delegate = self;

    
    self.navigationItem.title = @"活动";
    
    
    UIImage * img = [UIImage imageNamed:@"menu.png"];
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.navigationItem.title = viewController.tabBarItem.title;
}

@end
