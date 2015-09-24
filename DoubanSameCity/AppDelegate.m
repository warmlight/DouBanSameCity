//
//  AppDelegate.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/15.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    if ([Config getLoginUserId]) {//登陆过直接显示launch界面
//    nav = [[UINavigationController alloc] initWithRootViewController:[[LaunchController alloc] init]];
//      NSLog(@"%@", [Config loadAccount].access_token);
//    }else{
//    nav = [[UINavigationController alloc] initWithRootViewController:[[OAutoController alloc] init]];
//    }
//    nav = [[UINavigationController alloc] initWithRootViewController:[[LaunchController alloc] init]];
    self.window.rootViewController = [[LaunchController alloc] init];
    [self.window makeKeyAndVisible];
    
    
    
    
    [ShareSDK registerApp:@"a460bd5923cf"];
    [ShareSDK connectSinaWeiboWithAppKey:@"3297713090"
                               appSecret:@"20bdfeb8479e7b05a993f6270a8f548a"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    [ShareSDK  connectSinaWeiboWithAppKey:@"3297713090"
                                appSecret:@"20bdfeb8479e7b05a993f6270a8f548a"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104854408"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectDoubanWithAppKey:@"0c64cd6d91fb7474252e6848b5f25d5c"
                            appSecret:@"0e0ee1a0742a7637"
                          redirectUri:@"https://www.douban.com/"];
    
    [ShareSDK connectWeChatWithAppId:@"wx6d03d0596d338f96"
                           appSecret:@"cba64cc7e8c8597e99f607fa1f6cbfde"
                           wechatCls:[WXApi class]];
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
