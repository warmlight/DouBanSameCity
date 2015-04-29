//
//  EventDetailScrollerVIew.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailScrollerVIew.h"

//static inline NSRegularExpression * NameRegularExpression() {
//    static NSRegularExpression *_nameRegularExpression = nil;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionCaseInsensitive error:nil];
//    });
//    
//    return _nameRegularExpression;
//}
//
//static inline NSRegularExpression * ParenthesisRegularExpression() {
//    static NSRegularExpression *_parenthesisRegularExpression = nil;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"0\\d{2,3}-\\d{5,9}|0\\d{2,3}-\\d{5,9}" options:NSRegularExpressionCaseInsensitive error:nil];
//    });
//    
//    return _parenthesisRegularExpression;
//}


@implementation EventDetailScrollerVIew
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
//        self.titleLabel = [[UILabel alloc] init];
//        self.titleLabel.font = TitleBoldFont;
//        self.titleLabel.numberOfLines = 0;
//        [self addSubview:self.titleLabel];
//        
        self.eventImg = [[UIImageView alloc] init];
        self.eventImg.backgroundColor = [UIColor redColor];
        self.eventImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZoomInImage:)];
        [self.eventImg addGestureRecognizer:tap];
        self.bandLabel = [[UILabel alloc] init];
        self.bandLabel.font = TitleF;
        self.bandLabel.backgroundColor = UIColorFromRGB(0xE0FFFF);
        [self addSubview:self.bandLabel];
        
        
        self.contentLabelBkg = [[UIView alloc] init];
        self.contentLabelBkg.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentLabelBkg];
        
        self.contentLabel = [[UITextView alloc] init];
        self.contentLabel.delegate = self;
        self.contentLabel.scrollEnabled = NO;
        self.contentLabel.editable = NO;
        self.contentLabel.font = TextF;
        self.contentLabel.backgroundColor = [UIColor whiteColor];
        self.contentLabel.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress;
        self.contentLabel.textContainerInset = UIEdgeInsetsZero;
        [self addSubview:self.contentLabel];
        
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        
        self.bkgImageView = [[UIImageView alloc] init];
        [self.bkgImageView insertSubview:self.effectView atIndex:0];
        [self addSubview:self.bkgImageView];
      
        [self addSubview:self.eventImg];

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
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];

    NSDictionary *textAttibute = @{NSFontAttributeName:TextF, NSParagraphStyleAttributeName:paragraphStyle};
    NSDictionary *titleAttibute = @{NSFontAttributeName:TitleF};
    
    //bkgImage
    [self.bkgImageView sd_setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    
    CGFloat bkgImageX = 0;
    CGFloat bkgImageY = 0;
    CGFloat bkgImageW = screenWidth;
    CGFloat bkgImageH = 300;
    self.bkgImageView.frame = CGRectMake(bkgImageX, bkgImageY, bkgImageW, bkgImageH);
    
    //effentView
    self.effectView.frame = CGRectMake(bkgImageX, bkgImageY, bkgImageW, bkgImageH);
    
    //eventImage
    [self.eventImg sd_setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    
    CGFloat eventImageW = EventImageW;
    CGFloat eventImageH = EventImageH;
    CGFloat eventImageX = (screenWidth - eventImageW) / 2;
    CGFloat eventImageY = BigMargin;
    self.eventImg.frame = CGRectMake(eventImageX, eventImageY, eventImageW, eventImageH);

    
    //band label
    self.bandLabel.text = @"  活动详情";
    
    CGFloat bandX = 0;
    CGFloat bandY = bkgImageH + bkgImageY;
    CGFloat bandW = screenWidth;
    CGSize bandConstraint = CGSizeMake(bandW, 20000.0);
    CGRect bandRect = [self.bandLabel.text boundingRectWithSize:bandConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttibute context:nil];
    CGFloat bandH = bandRect.size.height;
    self.bandLabel.frame = CGRectMake(bandX, bandY, bandW, bandH);
    
    
    //contentlabel
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:event.content attributes:textAttibute];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [event.content length])];
    self.contentLabel.attributedText = attributedString;
    
    CGFloat contentX = SmallMargin;
    CGFloat contentY = bandY + bandH + SmallMargin;
    CGFloat contentW = screenWidth - 2*SmallMargin;
    CGSize contentConstraint = CGSizeMake(contentW, 200000.0);
    CGRect contentRect = [attributedString boundingRectWithSize:contentConstraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat contentH = contentRect.size.height + 60;

    self.contentLabel.frame = CGRectMake(contentX, contentY, contentW, contentH);

    //contenlabelbkg
    CGFloat contentBkgX = 0;
    CGFloat contentBkgY = bandH + bandY;
    CGFloat contentBkgW = screenWidth;
    CGFloat contentBkgH = contentH + SmallMargin;
    if (contentH < ([UIScreen mainScreen].bounds.size.height - contentY)) {
        contentBkgH = [UIScreen mainScreen].bounds.size.height - contentY -SmallMargin;
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
