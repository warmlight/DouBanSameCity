//
//  EventListController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventListController.h"

@interface EventListController ()

@end

@implementation EventListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    self.view.backgroundColor = [UIColor redColor];
    UIImage * img = [UIImage imageNamed:@"menu"];
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    EventList *eventlist = [API get_eventlist:nil star:nil loc:@"shanghai" type:nil day_type:nil];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
    NSMutableArray *eventsArray = [SameCityUtils get_eventArray:array];
    NSLog(@"%@",[eventsArray[0] toString]);
    
    
    
    // Do any additional setup after loading the view.
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

@end
