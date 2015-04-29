//
//  OAutoController.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "API.h"
#import "Account.h"
#import "Config.h"
//#import "LaunchController.h"
#import "EventListController.h"
#import <PureLayout.h>
@interface OAutoController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *reqeustToken;

@end
