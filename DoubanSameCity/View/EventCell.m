//
//  EventCell.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/20.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    //bkgView
    self.bkgView = [[UIView alloc] init];
    self.bkgView.backgroundColor = UIColorFromRGB(0xB0DCD5);
    self.bkgView.layer.cornerRadius = 5.0;
    self.bkgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bkgView];
    
    //titile
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = UIColorFromRGB(0xF8C5B4);
    self.titleLabel.font = TitleFont;
    self.titleLabel.numberOfLines = 0;
    [self.bkgView addSubview:self.titleLabel];
    
    //image
    self.eventImage = [[UIImageView alloc] init];
    self.eventImage.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.eventImage];
    
    //begin time
    self.begin_time_image = [[UIImageView alloc] init];
    self.begin_time_image.image = [UIImage imageNamed:@"star.png"];
    [self.contentView addSubview:self.begin_time_image];
    
    //begin eventtime
    self.bengin_event_time_Label = [[UILabel alloc] init];
    self.bengin_event_time_Label.font = TextFont;
    [self.contentView addSubview:self.bengin_event_time_Label];
    
    //end time
    self.end_time_image = [[UIImageView alloc] init];
    self.end_time_image.image = [UIImage imageNamed:@"end.png"];
    [self.contentView addSubview:self.end_time_image];
    
    //end event time
    self.end_event_time_Label = [[UILabel alloc] init];
    self.end_event_time_Label.font = TextFont;
    [self.contentView addSubview:self.end_event_time_Label];
    
    //type image
    self.typeImage = [[UIImageView alloc] init];
    self.typeImage.image = [UIImage imageNamed:@"type.png"];
    [self.contentView addSubview:self.typeImage];
    
    //type label
    self.eventTypeLabel = [[UILabel alloc] init];
    self.eventTypeLabel.font = TextFont;
    [self.contentView addSubview:self.eventTypeLabel];
    
    //address image
    self.address_image = [[UIImageView alloc] init];
    self.address_image.image = [UIImage imageNamed:@"address.png"];
    [self.contentView addSubview:self.address_image];
    
    //address label
    self.eventAdressLabel = [[UILabel alloc] init];
    self.eventAdressLabel.font = TextFont;
    self.eventAdressLabel.numberOfLines = 0;
    [self.contentView addSubview:self.eventAdressLabel];
    
    //wish label
    self.wishLabel = [[UILabel alloc] init];
    self.wishLabel.textColor = [UIColor lightGrayColor];
    self.wishLabel.font = TextFont;
    self.wishLabel.text = @"人感兴趣";
    [self.contentView addSubview:self.wishLabel];
    
    //wish number
    self.wish_count_Label = [[UILabel alloc] init];
    self.wish_count_Label.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    self.wish_count_Label.font = TextFont;
    self.wish_count_Label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.wish_count_Label];
    
    //participant label
    self.participant_label = [[UILabel alloc] init];
    self.participant_label.font = TextFont;
    self.participant_label.textColor = [UIColor lightGrayColor];
    self.participant_label.text = @"人参加";
    [self.contentView addSubview:self.participant_label];
    
    //participant label
    self.participant_count_label = [[UILabel alloc] init];
    self.participant_count_label.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    self.participant_count_label.textAlignment = NSTextAlignmentCenter;
    self.participant_count_label.font = TextFont;
    [self.contentView addSubview:self.participant_count_label];
    
}

- (void)createFrame{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //title
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGSize titleConstraint = CGSizeMake(screenSize.width- 8 * Margin, 20000.0);
    CGSize titleSize = [self.titleLabel.text sizeWithFont:TitleFont constrainedToSize:titleConstraint];
    self.titleLabel.frame = (CGRect){{titleX, titleY}, {screenSize.width- 6 * Margin, titleSize.height}};

    
    //image
    CGFloat imageY = titleSize.height + 4 * Margin;
    self.eventImage.frame = CGRectMake(5 *Margin, imageY, ImageW, ImageH);
    
    //begin time
    CGFloat begin_timeX = 5 *Margin + ImageW + 2 *Margin;
    CGFloat begin_timeY = imageY;
    CGSize begintimeSize = [@"测量字体高度" sizeWithFont:TextFont constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.begin_time_image.frame = CGRectMake(begin_timeX, begin_timeY, begintimeSize.height, begintimeSize.height);
    
    //begin eventtime
    CGFloat eventTimeX = begin_timeX + begintimeSize.height + Margin;
    CGFloat eventTimeY = begin_timeY;
    CGFloat eventTimeW = screenSize.width - eventTimeX - 3 *Margin;
    CGFloat eventTimeH = begintimeSize.height;
    self.bengin_event_time_Label.frame = CGRectMake(eventTimeX, eventTimeY, eventTimeW, eventTimeH);
    
    //end time
    CGFloat endtimeX = begin_timeX;
    CGFloat endtimeY = begintimeSize.height + begin_timeY + Margin;
    CGSize endtimeSize = begintimeSize;
    self.end_time_image.frame = CGRectMake(endtimeX, endtimeY, endtimeSize.height, endtimeSize.height);
    
    //end event time
    CGFloat end_eventTimeX = eventTimeX;
    CGFloat end_eventTimeY = endtimeY;
    CGFloat end_eventTimeW = eventTimeW;
    CGFloat end_eventTimeH = eventTimeH;
    self.end_event_time_Label.frame = CGRectMake(end_eventTimeX, end_eventTimeY, end_eventTimeW, end_eventTimeH);
    
    //address image
    CGFloat addressImageX = endtimeX;
    CGFloat addressImageY = endtimeY + endtimeSize.height + Margin;
    CGSize addressTimeSize = begintimeSize;
    self.address_image.frame = CGRectMake(addressImageX, addressImageY, addressTimeSize.height, addressTimeSize.height);
    
    //address label
    CGFloat addressLabelX = end_eventTimeX;
    CGFloat addressLabelY = addressImageY;
    CGFloat addressLabelW = end_eventTimeW;
    CGSize typeConstraint = CGSizeMake(screenSize.width- addressLabelX - 4 *Margin, 20000.0);
    CGSize addressSize = [self.eventAdressLabel.text sizeWithFont:TextFont constrainedToSize:typeConstraint];
    self.eventAdressLabel.frame = CGRectMake(addressLabelX, addressLabelY,addressLabelW, addressSize.height);

    //type image
    CGFloat typeImageX = endtimeX;
    CGFloat typeImageY = addressLabelY + addressSize.height + Margin;
    CGSize typeTimeSize = begintimeSize;
    self.typeImage.frame = CGRectMake(typeImageX, typeImageY, typeTimeSize.height, typeTimeSize.height);

    //type label
    CGFloat typeLabelX = end_eventTimeX;
    CGFloat typeLabelY = typeImageY;
    CGFloat typeLabelW = end_eventTimeW;
    CGFloat typenLabeH = end_eventTimeH;
    self.eventTypeLabel.frame = CGRectMake(typeLabelX, typeLabelY, typeLabelW, typenLabeH);
    
    //wish label
    CGSize wishSize = [@"人感兴趣" sizeWithFont:TextFont constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat wishX = screenSize.width - 6 *Margin - wishSize.width;
    CGFloat wishY = begintimeSize.height + typeLabelY + 20;
    self.wishLabel.frame = CGRectMake(wishX, wishY, wishSize.width, wishSize.height);
    
    //wish number label
    CGFloat wishNumberX = wishX - 50;
    CGFloat wishNumberY = wishY;
    CGFloat wishNumberW = 50;
    CGFloat wishNumberH = wishSize.height;
    self.wish_count_Label.frame = CGRectMake(wishNumberX, wishNumberY, wishNumberW, wishNumberH);
    
    //participant label
    CGSize parSize  = [@"人参加" sizeWithFont:TextFont constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat parX = wishNumberX - parSize.width - 20;
    CGFloat parY = wishNumberY;
    CGFloat parW = wishSize.width;
    self.participant_label.frame = CGRectMake(parX, parY, parW, parSize.height);
    
    //participant Number
    CGFloat parNumX = parX - 50;
    CGFloat parNumY = parY;
    CGFloat parNumW = 50;
    CGFloat parNumH = wishNumberH;
    self.participant_count_label.frame = CGRectMake(parNumX, parNumY, parNumW, parNumH);
    
    //bkgView
    CGFloat bkgViewX = 3 * Margin;
    CGFloat bkgViewY = 2 *Margin;
    CGFloat bkgViewW = screenSize.width- 6 * Margin;
    CGFloat bkgViewH = parNumH + parNumY + 2 * Margin;
    self.bkgView.frame = CGRectMake(bkgViewX, bkgViewY, bkgViewW, bkgViewH);
}

+ (CGFloat)cellHeight:(Event *)event{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize titleConstraint = CGSizeMake(screenSize.width- 8 * Margin, 20000.0);
    CGSize titleSize = [event.title sizeWithFont:TitleFont constrainedToSize:titleConstraint];
    CGSize labelSize = [@"测量字体高度" sizeWithFont:TextFont constrainedToSize:CGSizeMake(100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize addressConstraint = CGSizeMake(screenSize.width- 12 * Margin -ImageW - labelSize.height, 20000.0);
    CGSize addressSize = [event.address sizeWithFont:TextFont constrainedToSize:addressConstraint]; //self.imageView.frame.origin.x + ImageW + 10


    return 10 + titleSize.height + 10 + labelSize.height * 3 + 15 + addressSize.height + 20 + labelSize.height + 50;
}

@end
