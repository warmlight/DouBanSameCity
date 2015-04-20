//
//  EventCell.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/20.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

#define Margin 5
#define TitleFont [UIFont systemFontOfSize:14]
#define TextFont [UIFont systemFontOfSize:12]
#define ImageW 57
#define ImageH 85

@interface EventCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *eventImage;
@property (strong, nonatomic) UIImageView *begin_time_image;
@property (strong, nonatomic) UILabel *bengin_event_time_Label;
@property (strong, nonatomic) UIImageView *end_time_image;
@property (strong, nonatomic) UILabel *end_event_time_Label;
@property (strong, nonatomic) UIImageView *address_image;
@property (strong, nonatomic) UILabel *eventAdressLabel;
@property (strong, nonatomic) UIImageView *typeImage;
@property (strong, nonatomic) UILabel *eventTypeLabel;
@property (strong, nonatomic) UILabel *wish_count_Label;
@property (strong, nonatomic) UILabel *wishLabel;
//@property (strong, nonatomic) UILabel *day_number_Label;
//@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *participant_count_label;
@property (strong, nonatomic) UILabel *participant_label;

-(void)createSubview;
- (void)createFrame;
+ (CGFloat)cellHeight :(Event *)event;
@end
