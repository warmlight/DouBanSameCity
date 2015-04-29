//
//  AboutMeController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/28.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "AboutMeController.h"

@interface AboutMeController ()

@end

@implementation AboutMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshUser)];
    // Do any additional setup after loading the view.
}

- (void)refreshUser{
    User *user = [API get_user:[Config getLoginUserId]];
    [Config saveUser:user];
    [self.scrollView createFrame_Conten];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"push_reloadData" object:nil];
}

- (void)initUI{
    self.scrollView = [[AboutMeScrollView alloc] init];
    CGFloat contentSizeHeigth = [self.scrollView createFrame_Conten];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollerX = 0;
    CGFloat scrollerY = 0;
    CGFloat scrollerW = screenWidth;
    CGFloat scrollerH = self.view.frame.size.height;
    self.scrollView.frame = CGRectMake(scrollerX, scrollerY, scrollerW, scrollerH);
    self.scrollView.contentSize = CGSizeMake(screenWidth, contentSizeHeigth);
    //    self.scrollerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.scrollView];
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
