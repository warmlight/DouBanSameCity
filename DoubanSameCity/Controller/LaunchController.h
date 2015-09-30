//
//  LaunchController.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureLayout.h>
#import <FBShimmeringView.h>
#import <FBShimmering.h>
//#import "NavigationController.h"
#import "RootViewController.h"


@interface LaunchController : UIViewController<SideMenuDelegate>
{
    UIImageView *_wallpaperView;
    FBShimmeringView *_shimmeringView;
    UIView *_contentView;
    UILabel *_logoLabel;
    
    UILabel *_valueLabel;
    
    CGFloat _panStartValue;
    BOOL _panVertical;
    BOOL _didUpdate;
}




@end
