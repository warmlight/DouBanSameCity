
//
//  shareView.m
//  shareView
//
//  Created by yiban on 15/9/18.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import "shareView.h"
#import <QuartzCore/CALayer.h>
#define horizontalMargin 20
#define verticalMargin 40
#define CHTumblrMenuViewTag 1999

@implementation shareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.buttonArray = [[NSMutableArray alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < self.buttonArray.count; i ++) {
        shareIcon *icon = self.buttonArray[i];
        icon.frame = [self iconFrmae:i];
        [self gameCenterBubble:icon];
        [UIView animateWithDuration:1.5 delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGPoint center = icon.center;
            center.x += 200;
            icon.center = center;
            
        } completion:^(BOOL finished) {
            CGRect iconRect = icon.frame;
            iconRect.origin.x += 200;
        }];
    }
}


- (void)addIconWithTiltle:(NSString *)title icon:(UIImage *)image selectedBlock:(selectedIcon)block {
    shareIcon *icon = [[shareIcon alloc] initWithTitle:title icon:image selectedBlock:block];
    [self addSubview:icon];
    [self.buttonArray addObject:icon];
    [icon addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)buttonTapped:(shareIcon *)icon {
    [self removeFrommCenter:icon];
    icon.selcetedBlock();
}


- (void)removeFrommCenter:(shareIcon *)button {
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint center = button.center;
        center.x += 300;
        button.center = center;
    } completion:^(BOOL finished) {
        CGRect iconRect = button.frame;
        iconRect.origin.x += 300;
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}


- (CGRect)iconFrmae :(NSUInteger)index {
    //每行几个
    NSUInteger countOfEveryRow = 3;
    //位于第几个
    NSUInteger iconIndex = index % countOfEveryRow;
    
    //一共几行
    NSUInteger rowCount = self.buttonArray.count / countOfEveryRow + (self.buttonArray.count % countOfEveryRow > 0 ?1 : 0);
    //按钮位于第几行
    NSUInteger rowOfIcon = index / countOfEveryRow;
    
    //按钮总共多高
    CGFloat iconsHeight = (iconHeight + titleHeight) * rowCount + (rowCount > 1 ? verticalMargin * (rowCount - 1) : 0);
    //第一行距离顶部的距离
    CGFloat offSetY = (self.bounds.size.height - iconsHeight) / 2;
    //距离两侧的距离
    CGFloat verticalPadding = (self.bounds.size.width - (countOfEveryRow * iconHeight + (countOfEveryRow - 1) * horizontalMargin)) / 2;
    
    //按钮x
    CGFloat offsetX = verticalPadding + iconIndex * (iconHeight + horizontalMargin);
    offSetY += (iconHeight + verticalMargin) * rowOfIcon;
    
    //frame
    CGRect buttonFrame = CGRectMake(offsetX - 200, offSetY, iconHeight, iconHeight);
    return buttonFrame;
}


- (void)show{
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    
    appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:CHTumblrMenuViewTag]) {
        [[topViewController.view viewWithTag:CHTumblrMenuViewTag] removeFromSuperview];
    }
    
    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];   //调用layoutSubviews
}


- (void)dismiss:(id *)sender{
    for (int i = 0; i < self.buttonArray.count; i ++) {
        shareIcon *icon = self.buttonArray[i];
        icon.selcetedBlock = nil;
        [self removeFrommCenter:icon];
    }
}


- (void)gameCenterBubble :(UIButton *)button {
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect iconRect = button.frame;
    iconRect.origin.x += 200;
    CGRect circleConstainer = CGRectInset(iconRect, button.bounds.size.width / 2 - 5 , button.bounds.size.height / 2 - 5);
    CGPathAddEllipseInRect(curvedPath, NULL, circleConstainer);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 3;
    //    [button.layer addAnimation:pathAnimation forKey:@"circleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1.5;
    scaleX.values = @[@1.0,@1.1,@1.0];
    scaleX.keyTimes = @[@0, @0.5, @1];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [button.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 2;
    scaleY.values = @[@1.0,@1.1,@1.0];
    scaleY.keyTimes = @[@0, @0.5, @1];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [button.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}
@end
