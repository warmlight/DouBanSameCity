//
//  EventDetailScrollerVIew.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailScrollerVIew.h"

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"0\\d{2,3}-\\d{5,9}|0\\d{2,3}-\\d{5,9}" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}


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
        self.eventImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZoomInImage:)];
        [self.eventImg addGestureRecognizer:tap];
        [self addSubview:self.eventImg];
        
        self.eventZoomInImg = [[UIImageView alloc] init];
        [self.eventImg addSubview:self.eventZoomInImg];
        
        self.beginTimeImg = [[UIImageView alloc] init];
        [self addSubview:self.beginTimeImg];
        
        self.endTimeImg = [[UIImageView alloc] init];
        [self addSubview:self.endTimeImg];
       
        self.addressImg = [[UIImageView alloc] init];
        [self addSubview:self.addressImg];
        
        self.ownerImg = [[UIImageView alloc] init];
        [self addSubview:self.ownerImg];
        
        self.typeImg = [[UIImageView alloc] init];
        [self addSubview:self.typeImg];
        
        self.beginTimeLabel = [[UILabel alloc] init];
        self.beginTimeLabel.font = TextF;
        [self addSubview:self.beginTimeLabel];
        
        self.endTimeLabel = [[UILabel alloc] init];
        self.endTimeLabel.font = TextF;
        [self addSubview:self.endTimeLabel];

        self.addressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.addressButton.titleLabel.numberOfLines = 0;
        [self.addressButton addTarget:self action:@selector(callMap:) forControlEvents:UIControlEventTouchDown];
        self.addressButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.addressButton.layer.borderWidth = 1;
        self.addressButton.layer.cornerRadius = 8.f;
        self.addressButton.layer.masksToBounds = YES;
        [self addSubview:self.addressButton];
        
        self.ownerLabel = [[FreeLabel alloc] init];
        self.ownerLabel.numberOfLines = 0;
        self.ownerLabel.font = TextF;
        self.ownerLabel.verticalAlignment = VerticalAlignmentTop;
        [self addSubview:self.ownerLabel];
        
        self.typeLabel = [[UILabel alloc] init];
        self.typeLabel.font = TextF;
        [self addSubview:self.typeLabel];
        
        self.bandLabel = [[UILabel alloc] init];
        self.bandLabel.font = TitleF;
        self.bandLabel.backgroundColor = UIColorFromRGB(0xEEE685);
        [self addSubview:self.bandLabel];
        
        
        self.contentLabelBkg = [[UIView alloc] init];
        self.contentLabelBkg.backgroundColor = UIColorFromRGB(0xEE9572);
        [self addSubview:self.contentLabelBkg];
        
        self.contentLabel = [[UITextView alloc] init];
        self.contentLabel.delegate = self;
        self.contentLabel.scrollEnabled = NO;
        self.contentLabel.editable = NO;
        self.contentLabel.font = TextF;
        self.contentLabel.backgroundColor = UIColorFromRGB(0xEE9572);
        self.contentLabel.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress;
        [self addSubview:self.contentLabel];

    }
    return self;
}

- (void)tapZoomInImage:(UITapGestureRecognizer *)gesture{
    NSLog(@"tap");
    UIImageView *eventImg = (UIImageView *)gesture.view;
    [FullScreenLargeImageShowUtils showImage:eventImg large_image_url:self.event.image_hlarge];//放大
}

- (CGFloat)setViewFrame_Content:(Event *)event{
    self.event = event;
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
    [self.eventImg sd_setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    
    CGFloat eventImgX = BigMargin;
    CGFloat eventImgY = titleY + titleH + SmallMargin;
    CGFloat eventImgW = EventImageW;
    CGFloat eventImgH = EventImageH;
    self.eventImg.frame = CGRectMake(eventImgX, eventImgY, eventImgW, eventImgH);
    
    
    //event zoom in image
    self.eventZoomInImg.image = [UIImage imageNamed:@"add.png"];
    
    CGFloat zoomX = eventImgW - 25;
    CGFloat zoomY = eventImgH - 25;
    CGFloat zoomW = BigMargin;
    CGFloat zoomH = BigMargin;
    self.eventZoomInImg.frame = CGRectMake(zoomX, zoomY, zoomW, zoomH);
    
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
    [self.addressButton setTitle:[event.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forState:UIControlStateNormal];//去回车
    
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
    self.ownerLabel.text = owner.name;
    CGFloat ownerLabelX = addressBtnX;
    CGFloat ownerLabelY = ownerImgY;
    CGFloat ownerLabelW = addressBtnW;
    CGSize ownerConstraint = CGSizeMake(addressBtnW, 20000.0);
    CGSize ownerSize = [self.ownerLabel.text sizeWithFont:TitleF constrainedToSize:ownerConstraint];
    CGFloat ownerLabelH = ownerSize.height;
    self.ownerLabel.frame = CGRectMake(ownerLabelX, ownerLabelY, ownerLabelW, ownerLabelH);
    
    //type image
    self.typeImg.image = [UIImage imageNamed:@"type.png"];
    
    CGFloat typeImgX = ownerImgX;
    CGFloat typeImgY = ownerLabelY + ownerLabelH + SmallMargin;
    CGFloat typeImgW = ownerImgW;
    CGFloat typeImgH = typeImgW;
    self.typeImg.frame = CGRectMake(typeImgX, typeImgY, typeImgW, typeImgH);
    
    //type label
    self.typeLabel.text = event.category_name;
    
    CGFloat typeLabelX = ownerLabelX;
    CGFloat typeLabelY = typeImgY;
    CGFloat typeLabelW = ownerLabelW;
    CGFloat typeLabelH = typeImgH;
    self.typeLabel.frame = CGRectMake(typeLabelX, typeLabelY, typeLabelW, typeLabelH);
    
    //band label
    self.bandLabel.text = @"  活动详情";
    
    CGFloat bandX = 0;
    CGFloat bandY = typeLabelY + typeLabelH + 2 *BigMargin;
    CGFloat bandW = screenWidth;
    CGSize bandConstraint = CGSizeMake(bandW, 20000.0);
    CGSize bandSize = [self.bandLabel.text sizeWithFont:TitleF constrainedToSize:bandConstraint];
    CGFloat bandH = bandSize.height;
    self.bandLabel.frame = CGRectMake(bandX, bandY, bandW, bandH);
    
    //contentlabel
    self.contentLabel.text = event.content;
    
    CGFloat contentX = SmallMargin;
    CGFloat contentY = bandY + bandH + SmallMargin;
    CGFloat contentW = screenWidth - 2 *SmallMargin;
    CGSize contentConstraint = CGSizeMake(contentW, 20000.0);
    CGSize contentSize = [self.contentLabel.text sizeWithFont:TextF constrainedToSize:contentConstraint];
    CGFloat contentH = contentSize.height;
//    if (contentH  <  ([UIScreen mainScreen].bounds.size.height - contentY)) {
//        contentH = [UIScreen mainScreen].bounds.size.height - contentY;
//    }
    self.contentLabel.frame = CGRectMake(contentX, contentY, contentW, contentH);

    //contenlabelbkg
    CGFloat contentBkgX = 0;
    CGFloat contentBkgY = bandH + bandY;
    CGFloat contentBkgW = screenWidth;
    CGFloat contentBkgH = contentH + SmallMargin;
    if (contentH < ([UIScreen mainScreen].bounds.size.height - contentY)) {
        contentBkgH = [UIScreen mainScreen].bounds.size.height - contentY;
    }
    self.contentLabelBkg.frame = CGRectMake(contentBkgX, contentBkgY, contentBkgW, contentBkgH);
 
    
//    [self createAtributeContentLabel:event];
    return contentBkgY + contentH + SmallMargin;
    
}

- (void)callMap:(UIButton *)sender{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    NSArray *location = [self.event.geo componentsSeparatedByString:@" "];
    CLLocationCoordinate2D  endCoor = {[location[0] intValue], [location[1] intValue]};
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
    toLocation.name = self.event.address;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];

}

//- (void)createAtributeContentLabel:(Event *)event{
//    self.contentLabel.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress;
    //富文本的样式
//    NSDictionary*linkAttributes=@{NSForegroundColorAttributeName:[UIColor blueColor],
//                                  NSUnderlineColorAttributeName:[UIColor blueColor],
//                                  NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
//    
//    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:event.content];
//    NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
//    NSRegularExpression *regexp = NameRegularExpression();
//    //给所有符合正则条件的string修改样式
//    [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//        self.contentLabel.linkTextAttributes = linkAttributes;
//    }];
//    NSRegularExpression *regexp_second = ParenthesisRegularExpression();
//    [regexp_second enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//        self.contentLabel.linkTextAttributes = linkAttributes;
//    }];
//}

#pragma mark- textview delegate
//点击链接
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return YES;
}
@end
