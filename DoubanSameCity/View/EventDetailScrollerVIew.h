//
//  EventDetailScrollerVIew.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <UIImageView+WebCache.h>
#import "Owner.h"
#import "SameCityUtils.h"
#import <MapKit/MapKit.h>
#import "FreeLabel.h"
#import "FullScreenLargeImageShowUtils.h"

#define TitleBoldFont [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
#define TitleF [UIFont systemFontOfSize:17]
#define TextF [UIFont systemFontOfSize:14]
#define SmallMargin 10
#define BigMargin 20
#define EventImageW 75
#define EventImageH 110
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface EventDetailScrollerVIew : UIScrollView
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *beginTimeImg;
@property (strong, nonatomic) UIImageView *endTimeImg;
@property (strong, nonatomic) UIImageView *addressImg;
@property (strong, nonatomic) UIImageView *ownerImg;
@property (strong, nonatomic) UIImageView *typeImg;
@property (strong, nonatomic) UIImageView *eventImg;
@property (strong, nonatomic) UIImageView *eventZoomInImg;
@property (strong, nonatomic) UILabel *beginTimeLabel;
@property (strong, nonatomic) UILabel *endTimeLabel;
@property (strong, nonatomic) UIButton *addressButton;
@property (strong, nonatomic) FreeLabel *ownerLabel;
@property (strong, nonatomic) UILabel *typeLabel;

@property (strong, nonatomic) UILabel *bandLabel;
@property (strong, nonatomic) FreeLabel *contentLabel;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) UIView *contentLabelBkg;

- (CGFloat)setViewFrame_Content:(Event *)event;


@end
