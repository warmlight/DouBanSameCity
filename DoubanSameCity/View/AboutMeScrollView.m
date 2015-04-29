//
//  AboutMeScrollView.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/28.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "AboutMeScrollView.h"

@implementation AboutMeScrollView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.headView = [[HeadPortraitView alloc] initWithFrame:CGRectMake(0, 0, HeadImageW, HeadImageW)];//坐标后面会重定义，这里主要是为了给宽高确定头像大小
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead)];
//        [self.headView addGestureRecognizer:tap];
//        self.headView.userInteractionEnabled = YES;
        
        self.name = [[UILabel alloc] init];
        self.name.font = NameBoldFont;
        self.name.textColor = TopTextColor;
        self.name.textAlignment = NSTextAlignmentCenter;
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.textColor = TitleColor;
        self.descLabel.font = ContentFont;
        [self addSubview:self.descLabel];
        
        self.desc = [[UILabel alloc] init];
        self.desc.font = ContentFont;
        self.desc.textColor = TextColor;
        self.desc.numberOfLines = 0;
        [self addSubview:self.desc];
        
        self.cityLabel = [[UILabel alloc] init];
        self.cityLabel.textColor = TitleColor;
        self.cityLabel.font = ContentFont;
        [self addSubview:self.cityLabel];
        
        self.city = [[UILabel alloc] init];
        self.city.font = ContentFont;
        self.city.textColor = TextColor;
        [self addSubview:self.city];
        
        self.registrationLabel = [[UILabel alloc] init];
        self.registrationLabel.textColor = TitleColor;
        self.registrationLabel.font = ContentFont;
        [self addSubview:self.registrationLabel];
        
        self.registration = [[UILabel alloc] init];
        self.registration.textColor = TextColor;
        self.registration.font = ContentFont;
        [self addSubview:self.registration];
        
        self.doubanLabel = [[UILabel alloc] init];
        self.doubanLabel.textColor = TitleColor;
        self.doubanLabel.font = ContentFont;
        [self addSubview:self.doubanLabel];
        
        self.doubanUrl = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        self.doubanUrl.textContainerInset = UIEdgeInsetsZero;
        self.doubanUrl.scrollEnabled = NO;
        self.doubanUrl.editable = NO;
        self.doubanUrl.dataDetectorTypes = UIDataDetectorTypeLink;
        self.doubanUrl.delegate = self;
        self.doubanUrl.font = ContentFont;
        [self addSubview:self.doubanUrl];
        
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [self.effectView.contentView addSubview:self.name];
        [self.effectView.contentView addSubview:self.headView];
        self.effectView.userInteractionEnabled = YES;
        
        self.contentImage = [[UIImageView alloc] init];
        [self.contentImage addSubview:self.effectView];
        [self addSubview:self.contentImage];
        
    }
    return self;
}

//- (void)tapHead{
//    [FullScreenLargeImageShowUtils showImage:self.headView large_image_url:[Config loadUser].avatar];
//}

- (CGFloat)createFrame_Conten{
    User *user = [Config loadUser];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSDictionary *textAttibute = @{NSFontAttributeName:ContentFont};
  
    //head
    [self.headView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    
    CGFloat headX = (screenSize.width - HeadImageW) / 2;
    CGFloat headY = 100;
    CGFloat headW = HeadImageW;
    CGFloat headH = headW;
    self.headView.frame = CGRectMake(headX, headY, headW, headH);
    
    
    //name
    self.name.text = user.name;
    
    CGFloat nameX = MaxMargin;
    CGFloat nameY = headY + headH + SmallMargin;
    CGFloat nameW = screenSize.width - MaxMargin * 2;
    CGFloat nameH = 30;
    self.name.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    //visualeffect
    CGFloat effectX = 0;
    CGFloat effectY = 0;
    CGFloat effectW = screenSize.width;
    CGFloat effentH = 300;
    
    self.contentImage.frame = CGRectMake(effectX, effectY, effectW, effentH);
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    self.effectView.frame = CGRectMake(effectX, effectY, effectW, effentH);
    
    //citylabel
    self.cityLabel.text = @"地区";
    
    CGFloat cityLabelX = MaxMargin;
    CGFloat cityLabelY = effectY + effentH + MaxMargin / 2;
    CGRect cityRect =  [@"地区" boundingRectWithSize:CGSizeMake(2000, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttibute context:nil];
    CGFloat cityLabelW = cityRect.size.width;
    CGFloat cityLabelH = cityRect.size.height;
    self.cityLabel.frame = CGRectMake(cityLabelX, cityLabelY, cityLabelW, cityLabelH);
    
    
    //city
    self.city.text = user.loc_name;
    
    CGFloat cityX = cityLabelX + cityLabelW + SmallMargin;
    CGFloat cityY = cityLabelY;
    CGFloat cityW = screenSize.width - cityX - MaxMargin;
    CGFloat cityH = cityLabelH;
    self.city.frame = CGRectMake(cityX, cityY, cityW, cityH);
    
    //registerLabel
    self.registrationLabel.text = @"豆龄";
    
    CGFloat registrationLabelX = cityLabelX;
    CGFloat registrationLabelY = cityLabelH + cityLabelY + SmallMargin;
    CGFloat registrationLabelW = cityLabelW;
    CGFloat registrationLabelH = cityLabelH;
    self.registrationLabel.frame = CGRectMake(registrationLabelX, registrationLabelY, registrationLabelW, registrationLabelH);
    
    //register
    self.registration.text = [self timedifference:user.created];
    
    CGFloat registrationX = cityX;
    CGFloat registrationY = registrationLabelY;
    CGFloat registrationW = cityW;
    CGFloat registrationH = registrationLabelH;
    self.registration.frame = CGRectMake(registrationX, registrationY, registrationW, registrationH);
    
    //doubanLabel
    self.doubanLabel.text = @"首页";
    
    CGFloat doubanLabelX = cityLabelX;
    CGFloat doubanLabelY = registrationLabelY + registrationLabelH + SmallMargin;
    CGFloat doubanLabelW = cityLabelW;
    CGFloat doubanLabelH = cityLabelH;
    self.doubanLabel.frame = CGRectMake(doubanLabelX, doubanLabelY, doubanLabelW, doubanLabelH);
    
    //douban
    self.doubanUrl.text = user.alt;
    
    CGFloat doubanX = registrationX;
    CGFloat doubanY = doubanLabelY;
    CGFloat doubanW = registrationW;
    CGRect urlRect = [user.alt boundingRectWithSize:CGSizeMake(doubanW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttibute context:nil];
    CGFloat doubanH = urlRect.size.height;
    self.doubanUrl.frame = CGRectMake(doubanX, doubanY, doubanW, doubanH);
    
    //descLabel
    self.descLabel.text = @"自我介绍";
    
    CGFloat descLabelX = doubanLabelX;
    CGFloat descLabelY = doubanLabelY + doubanLabelH + MaxMargin;
    CGRect descLabelRect = [@"自我介绍" boundingRectWithSize:CGSizeMake(2000, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttibute context:nil];
    CGFloat descLabelW = descLabelRect.size.width;
    CGFloat descLabelH = descLabelRect.size.height;
    self.descLabel.frame = CGRectMake(descLabelX, descLabelY, descLabelW, descLabelH);
    
    //desc
    self.desc.text = user.desc;
    
    CGFloat descX = descLabelX;
    CGFloat descY = descLabelY + descLabelH + SmallMargin;
    CGFloat descW = screenSize.width - 2 *MaxMargin;
    CGRect descRect = [user.desc boundingRectWithSize:CGSizeMake(descW, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttibute context:nil];
    CGFloat descH = descRect.size.height;
    self.desc.frame = CGRectMake(descX, descY, descW, descH);
    
    if ((descY + descH) < screenSize.height) {
        return screenSize.height;
    }else{
        return descY + descH + 2 *SmallMargin;
    }
}

//时差
- (NSString *)timedifference:(NSString *)createTime{
    //当前时间
    NSDate* dateNow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dateNow timeIntervalSince1970]*1;
    
    //注册时间
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-M-d HH:mm:ss"];
    NSDate *d=[date dateFromString:createTime];
    NSTimeInterval dead=[d timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - dead;
    NSString *timeString=@"";
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天", timeString];
        
    }
    if (cha/2592000>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/2592000];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@个月", timeString];
        
    }
    if (cha/31104000>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/31104000];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@年", timeString];
        
    }
    return timeString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
