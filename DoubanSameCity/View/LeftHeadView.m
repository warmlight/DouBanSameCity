//
//  LeftHeadView.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/27.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "LeftHeadView.h"

@implementation LeftHeadView
- (instancetype)init{
    self= [super init];
    if (self) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        CGFloat headW = 100;
        CGFloat headH = headW;
        CGFloat headX = (screenSize.width / 5 * 3 - headW) / 2;
        CGFloat headY = 70;
        self.headView = [[HeadPortraitView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
        self.headView.userInteractionEnabled = YES;
        
        CGFloat nameX = 0;
        CGFloat nameY = headY + headH + 20;
        CGFloat nameW = screenSize.width / 5 * 3;
        CGFloat nameH = 40;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
        self.nameLabel.tag = 99;
        
        CGFloat btnX = 20;
        CGFloat btnY = screenSize.height - 100;
        CGFloat btnW = screenSize.width /5 * 3 - 20 * 2;
        CGFloat btnH = 40;
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [self.loginButton setBackgroundColor:UIColorFromRGB(0xB4EEB4)];
        [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)login:(UIButton *)sender{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"push_left" object:nil];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
