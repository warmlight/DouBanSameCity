//
//  EventDetailController.h
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailScrollerVIew.h"
#import "Event.h"

@interface EventDetailController : UIViewController<JoinWishDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) EventDetailScrollerVIew *scrollerView;
@property (strong, nonatomic) Event *event;

- (void)initUI:(Event *)event;
@end
