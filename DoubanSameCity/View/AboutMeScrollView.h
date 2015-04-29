//
//  AboutMeScrollView.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/28.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadPortraitView.h"
#import "User.h"
#import "Config.h"
#import <UIImageView+WebCache.h>
//#import "FullScreenLargeImageShowUtils.h"
#define NameFont [UIFont systemFontOfSize:15]
#define ContentFont [UIFont systemFontOfSize:15]
#define NameBoldFont [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
#define TopTextColor [UIColor whiteColor]
#define TitleColor [UIColor lightGrayColor]
#define TextColor [UIColor blackColor]
#define MaxMargin 40
#define SmallMargin 10
#define HeadImageW 100

@interface AboutMeScrollView : UIScrollView<UITextViewDelegate>
@property (strong, nonatomic) HeadPortraitView *headView;
//@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *cityLabel;
@property (strong, nonatomic) UILabel *city;
@property (strong, nonatomic) UILabel *registrationLabel;
@property (strong, nonatomic) UILabel *registration;
@property (strong, nonatomic) UILabel *doubanLabel;
@property (strong, nonatomic) UITextView *doubanUrl;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *desc;
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) UIImageView *contentImage;

- (CGFloat)createFrame_Conten;

@end
