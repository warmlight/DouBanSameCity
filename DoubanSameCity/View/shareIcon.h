//
//  shareIcon.h
//  shareView
//
//  Created by yiban on 15/9/18.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#define iconHeight 60
#define titleHeight 20
typedef void(^selectedIcon)(void);
@interface shareIcon : UIButton
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titlelabel;
@property (copy, nonatomic) selectedIcon selcetedBlock;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon selectedBlock:(selectedIcon)block;
@end
