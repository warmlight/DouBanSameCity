//
//  FullScreenLargeImageShowUtils.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/23.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
@interface FullScreenLargeImageShowUtils : NSObject

+(void)showImage:(UIImageView *)smallImageView large_image_url:(NSString *)large_image_url;

@end
