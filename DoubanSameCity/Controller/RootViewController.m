//
//  RootViewController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
-(id)init {
    if (self = [super init]) {
        self.contentViewShadowColor = [UIColor greenColor];
        self.scaleMenuView = YES;
        self.scaleContentView = YES;
        self.contentViewScaleValue = 0.8;
        self.contentViewShadowRadius = 15;
        self.contentViewShadowEnabled = NO; //阴影
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6;
        self.scaleBackgroundImageView = YES;
        
        self.contentViewController = [[NavigationController alloc] init];
        self.leftMenuViewController = [[LeftController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
