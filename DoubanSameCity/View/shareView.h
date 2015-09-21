//
//  shareView.h
//  shareView
//
//  Created by yiban on 15/9/18.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareIcon.h"
@interface shareView : UIView<UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableArray *buttonArray;

- (void)addIconWithTiltle:(NSString *)title icon:(UIImage *)image selectedBlock:(selectedIcon)block;
- (void)show;
@end
