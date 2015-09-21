//
//  shareIcon.m
//  shareView
//
//  Created by yiban on 15/9/18.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import "shareIcon.h"


@implementation shareIcon


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon selectedBlock:(selectedIcon)block {
    self = [super init];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconHeight, iconHeight)];
        self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconHeight, iconHeight, titleHeight)];
        self.titlelabel.textAlignment = NSTextAlignmentCenter;
        self.titlelabel.textColor = [UIColor whiteColor];
        self.titlelabel.backgroundColor = [UIColor clearColor];
        self.iconView.image = icon;
        self.titlelabel.text = title;
        self.selcetedBlock = block;
        [self addSubview:self.iconView];
        [self addSubview:self.titlelabel];
        
    }
    return self;
}
@end
