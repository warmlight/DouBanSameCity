//
//  FullScreenLargeImageShowUtils.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/23.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "FullScreenLargeImageShowUtils.h"
static CGRect oldframe;
@implementation FullScreenLargeImageShowUtils
+(void)showImage:(UIImageView *)smallImageView large_image_url:(NSString *)large_image_url{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[smallImageView convertRect:smallImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha=1;
        imageView.frame = backgroundView.frame;
    } completion:^(BOOL finished) {
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat progressW = screenSize.width / 2;
        CGFloat progressH = 10;
        CGFloat progressX = (screenSize.width - progressW) / 2;
        CGFloat progressY = (screenSize.height - progressH) / 2;
        progressView.frame = CGRectMake(progressX, progressY, progressW, progressH);
        progressView.progressTintColor = [UIColor whiteColor];
        progressView.trackTintColor = [UIColor orangeColor];
        [imageView addSubview:progressView];
        
        UILabel *percentLabel = [[UILabel alloc] init];
        CGFloat percentW = 100;
        CGFloat percentH = 50;
        CGFloat percentX = (screenSize.width - percentW) / 2;
        CGFloat percentY = progressY - percentH - 30;
        percentLabel.textColor = [UIColor whiteColor];
        percentLabel.frame = CGRectMake(percentX, percentY, percentW, percentH);
        percentLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:percentLabel];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:large_image_url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            progressView.progress = receivedSize / expectedSize;//进度
            percentLabel.text = [NSString stringWithFormat:@"%.2lf%%" ,progressView.progress];

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [percentLabel removeFromSuperview];
            [progressView removeFromSuperview];
            imageView.image = image;
            NSLog(@"下载完成");
        }];
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
