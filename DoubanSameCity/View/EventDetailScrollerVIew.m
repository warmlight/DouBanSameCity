//
//  EventDetailScrollerVIew.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailScrollerVIew.h"
#import "Toast.h"

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
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
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
        
        self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.joinButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        //self.joinButton.backgroundColor = [UIColor clearColor];
        [self.joinButton setTitle:@" 参加" forState:UIControlStateNormal];
        [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.joinButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self.joinButton setImage:[UIImage imageNamed:@"gray_heart.png"] forState:UIControlStateNormal];
        [self.joinButton setImage:[UIImage imageNamed:@"red_heart.png"] forState:UIControlStateSelected];
        [self.joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.joinButton];
        
        self.wishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.wishButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        self.wishButton.backgroundColor = [UIColor clearColor];
        [self.wishButton setTitle:@" 感兴趣" forState:UIControlStateNormal];
        [self.wishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.wishButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self.wishButton setImage:[UIImage imageNamed:@"gray_heart"] forState:UIControlStateNormal];
        [self.wishButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateSelected];
        [self.wishButton addTarget:self action:@selector(wishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.wishButton];
        
        
        self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addressButton setImage:[UIImage imageNamed:@"information_province.png"] forState:UIControlStateNormal];
        [self.addressButton addTarget:self  action:@selector(callMap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addressButton];

    }
    return self;
}

#pragma mark -join wish button click
- (void)wishButtonClick:(UIButton *)sender {
    if ([self.JoinWishdelegate respondsToSelector:@selector(wish:)]) {
        [self.JoinWishdelegate wish:sender];
    }
}

- (void)joinButtonClick:(UIButton *)sender {
    if ([self.JoinWishdelegate respondsToSelector:@selector(participate:)]) {
        [self.JoinWishdelegate participate:sender];
    }
//    NSNumber *codeNumber = [NSNumber numberWithInt:202];
//    if (([code.code compare:codeNumber] == NSOrderedSame) && code.code != nil) {
//        self.joinButton.selected = !self.joinButton.selected;
//        if (self.joinButton.selected) {
//            [[[[Toast makeText:@"参加成功"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
//            self.wishButton.selected = NO;  //感兴趣和参加不能同时，后台会自动处理为一个
//        }else {
//            [[[[Toast makeText:@"取消参加成功"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
//        }
//
//    }
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
    //addressbtn
    CGFloat addrX = screenWidth - BigMargin - ButtonH - 20;
    CGFloat addrY = 64;
    CGFloat addrW = 50;
    CGFloat addrH = addrW;
    self.addressButton.frame = CGRectMake(addrX, addrY, addrW, addrH);
    
    //bkgImage
    [self.bkgImageView sd_setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    
    CGFloat bkgImageX = 0;
    CGFloat bkgImageY = 0;
    CGFloat bkgImageW = screenWidth;
    CGFloat bkgImageH = 300 + 64;
    self.bkgImageView.frame = CGRectMake(bkgImageX, bkgImageY, bkgImageW, bkgImageH);
    
    //effentView
    self.effectView.frame = CGRectMake(bkgImageX, 0, bkgImageW, bkgImageH);
    
    //eventImage
    [self.eventImg sd_setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    
    CGFloat eventImageW = EventImageW;
    CGFloat eventImageH = EventImageH;
    CGFloat eventImageX = (screenWidth - eventImageW) / 2;
    CGFloat eventImageY = 64;
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
    CGSize contentConstraint = CGSizeMake(contentW - SmallMargin, 200000.0);
    CGRect contentRect = [attributedString boundingRectWithSize:contentConstraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat contentH = contentRect.size.height + SmallMargin;

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
    
    //joinBtn
    CGFloat joinX = 2 *BigMargin;
    CGFloat joinY = eventImageY + eventImageH + BigMargin;
    CGFloat joinW = Buttonw;
    CGFloat joinH = ButtonH;
    self.joinButton.frame = CGRectMake(joinX, joinY, joinW, joinH);

    //wishBtn
    CGFloat wishX = screenWidth - 2 *BigMargin - Buttonw;
    CGFloat wishY = joinY;
    CGFloat wishW = Buttonw;
    CGFloat wishH = ButtonH;
    self.wishButton.frame = CGRectMake(wishX, wishY, wishW, wishH);
    // self.wishButton.selected = YES;

    
//    [self createAtributeContentLabel:event];
    return contentBkgY + contentH + SmallMargin;
    
}

- (void)callMap:(UIButton *)sender{
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@" " message:@"选择要打开使用的程序" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *appleMap = [UIAlertAction actionWithTitle:@"Apple Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        NSArray *location = [self.event.geo componentsSeparatedByString:@" "];
        CLLocationCoordinate2D  endCoor = {[location[0] intValue], [location[1] intValue]};
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
        toLocation.name = self.event.address;
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];

    }];
    UIAlertAction *baiduMap = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *geo = [self.event.geo componentsSeparatedByString:@" "];
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/geocoder?location=%@,%@&coord_type=gcj02&src=guanzhong" ,geo[0], geo[1]];
        NSString *  urlString = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *mapUrl = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:mapUrl]){
            [[UIApplication sharedApplication] openURL:mapUrl];
        }
        else{
            NSLog(@"NO baiduMap");
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [sheetController addAction:appleMap];
    [sheetController addAction:baiduMap];
    [sheetController addAction:cancelAction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSheetView" object:sheetController];
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
