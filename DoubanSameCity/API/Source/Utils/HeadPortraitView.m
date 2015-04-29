//
//  HeadPortraitView.m
//  SchoolCalendar
//
//  Created by iMac on 15/3/12.
//  Copyright (c) 2015年 YiBan. All rights reserved.
//

#import "HeadPortraitView.h"


@implementation HeadPortraitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;  //设置的是圆角的半径
        self.layer.borderWidth = 4.f;
        self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
