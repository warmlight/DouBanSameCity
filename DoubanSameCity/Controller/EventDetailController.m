//
//  EventDetailController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailController.h"


@interface EventDetailController ()

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"table_bkg.png"] forBarMetrics:UIBarMetricsCompact];
    // Do any additional setup after loading the view.
}

- (void)initUI:(Event *)event{
    self.scrollerView = [[EventDetailScrollerVIew alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO; //让视图从{0， 0}开始显示 而不是从{0， 64}
    CGFloat contentSizeHeigth = [self.scrollerView setViewFrame_Content:event];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollerX = 0;
    CGFloat scrollerY = 0;
    CGFloat scrollerW = screenWidth;
    CGFloat scrollerH = self.view.frame.size.height;
    self.scrollerView.frame = CGRectMake(scrollerX, scrollerY, scrollerW, scrollerH);
    self.scrollerView.contentSize = CGSizeMake(screenWidth, contentSizeHeigth);
    //    self.scrollerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.scrollerView];
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
