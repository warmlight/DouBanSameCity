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
#import "ResponseCode.h"

#define TitleBoldFont [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
#define TitleF [UIFont systemFontOfSize:17]
#define TextF [UIFont systemFontOfSize:14]
#define SmallMargin 10
#define BigMargin 20
#define EventImageW 132
#define EventImageH 195
#define ButtonH 30
#define Buttonw 100
#define ButtonImageH 20
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@protocol JoinWishDelegate <NSObject>

- (ResponseCode *)wish:(UIButton *)sender;
- (ResponseCode *)participate:(UIButton *)sender;
@end

@interface EventDetailScrollerVIew : UIScrollView<UITextViewDelegate>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *eventImg;
@property (strong, nonatomic) UIImageView *eventZoomInImg;
@property (strong, nonatomic) UIButton *addressButton;
@property (strong, nonatomic) UILabel *bandLabel;
@property (strong, nonatomic) UITextView *contentLabel;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) UIView *contentLabelBkg;
@property (strong, nonatomic) UIImageView *bkgImageView;
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) UIButton *joinButton;
@property (strong, nonatomic) UIButton *wishButton;
@property (assign, nonatomic) id <JoinWishDelegate> JoinWishdelegate;

- (CGFloat)setViewFrame_Content:(Event *)event;


@end
