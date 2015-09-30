//
//  LaunchController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "LaunchController.h"

@interface LaunchController ()

@end

@implementation LaunchController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor blackColor];
    
    _wallpaperView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _wallpaperView.image = [UIImage imageNamed:@"bkg.png"];
    _wallpaperView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_wallpaperView];
    
    _shimmeringView = [FBShimmeringView newAutoLayoutView];
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringBeginFadeDuration = 0.2;
    _shimmeringView.shimmeringOpacity = 0.8;
    [self.view addSubview:_shimmeringView];
    
    _logoLabel = [UILabel newAutoLayoutView];
    _logoLabel.text = @"Same City";
    _logoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:60.0];
    _logoLabel.textColor = [UIColor whiteColor];
    _logoLabel.textAlignment = NSTextAlignmentCenter;
    _logoLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = _logoLabel;
    
      [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(pushController) userInfo:nil repeats:NO];//计时跳转界面
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped:)];
//    [self.view addGestureRecognizer:tapRecognizer];
//
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panned:)];
//    [self.view addGestureRecognizer:panRecognizer];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)pushController{
//    NavigationController *nav = [[NavigationController alloc] init];
    RootViewController *root = [[RootViewController alloc] init];
    [self presentViewController:root animated:NO completion:nil];
}

- (void)updateViewConstraints
{
    if (!_didUpdate) {
        [_shimmeringView autoCenterInSuperview];
        [_shimmeringView autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero];
        _didUpdate = YES;
    }
    [super updateViewConstraints];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    CGRect shimmeringFrame = self.view.bounds;
//    shimmeringFrame.origin.y = shimmeringFrame.size.height * 0.68;
//    shimmeringFrame.size.height = shimmeringFrame.size.height * 0.32;
//    _shimmeringView.frame = shimmeringFrame;
//}

//- (void)_tapped:(UITapGestureRecognizer *)tapRecognizer
//{
//    NavigationController *nav = [[NavigationController alloc] init];
//    
//}

//- (void)_panned:(UIPanGestureRecognizer *)panRecognizer
//{
//    CGPoint translation = [panRecognizer translationInView:self.view];
//    CGPoint velocity = [panRecognizer velocityInView:self.view];
//    
//    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
//        _panVertical = (fabsf(velocity.y) > fabsf(velocity.x));
//        
//        if (_panVertical) {
//            _panStartValue = _shimmeringView.shimmeringSpeed;
//        } else {
//            _panStartValue = _shimmeringView.shimmeringOpacity;
//        }
//        
//        [self _animateValueLabelVisible:YES];
//    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
//        CGFloat directional = (_panVertical ? translation.y : translation.x);
//        CGFloat possible = (_panVertical ? self.view.bounds.size.height : self.view.bounds.size.width);
//        
//        CGFloat progress = (directional / possible);
//        
//        if (_panVertical) {
//            _shimmeringView.shimmeringSpeed = fmaxf(0.0, fminf(1000.0, _panStartValue + progress * 200.0));
//            _valueLabel.text = [NSString stringWithFormat:@"Speed\n%.1f", _shimmeringView.shimmeringSpeed];
//        } else {
//            _shimmeringView.shimmeringOpacity = fmaxf(0.0, fminf(1.0, _panStartValue + progress * 0.5));
//            _valueLabel.text = [NSString stringWithFormat:@"Opacity\n%.2f", _shimmeringView.shimmeringOpacity];
//        }
//    } else if (panRecognizer.state == UIGestureRecognizerStateEnded ||
//               panRecognizer.state == UIGestureRecognizerStateCancelled) {
//        [self _animateValueLabelVisible:NO];
//    }
//}
//
//- (void)_animateValueLabelVisible:(BOOL)visible
//{
//    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
//    void (^animations)() = ^{
//        _valueLabel.alpha = (visible ? 1.0 : 0.0);
//    };
//    [UIView animateWithDuration:0.5 delay:0.0 options:options animations:animations completion:NULL];
//}
@end
