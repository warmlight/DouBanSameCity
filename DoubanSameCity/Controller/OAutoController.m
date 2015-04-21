
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
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.alpha = 0;
    
    self.title = @"授权";
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self. webView = [[UIWebView alloc]initWithFrame:bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSString *u = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", APIKey, RedirectURL];
    NSURL *url = [NSURL URLWithString:u];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    
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
        _reqeustToken = [url substringFromIndex:index];

        dispatch_queue_t queue =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queue, ^{
           
            Account *account = [API get_access_token:_reqeustToken];
            User *user = [API get_user:account.douban_user_id];
            [account toString];
            [Config saveAccount:account];                   //存储account
            [Config saveUser:user];
   
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:_webView animated:YES];
                if ([Config getLoginUserId]) {
                    LaunchController *lauch = [[LaunchController alloc] init];
                    [self.navigationController pushViewController:lauch animated:NO];
                }
            });
        });
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 引入第三方框架"MBProgressHUD"添加页面加载提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"努力加载中";                    // 设置文字
    hud.labelFont = [UIFont systemFontOfSize:14];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 清除页面加载提示
    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
