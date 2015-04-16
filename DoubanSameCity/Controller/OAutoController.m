//
//  OAutoController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "OAutoController.h"

@interface OAutoController ()

@end

@implementation OAutoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"授权";
    
    NSString *u = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", APIKey, RedirectURL];
    NSURL *url = [NSURL URLWithString:u];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 获取全路径，将URL转换成字符串
    NSString *url = request.URL.absoluteString;
    NSLog(@"request.URL.absoluteString :%@", url);
    
    // 查找code范围
    NSRange range = [url rangeOfString:@"code="];
    if (range.length){                                  // 如果有，取"code="后跟的串，即为requestToken
        NSInteger index = range.location + range.length;
        NSString *requestToken = [url substringFromIndex:index];
        
        Account *account = [API get_access_token:requestToken];
        [account toString];
        [Config saveAccount:account];                   //存储account
        
        if ([Config getLoginUserId]) {
            LaunchController *lauch = [[LaunchController alloc] init];
            [self.navigationController pushViewController:lauch animated:NO];
        }
        
       
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
