//
//  EventDetailScrollerVIew.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailScrollerVIew.h"

@implementation EventDetailScrollerVIew
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xB4EEB4);
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = TitleBoldFont;
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        
        self.eventImg = [[UIImageView alloc] init];
        self.eventImg.backgroundColor = [UIColor redColor];
        [self addSubview:self.eventImg];
        
        self.beginTimeImg = [[UIImageView alloc] init];
        [self addSubview:self.beginTimeImg];
        
        self.endTimeImg = [[UIImageView alloc] init];
        [self addSubview:self.endTimeImg];
       
        self.addressImg = [[UIImageView alloc] init];
        [self addSubview:self.addressImg];
        
        self.ownerImg = [[UIImageView alloc] init];
        [self addSubview:self.ownerImg];
        
        self.typeImg = [[UIImageView alloc] init];
        
        self.beginTimeLabel = [[UILabel alloc] init];
        self.beginTimeLabel.font = TextF;
        [self addSubview:self.beginTimeLabel];
        
        self.endTimeLabel = [[UILabel alloc] init];
        self.endTimeLabel.font = TextF;
        [self addSubview:self.endTimeLabel];

        self.addressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.addressButton.titleLabel.numberOfLines = 0;
        self.addressButton.backgroundColor = [UIColor blueColor];
        self.addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.addressButton addTarget:self action:@selector(callMap:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.addressButton];
        
        self.ownerLabel = [[UILabel alloc] init];
        self.ownerLabel.numberOfLines = 0;
        self.ownerLabel.font = TextF;
        [self addSubview:self.ownerLabel];
        
        self.typeLabel = [[UILabel alloc] init];
    }
    return self;
}

- (CGFloat)setViewFrame_Content:(Event *)event{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    
    //title label
    self.titleLabel.text = event.title;
    
    CGFloat titleX = BigMargin;
    CGFloat titleY = BigMargin;
    CGFloat titleW = screenWidth - 2 *BigMargin;
    CGSize titleConstraint = CGSizeMake(titleW, 20000.0);
    CGSize titleSize = [event.title sizeWithFont:TitleF constrainedToSize:titleConstraint];
    CGFloat titleH = titleSize.height;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    //event image
    [self.eventImg setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"bkg.png"]];
    
    CGFloat eventImgX = BigMargin;
    CGFloat eventImgY = titleY + titleH + SmallMargin;
    CGFloat eventImgW = EventImageW;
    CGFloat eventImgH = EventImageH;
    self.eventImg.frame = CGRectMake(eventImgX, eventImgY, eventImgW, eventImgH);
    
    //begin label
    self.beginTimeLabel.text = event.begin_time;
    
    CGSize beginTimeLabelSize = [@"测量字体高度" sizeWithFont:TextF constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat beginLabelH = beginTimeLabelSize.height;
    CGFloat beginLabelX = eventImgX + EventImageW + 10 +beginLabelH + 5;
    CGFloat beginLabelW = screenWidth - BigMargin - beginLabelX;
    CGFloat beginLabelY = eventImgY;
    self.beginTimeLabel.frame = CGRectMake(beginLabelX, beginLabelY, beginLabelW, beginLabelH);
    
    //begin imge
    self.beginTimeImg.image = [UIImage imageNamed:@"star.png"];
    
    CGFloat beginImgX = eventImgX + EventImageW + SmallMargin;
    CGFloat beginImgY = eventImgY;
    CGFloat beginImgW = beginLabelH;
    CGFloat beginImgH = beginImgW;
    self.beginTimeImg.frame = CGRectMake(beginImgX, beginImgY, beginImgW, beginImgH);
    
    //end image
    self.endTimeImg.image = [UIImage imageNamed:@"end.png"];
    
    CGFloat endImageX = beginImgX;
    CGFloat endImageY = beginImgY + beginImgH + SmallMargin;
    CGFloat endImageW = beginImgW;
    CGFloat endImageH = endImageW;
    self.endTimeImg.frame = CGRectMake(endImageX, endImageY, endImageW, endImageH);
    
    //end label
    self.endTimeLabel.text = event.end_time;
    
    CGFloat endLabelX = beginLabelX;
    CGFloat endLabelY = endImageY;
    CGFloat endLabelW = beginLabelW;
    CGFloat endLabelH = beginLabelH;
    self.endTimeLabel.frame = CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH);
    
    //address image
    self.addressImg.image = [UIImage imageNamed:@"address.png"];
    
    CGFloat addressImgX = endImageX;
    CGFloat addressImgY = endImageY + endLabelH + SmallMargin;
    CGFloat addressImgW = endImageW;
    CGFloat addressImgH = addressImgW;
    self.addressImg.frame = CGRectMake(addressImgX, addressImgY, addressImgW, addressImgH);
    
    //address button
    [self.addressButton setTitle:event.address forState:UIControlStateNormal];
    
    CGFloat addressBtnX = endLabelX;
    CGFloat addressBtnY = addressImgY;
    CGFloat addressBtnW = endLabelW;
    CGSize addressConstraint = CGSizeMake(addressBtnW, 20000.0);
    CGSize addressSize = [event.address sizeWithFont:TitleF constrainedToSize:addressConstraint];
    CGFloat addressBtnH = addressSize.height;
    self.addressButton.frame = CGRectMake(addressBtnX, addressBtnY, addressBtnW, addressBtnH);
    
    
    //owner image
    self.ownerImg.image = [UIImage imageNamed:@"owner.png"];
    
    CGFloat ownerImgX = addressImgX;
    CGFloat ownerImgY = addressBtnY + addressBtnH + SmallMargin;
    CGFloat ownerImgW = addressImgW;
    CGFloat ownerImgH = ownerImgW;
    self.ownerImg.frame = CGRectMake(ownerImgX, ownerImgY, ownerImgW, ownerImgH);
    
    //owner label
    Owner *owner = [SameCityUtils get_owner:event.owner];
    self.ownerLabel.text = [NSString stringWithFormat:@"主办:%@", owner.name];
    
    CGFloat ownerLabelX = addressBtnX;
    CGFloat ownerLabelY = ownerImgY;
    CGFloat ownerLabelW = addressBtnW;
    CGSize ownerConstraint = CGSizeMake(addressBtnW, 20000.0);
    CGSize ownerSize = [owner.name sizeWithFont:TitleF constrainedToSize:ownerConstraint];
    CGFloat ownerLabelH = ownerSize.height;
    self.ownerLabel.frame = CGRectMake(ownerLabelX, ownerLabelY, ownerLabelW, ownerLabelH);
    
    return eventImgY + eventImgH + BigMargin;
    
}

- (void)callMap:(UIButton *)sender{
    NSLog(@"tap button");
}


@end
